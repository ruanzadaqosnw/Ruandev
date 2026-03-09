import UIKit

class DevicesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private var devices: [Device] = []
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadDevices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDevices()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)
        
        title = "Meus Devices"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(DeviceCell.self, forCellReuseIdentifier: "DeviceCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        refreshControl.addTarget(self, action: #selector(refreshDevices), for: .valueChanged)
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
    
    private func loadDevices() {
        APIService.shared.getDevices { [weak self] result in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                switch result {
                case .success(let devices):
                    self?.devices = devices.sorted { $0.registeredAt > $1.registeredAt }
                    self?.tableView.reloadData()
                case .failure(let error):
                    self?.showAlert(title: "Erro", message: error.localizedDescription)
                }
            }
        }
    }
    
    @objc private func refreshDevices() {
        loadDevices()
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath) as! DeviceCell
        cell.configure(with: devices[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let device = devices[indexPath.row]
        let detailVC = DeviceDetailViewController(device: device)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - DeviceCell

class DeviceCell: UITableViewCell {
    private let containerView = UIView()
    private let statusIndicator = UIView()
    private let deviceNameLabel = UILabel()
    private let udidLabel = UILabel()
    private let lastSeenLabel = UILabel()
    private let osVersionLabel = UILabel()
    
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
        
        statusIndicator.layer.cornerRadius = 6
        statusIndicator.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(statusIndicator)
        
        deviceNameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        deviceNameLabel.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.3, alpha: 1.0)
        deviceNameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(deviceNameLabel)
        
        udidLabel.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        udidLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        udidLabel.numberOfLines = 1
        udidLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(udidLabel)
        
        lastSeenLabel.font = UIFont.systemFont(ofSize: 11)
        lastSeenLabel.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        lastSeenLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(lastSeenLabel)
        
        osVersionLabel.font = UIFont.systemFont(ofSize: 11)
        osVersionLabel.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        osVersionLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(osVersionLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            statusIndicator.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            statusIndicator.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            statusIndicator.widthAnchor.constraint(equalToConstant: 12),
            statusIndicator.heightAnchor.constraint(equalToConstant: 12),
            
            deviceNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            deviceNameLabel.leadingAnchor.constraint(equalTo: statusIndicator.trailingAnchor, constant: 10),
            deviceNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            udidLabel.topAnchor.constraint(equalTo: deviceNameLabel.bottomAnchor, constant: 6),
            udidLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            udidLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            lastSeenLabel.topAnchor.constraint(equalTo: udidLabel.bottomAnchor, constant: 6),
            lastSeenLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            
            osVersionLabel.topAnchor.constraint(equalTo: lastSeenLabel.bottomAnchor, constant: 4),
            osVersionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            osVersionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
        ])
    }
    
    func configure(with device: Device) {
        deviceNameLabel.text = device.deviceName ?? "Dispositivo Desconhecido"
        udidLabel.text = "UDID: \(device.udid)"
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        lastSeenLabel.text = "Visto: \(formatter.string(from: device.lastSeen))"
        osVersionLabel.text = "iOS \(device.osVersion ?? "?")"
        
        statusIndicator.backgroundColor = device.isOnline ? UIColor(red: 0.0, green: 0.7, blue: 0.3, alpha: 1.0) : UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
    }
}

// MARK: - DeviceDetailViewController

class DeviceDetailViewController: UIViewController {
    
    private let device: Device
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let statusLabel = UILabel()
    private let deviceNameLabel = UILabel()
    private let udidLabel = UILabel()
    private let osVersionLabel = UILabel()
    private let modelLabel = UILabel()
    private let registeredLabel = UILabel()
    private let lastSeenLabel = UILabel()
    private let keyIdLabel = UILabel()
    
    private let backButton = UIButton(type: .system)
    
    init(device: Device) {
        self.device = device
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
        
        setupLabel(statusLabel, title: "Status:", fontSize: 12)
        setupLabel(deviceNameLabel, title: "Nome:", fontSize: 12)
        setupLabel(udidLabel, title: "UDID:", fontSize: 12)
        setupLabel(osVersionLabel, title: "Versão iOS:", fontSize: 12)
        setupLabel(modelLabel, title: "Modelo:", fontSize: 12)
        setupLabel(registeredLabel, title: "Registrado em:", fontSize: 12)
        setupLabel(lastSeenLabel, title: "Último acesso:", fontSize: 12)
        setupLabel(keyIdLabel, title: "Key ID:", fontSize: 12)
        
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
            
            statusLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            deviceNameLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 15),
            deviceNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            deviceNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            udidLabel.topAnchor.constraint(equalTo: deviceNameLabel.bottomAnchor, constant: 15),
            udidLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            udidLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            osVersionLabel.topAnchor.constraint(equalTo: udidLabel.bottomAnchor, constant: 15),
            osVersionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            osVersionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            modelLabel.topAnchor.constraint(equalTo: osVersionLabel.bottomAnchor, constant: 15),
            modelLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            modelLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            registeredLabel.topAnchor.constraint(equalTo: modelLabel.bottomAnchor, constant: 15),
            registeredLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            registeredLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            lastSeenLabel.topAnchor.constraint(equalTo: registeredLabel.bottomAnchor, constant: 15),
            lastSeenLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            lastSeenLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            keyIdLabel.topAnchor.constraint(equalTo: lastSeenLabel.bottomAnchor, constant: 15),
            keyIdLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            keyIdLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            backButton.topAnchor.constraint(equalTo: keyIdLabel.bottomAnchor, constant: 30),
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
        
        statusLabel.text = "Status: \(device.isOnline ? "🟢 Online" : "🔴 Offline")"
        deviceNameLabel.text = "Nome: \(device.deviceName ?? "Desconhecido")"
        udidLabel.text = "UDID: \(device.udid)"
        osVersionLabel.text = "Versão iOS: \(device.osVersion ?? "?")"
        modelLabel.text = "Modelo: \(device.id)"
        registeredLabel.text = "Registrado em: \(formatter.string(from: device.registeredAt))"
        lastSeenLabel.text = "Último acesso: \(formatter.string(from: device.lastSeen))"
        keyIdLabel.text = "Key ID: \(device.keyId)"
    }
    
    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
