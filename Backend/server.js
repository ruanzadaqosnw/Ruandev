/**
 * Ruan Dev API Server - Backend
 * 
 * Servidor Node.js/Express para gerenciar packages, keys, devices e usuários
 * 
 * Instalação:
 * npm install express cors bcryptjs jsonwebtoken sqlite3 uuid
 * 
 * Execução:
 * node server.js
 */

const express = require('express');
const cors = require('cors');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const { v4: uuidv4 } = require('uuid');
const sqlite3 = require('sqlite3').verbose();

const app = express();
const PORT = process.env.PORT || 3000;
const JWT_SECRET = process.env.JWT_SECRET || 'seu-secret-key-aqui';

// Middleware
app.use(cors());
app.use(express.json());

// Database
const db = new sqlite3.Database(':memory:');

// Initialize Database
db.serialize(() => {
    // Users Table
    db.run(`
        CREATE TABLE IF NOT EXISTS users (
            id TEXT PRIMARY KEY,
            username TEXT UNIQUE NOT NULL,
            email TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL,
            vipLevel INTEGER DEFAULT 1,
            createdAt DATETIME DEFAULT CURRENT_TIMESTAMP
        )
    `);

    // Packages Table
    db.run(`
        CREATE TABLE IF NOT EXISTS packages (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            userId TEXT NOT NULL,
            token TEXT UNIQUE NOT NULL,
            status TEXT DEFAULT 'active',
            createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY(userId) REFERENCES users(id)
        )
    `);

    // Keys Table
    db.run(`
        CREATE TABLE IF NOT EXISTS keys (
            id TEXT PRIMARY KEY,
            keyValue TEXT UNIQUE NOT NULL,
            alias TEXT NOT NULL,
            packageId TEXT NOT NULL,
            userId TEXT NOT NULL,
            duration TEXT NOT NULL,
            createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
            expiresAt DATETIME NOT NULL,
            activatedAt DATETIME,
            deviceUDID TEXT,
            isActive BOOLEAN DEFAULT 1,
            FOREIGN KEY(packageId) REFERENCES packages(id),
            FOREIGN KEY(userId) REFERENCES users(id)
        )
    `);

    // Devices Table
    db.run(`
        CREATE TABLE IF NOT EXISTS devices (
            id TEXT PRIMARY KEY,
            udid TEXT NOT NULL,
            packageId TEXT NOT NULL,
            userId TEXT NOT NULL,
            keyId TEXT NOT NULL,
            deviceName TEXT,
            osVersion TEXT,
            isOnline BOOLEAN DEFAULT 1,
            lastSeen DATETIME DEFAULT CURRENT_TIMESTAMP,
            registeredAt DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY(packageId) REFERENCES packages(id),
            FOREIGN KEY(userId) REFERENCES users(id),
            FOREIGN KEY(keyId) REFERENCES keys(id)
        )
    `);

    // Create admin user
    const adminId = uuidv4();
    const adminPassword = bcrypt.hashSync('admin123', 10);
    db.run(
        `INSERT OR IGNORE INTO users (id, username, email, password, vipLevel) 
         VALUES (?, ?, ?, ?, ?)`,
        [adminId, 'admin', 'admin@ruandev.com', adminPassword, 4]
    );
});

// Helper Functions
const generateKey = (alias, duration) => {
    const random = Math.random().toString(36).substring(2, 10).toUpperCase();
    return `${alias}-${duration}-${random}`;
};

const calculateExpiryDate = (duration) => {
    const now = new Date();
    switch(duration) {
        case 'day':
            now.setDate(now.getDate() + 1);
            break;
        case 'week':
            now.setDate(now.getDate() + 7);
            break;
        case 'month':
            now.setMonth(now.getMonth() + 1);
            break;
        case 'year':
            now.setFullYear(now.getFullYear() + 1);
            break;
    }
    return now;
};

