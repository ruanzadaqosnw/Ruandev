import UIKit

class DashboardViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel()
    private let welcomeLabel = UILabel()
    
    // Stats Cards
    private let keysCard = StatsCard()
    private let expiredKeysCard = StatsCard()
    private let packagesCard = StatsCard()
    private let devicesCard = StatsCard()
    private let onlineDevicesCard = StatsCard()
    
    private let logoutButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadDashboardData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDashboardData()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)
        
        // ScrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Title
        titleLabel.text = "Dashboard"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.3, alpha: 1.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // Welcome
        let username = UserDefaults.standard.string(forKey: "username") ?? "Usuário"
        welcomeLabel.text = "Bem-vindo, \(username)! 👋"
        welcomeLabel.font = UIFont.systemFont(ofSize: 14)
        welcomeLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(welcomeLabel)
        
        // Stats Cards
        keysCard.setup(title: "Total de Keys", value: "0", icon: "🔑")
        keysCard.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(keysCard)
        
        expiredKeysCard.setup(title: "Keys Expiradas", value: "0", icon: "⏰")
        expiredKeysCard.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(expiredKeysCard)
        
        packagesCard.setup(title: "Packages", value: "0", icon: "📦")
        packagesCard.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(packagesCard)
        
        devicesCard.setup(title: "Total Devices", value: "0", icon: "📱")
        devicesCard.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(devicesCard)
        
        onlineDevicesCard.setup(title: "Online", value: "0", icon: "🟢")
        onlineDevicesCard.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(onlineDevicesCard)
        
        // Logout Button
        logoutButton.setTitle("Sair", for: .normal)
        logoutButton.backgroundColor = UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1.0)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.layer.cornerRadius = 8
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        contentView.addSubview(logoutButton)
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
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            welcomeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            welcomeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            keysCard.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 25),
            keysCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            keysCard.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -10),
            keysCard.heightAnchor.constraint(equalToConstant: 120),
            
            expiredKeysCard.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 25),
            expiredKeysCard.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 10),
            expiredKeysCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            expiredKeysCard.heightAnchor.constraint(equalToConstant: 120),
            
            packagesCard.topAnchor.constraint(equalTo: keysCard.bottomAnchor, constant: 15),
            packagesCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            packagesCard.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -10),
            packagesCard.heightAnchor.constraint(equalToConstant: 120),
            
            devicesCard.topAnchor.constraint(equalTo: keysCard.bottomAnchor, constant: 15),
            devicesCard.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 10),
            devicesCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            devicesCard.heightAnchor.constraint(equalToConstant: 120),
            
            onlineDevicesCard.topAnchor.constraint(equalTo: packagesCard.bottomAnchor, constant: 15),
            onlineDevicesCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            onlineDevicesCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            onlineDevicesCard.heightAnchor.constraint(equalToConstant: 120),
            
            logoutButton.topAnchor.constraint(equalTo: onlineDevicesCard.bottomAnchor, constant: 30),
            logoutButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            logoutButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            logoutButton.heightAnchor.constraint(equalToConstant: 50),
            logoutButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
    }
    
    private func loadDashboardData() {
        APIService.shared.getUserKeys { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let keys):
                    let totalKeys = keys.count
                    let expiredKeys = keys.filter { $0.expiresAt < Date() }.count
                    self?.keysCard.setValue("\(totalKeys)")
                    self?.expiredKeysCard.setValue("\(expiredKeys)")
                    
                case .failure:
                    break
                }
            }
        }
        
        APIService.shared.getDevices { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let devices):
                    let totalDevices = devices.count
                    let onlineDevices = devices.filter { $0.isOnline }.count
                    self?.devicesCard.setValue("\(totalDevices)")
                    self?.onlineDevicesCard.setValue("\(onlineDevices)")
                    
                case .failure:
                    break
                }
            }
        }
    }
    
    @objc private func logoutTapped() {
        let alert = UIAlertController(title: "Sair", message: "Tem certeza que deseja sair?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Sair", style: .destructive) { _ in
            UserDefaults.standard.removeObject(forKey: "userToken")
            UserDefaults.standard.removeObject(forKey: "userId")
            UserDefaults.standard.removeObject(forKey: "username")
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let loginVC = LoginViewController()
            let navVC = UINavigationController(rootViewController: loginVC)
            appDelegate.window?.rootViewController = navVC
            UIView.transition(with: appDelegate.window!, duration: 0.3, options: .transitionCrossDissolve, animations: {})
        })
        present(alert, animated: true)
    }
}

// MARK: - StatsCard Component

class StatsCard: UIView {
    private let iconLabel = UILabel()
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        
        iconLabel.font = UIFont.systemFont(ofSize: 32)
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconLabel)
        
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        valueLabel.font = UIFont.boldSystemFont(ofSize: 24)
        valueLabel.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.3, alpha: 1.0)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            iconLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            iconLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            
            titleLabel.topAnchor.constraint(equalTo: iconLabel.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])
    }
    
    func setup(title: String, value: String, icon: String) {
        titleLabel.text = title
        valueLabel.text = value
        iconLabel.text = icon
    }
    
    func setValue(_ value: String) {
        valueLabel.text = value
    }
}
