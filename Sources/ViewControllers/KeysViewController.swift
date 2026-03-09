import UIKit

class KeysViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private var keys: [APIKey] = []
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadKeys()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadKeys()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)
        
        title = "Minhas Keys"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(KeyCell.self, forCellReuseIdentifier: "KeyCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        refreshControl.addTarget(self, action: #selector(refreshKeys), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func loadKeys() {
        APIService.shared.getUserKeys { [weak self] result in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                switch result {
                case .success(let keys):
                    self?.keys = keys.sorted { $0.createdAt > $1.createdAt }
                    self?.tableView.reloadData()
                case .failure(let error):
                    self?.showAlert(title: "Erro", message: error.localizedDescription)
                }
            }
        }
    }
    
    @objc private func refreshKeys() {
        loadKeys()
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "KeyCell", for: indexPath) as! KeyCell
        cell.configure(with: keys[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let key = keys[indexPath.row]
        let detailVC = KeyDetailViewController(key: key)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - KeyCell

class KeyCell: UITableViewCell {
    private let containerView = UIView()
    private let aliasLabel = UILabel()
    private let keyValueLabel = UILabel()
    private let packageLabel = UILabel()
    private let expiresLabel = UILabel()
    private let statusLabel = UILabel()
    private let copyButton = UIButton(type: .system)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 10
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        aliasLabel.font = UIFont.boldSystemFont(ofSize: 14)
        aliasLabel.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.3, alpha: 1.0)
        aliasLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(aliasLabel)
        
        keyValueLabel.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        keyValueLabel.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        keyValueLabel.numberOfLines = 1
        keyValueLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(keyValueLabel)
        
        packageLabel.font = UIFont.systemFont(ofSize: 12)
        packageLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        packageLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(packageLabel)
        
        expiresLabel.font = UIFont.systemFont(ofSize: 12)
        expiresLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        expiresLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(expiresLabel)
        
        statusLabel.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        statusLabel.textAlignment = .center
        statusLabel.layer.cornerRadius = 4
        statusLabel.layer.masksToBounds = true
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(statusLabel)
        
        copyButton.setTitle("📋", for: .normal)
        copyButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        copyButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(copyButton)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            aliasLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            aliasLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            
            keyValueLabel.topAnchor.constraint(equalTo: aliasLabel.bottomAnchor, constant: 6),
            keyValueLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            keyValueLabel.trailingAnchor.constraint(equalTo: copyButton.leadingAnchor, constant: -8),
            
            packageLabel.topAnchor.constraint(equalTo: keyValueLabel.bottomAnchor, constant: 8),
            packageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            
            expiresLabel.topAnchor.constraint(equalTo: packageLabel.bottomAnchor, constant: 4),
            expiresLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            
            statusLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            statusLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            statusLabel.widthAnchor.constraint(equalToConstant: 70),
            statusLabel.heightAnchor.constraint(equalToConstant: 24),
            
            copyButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            copyButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            copyButton.widthAnchor.constraint(equalToConstant: 40),
            copyButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    func configure(with key: APIKey) {
        aliasLabel.text = "\(key.alias)-\(key.duration)"
        keyValueLabel.text = key.keyValue
        packageLabel.text = "📦 \(key.packageName)"
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        expiresLabel.text = "Expira: \(formatter.string(from: key.expiresAt))"
        
        if key.isActive {
            statusLabel.backgroundColor = UIColor(red: 0.0, green: 0.7, blue: 0.3, alpha: 1.0)
            statusLabel.textColor = .white
            statusLabel.text = "Ativo"
        } else {
            statusLabel.backgroundColor = UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1.0)
            statusLabel.textColor = .white
            statusLabel.text = "Inativo"
        }
        
        copyButton.addAction(UIAction { _ in
            UIPasteboard.general.string = key.keyValue
        }, for: .touchUpInside)
    }
}

// MARK: - KeyDetailViewController

class KeyDetailViewController: UIViewController {
    
    private let key: APIKey
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let keyValueLabel = UILabel()
    private let aliasLabel = UILabel()
    private let packageLabel = UILabel()
    private let durationLabel = UILabel()
    private let createdLabel = UILabel()
    private let expiresLabel = UILabel()
    private let activatedLabel = UILabel()
    private let statusLabel = UILabel()
    private let deviceUDIDLabel = UILabel()
    