// Auth Routes
app.post('/auth/login', (req, res) => {
    const { username, password } = req.body;
    
    db.get('SELECT * FROM users WHERE username = ?', [username], (err, user) => {
        if (err) return res.status(500).json({ error: err.message });
        if (!user) return res.status(401).json({ error: 'Usuário não encontrado' });
        
        if (!bcrypt.compareSync(password, user.password)) {
            return res.status(401).json({ error: 'Senha incorreta' });
        }
        
        const token = jwt.sign({ userId: user.id, username: user.username }, JWT_SECRET);
        res.json({ token, userId: user.id, username: user.username, email: user.email });
    });
});

app.post('/auth/login-with-key', (req, res) => {
    const { key, packageToken } = req.body;
    
    db.get(
        `SELECT k.*, p.userId FROM keys k 
         JOIN packages p ON k.packageId = p.id 
         WHERE k.keyValue = ? AND p.token = ? AND k.isActive = 1`,
        [key, packageToken],
        (err, keyRecord) => {
            if (err) return res.status(500).json({ error: err.message });
            if (!keyRecord) return res.status(401).json({ error: 'Key inválida' });
            
            const expiryDate = new Date(keyRecord.expiresAt);
            if (expiryDate < new Date()) {
                return res.status(401).json({ error: 'Key expirada' });
            }
            
            db.get('SELECT * FROM users WHERE id = ?', [keyRecord.userId], (err, user) => {
                if (err) return res.status(500).json({ error: err.message });
                
                const token = jwt.sign({ userId: user.id, username: user.username }, JWT_SECRET);
                res.json({ 
                    token, 
                    userId: user.id, 
                    username: user.username, 
                    email: user.email 
                });
            });
        }
    );
});

app.post('/auth/validate-key', (req, res) => {
    const { key, packageToken, udid } = req.body;
    
    db.get(
        `SELECT k.*, p.token FROM keys k 
         JOIN packages p ON k.packageId = p.id 
         WHERE k.keyValue = ? AND p.token = ? AND k.isActive = 1`,
        [key, packageToken],
        (err, keyRecord) => {
            if (err) return res.status(500).json({ isValid: false });
            if (!keyRecord) return res.status(200).json({ isValid: false });
            
            const expiryDate = new Date(keyRecord.expiresAt);
            const isValid = expiryDate > new Date();
            
            if (isValid && udid) {
                // Register device
                const deviceId = uuidv4();
                db.run(
                    `INSERT INTO devices (id, udid, packageId, userId, keyId, deviceName, osVersion)
                     VALUES (?, ?, ?, ?, ?, ?, ?)`,
                    [deviceId, udid, keyRecord.packageId, keyRecord.userId, keyRecord.id, 
                     req.body.deviceName || 'Unknown', req.body.osVersion || 'Unknown']
                );
            }
            
            res.json({ isValid });
        }
    );
});

// Middleware para verificar token
const verifyToken = (req, res, next) => {
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) return res.status(401).json({ error: 'Token não fornecido' });
    
    jwt.verify(token, JWT_SECRET, (err, decoded) => {
        if (err) return res.status(401).json({ error: 'Token inválido' });
        req.userId = decoded.userId;
        next();
    });
};

// Packages Routes
app.post('/packages', verifyToken, (req, res) => {
    const { name } = req.body;
    const packageId = uuidv4();
    const token = uuidv4();
    
    db.run(
        `INSERT INTO packages (id, name, userId, token) VALUES (?, ?, ?, ?)`,
        [packageId, name, req.userId, token],
        function(err) {
            if (err) return res.status(500).json({ error: err.message });
            res.json({ id: packageId, name, token });
        }
    );
});

app.get('/packages/:token', (req, res) => {
    db.all(
        `SELECT * FROM packages WHERE token = ?`,
        [req.params.token],
        (err, packages) => {
            if (err) return res.status(500).json({ error: err.message });
            res.json(packages || []);
        }
    );
});

