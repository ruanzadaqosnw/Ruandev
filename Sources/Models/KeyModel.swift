import Foundation

struct APIKey: Codable {
    let id: String
    let keyValue: String
    let alias: String
    let packageId: String
    let packageName: String
    let userId: String
    let duration: String // "day", "week", "month", "year"
    let createdAt: Date
    let expiresAt: Date
    let isActive: Bool
    let deviceUDID: String?
    let activatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, keyValue, alias, packageId, packageName, userId, duration
        case createdAt, expiresAt, isActive, deviceUDID, activatedAt
    }
}

struct Package: Codable {
    let id: String
    let name: String
    let userId: String
    let token: String
    let createdAt: Date
    let isActive: Bool
    let status: String // "active", "maintenance", "paused", "banned"
    let totalKeys: Int
    let activeKeys: Int
    let totalDevices: Int
    let onlineDevices: Int
}

struct Device: Codable {
    let id: String
    let udid: String
    let packageId: String
    let userId: String
    let keyId: String
    let isOnline: Bool
    let lastSeen: Date
    let registeredAt: Date
    let deviceName: String?
    let osVersion: String?
}

struct UDIDInfo: Codable {
    let udid: String
    let deviceName: String
    let osVersion: String
    let modelName: String
}