    private let copyButton = UIButton(type: .system)
    private let backButton = UIButton(type: .system)
    
    init(key: APIKey) {
        self.key = key
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        populateData()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Setup labels
        setupLabel(keyValueLabel, title: "Key:", fontSize: 12)
        setupLabel(aliasLabel, title: "Alias:", fontSize: 12)
        setupLabel(packageLabel, title: "Package:", fontSize: 12)
        setupLabel(durationLabel, title: "Duração:", fontSize: 12)
        setupLabel(createdLabel, title: "Criada em:", fontSize: 12)
        setupLabel(expiresLabel, title: "Expira em:", fontSize: 12)
        setupLabel(activatedLabel, title: "Ativada em:", fontSize: 12)
        setupLabel(statusLabel, title: "Status:", fontSize: 12)
        setupLabel(deviceUDIDLabel, title: "UDID do Device:", fontSize: 12)
        
        copyButton.setTitle("📋 Copiar Key", for: .normal)
        copyButton.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0)
        copyButton.setTitleColor(.white, for: .normal)
        copyButton.layer.cornerRadius = 8
        copyButton.translatesAutoresizingMaskIntoConstraints = false
        copyButton.addTarget(self, action: #selector(copyKey), for: .touchUpInside)
        contentView.addSubview(copyButton)
        
        backButton.setTitle("← Voltar", for: .normal)
        backButton.backgroundColor = UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1.0)
        backButton.setTitleColor(.white, for: .normal)
        backButton.layer.cornerRadius = 8
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        contentView.addSubview(backButton)
    }
    
    private func setupLabel(_ label: UILabel, title: String, fontSize: CGFloat) {
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            keyValueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            keyValueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            keyValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            aliasLabel.topAnchor.constraint(equalTo: keyValueLabel.bottomAnchor, constant: 15),
            aliasLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            aliasLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            packageLabel.topAnchor.constraint(equalTo: aliasLabel.bottomAnchor, constant: 15),
            packageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            packageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            durationLabel.topAnchor.constraint(equalTo: packageLabel.bottomAnchor, constant: 15),
            durationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            durationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            createdLabel.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 15),
            createdLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            createdLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            expiresLabel.topAnchor.constraint(equalTo: createdLabel.bottomAnchor, constant: 15),
            expiresLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            expiresLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            activatedLabel.topAnchor.constraint(equalTo: expiresLabel.bottomAnchor, constant: 15),
            activatedLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            activatedLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            statusLabel.topAnchor.constraint(equalTo: activatedLabel.bottomAnchor, constant: 15),
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            deviceUDIDLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 15),
            deviceUDIDLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            deviceUDIDLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            copyButton.topAnchor.constraint(equalTo: deviceUDIDLabel.bottomAnchor, constant: 30),
            copyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            copyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            copyButton.heightAnchor.constraint(equalToConstant: 45),
            
            backButton.topAnchor.constraint(equalTo: copyButton.bottomAnchor, constant: 15),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            backButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            backButton.heightAnchor.constraint(equalToConstant: 45),
            backButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
    }
    
    private func populateData() {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        keyValueLabel.text = "Key: \(key.keyValue)"
        aliasLabel.text = "Alias: \(key.alias)"
        packageLabel.text = "Package: \(key.packageName)"
        durationLabel.text = "Duração: \(key.duration)"
        createdLabel.text = "Criada em: \(formatter.string(from: key.createdAt))"
        expiresLabel.text = "Expira em: \(formatter.string(from: key.expiresAt))"
        activatedLabel.text = "Ativada em: \(key.activatedAt.map { formatter.string(from: $0) } ?? "Não ativada")"
        statusLabel.text = "Status: \(key.isActive ? "Ativa" : "Inativa")"
        deviceUDIDLabel.text = "UDID: \(key.deviceUDID ?? "Não registrado")"
    }
    
    @objc private func copyKey() {
        UIPasteboard.general.string = key.keyValue
        showAlert(title: "Sucesso", message: "Key copiada para a área de transferência!")
    }
    
    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