app.get('/packages', verifyToken, (req, res) => {
    db.all(
        `SELECT * FROM packages WHERE userId = ?`,
        [req.userId],
        (err, packages) => {
            if (err) return res.status(500).json({ error: err.message });
            res.json(packages || []);
        }
    );
});

// Keys Routes
app.post('/keys', verifyToken, (req, res) => {
    const { packageId, alias, duration } = req.body;
    const keyId = uuidv4();
    const keyValue = generateKey(alias, duration);
    const expiresAt = calculateExpiryDate(duration);
    
    db.run(
        `INSERT INTO keys (id, keyValue, alias, packageId, userId, duration, expiresAt)
         VALUES (?, ?, ?, ?, ?, ?, ?)`,
        [keyId, keyValue, alias, packageId, req.userId, duration, expiresAt.toISOString()],
        function(err) {
            if (err) return res.status(500).json({ error: err.message });
            res.json({ id: keyId, keyValue, alias, duration, expiresAt });
        }
    );
});

app.get('/keys/my-keys', verifyToken, (req, res) => {
    db.all(
        `SELECT k.*, p.name as packageName FROM keys k
         JOIN packages p ON k.packageId = p.id
         WHERE k.userId = ?
         ORDER BY k.createdAt DESC`,
        [req.userId],
        (err, keys) => {
            if (err) return res.status(500).json({ error: err.message });
            res.json(keys || []);
        }
    );
});

app.get('/keys/:keyId', verifyToken, (req, res) => {
    db.get(
        `SELECT k.*, p.name as packageName FROM keys k
         JOIN packages p ON k.packageId = p.id
         WHERE k.id = ? AND k.userId = ?`,
        [req.params.keyId, req.userId],
        (err, key) => {
            if (err) return res.status(500).json({ error: err.message });
            if (!key) return res.status(404).json({ error: 'Key não encontrada' });
            res.json(key);
        }
    );
});

app.post('/keys/info', verifyToken, (req, res) => {
    const token = req.headers.authorization?.split(' ')[1];
    
    db.get(
        `SELECT k.*, p.name as packageName FROM keys k
         JOIN packages p ON k.packageId = p.id
         WHERE k.keyValue = ?`,
        [token],
        (err, key) => {
            if (err) return res.status(500).json({ error: err.message });
            if (!key) return res.status(404).json({ error: 'Key não encontrada' });
            res.json(key);
        }
    );
});

// Devices Routes
app.post('/devices/register', verifyToken, (req, res) => {
    const { udid, keyId, deviceName, osVersion, modelName } = req.body;
    const deviceId = uuidv4();
    
    db.get('SELECT packageId FROM keys WHERE id = ?', [keyId], (err, key) => {
        if (err) return res.status(500).json({ error: err.message });
        if (!key) return res.status(404).json({ error: 'Key não encontrada' });
        
        db.run(
            `INSERT INTO devices (id, udid, packageId, userId, keyId, deviceName, osVersion)
             VALUES (?, ?, ?, ?, ?, ?, ?)`,
            [deviceId, udid, key.packageId, req.userId, keyId, deviceName, osVersion],
            function(err) {
                if (err) return res.status(500).json({ error: err.message });
                res.json({ id: deviceId, udid, keyId, deviceName, osVersion });
            }
        );
    });
});

app.get('/devices/my-devices', verifyToken, (req, res) => {
    db.all(
        `SELECT * FROM devices WHERE userId = ? ORDER BY lastSeen DESC`,
        [req.userId],
        (err, devices) => {
            if (err) return res.status(500).json({ error: err.message });
            res.json(devices || []);
        }
    );
});

// Health Check
app.get('/health', (req, res) => {
    res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

// Start Server
app.listen(PORT, () => {
    console.log(`🚀 Ruan Dev API Server rodando em http://localhost:${PORT}`);
    console.log(`📝 Admin: admin / admin123`);
});

module.exports = app;
