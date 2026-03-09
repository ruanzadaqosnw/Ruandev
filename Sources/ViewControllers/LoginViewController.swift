import UIKit

class LoginViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let logoLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    private let keyTextField = UITextField()
    private let packageTokenTextField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let getUDIDButton = UIButton(type: .system)
    private let tutorialButton = UIButton(type: .system)
    
    private let copyrightLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)
        
        // ScrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Logo
        logoLabel.text = "🔐"
        logoLabel.font = UIFont.systemFont(ofSize: 60)
        logoLabel.textAlignment = .center
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(logoLabel)
        
        // Title
        titleLabel.text = "Ruan Dev"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.3, alpha: 1.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // Subtitle
        subtitleLabel.text = "API Server"
        subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subtitleLabel)
        
        // Key TextField
        keyTextField.placeholder = "Cole sua Key aqui"
        keyTextField.borderStyle = .roundedRect
        keyTextField.backgroundColor = .white
        keyTextField.font = UIFont.systemFont(ofSize: 14)
        keyTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(keyTextField)
        
        // Package Token TextField
        packageTokenTextField.placeholder = "Token do Package"
        packageTokenTextField.borderStyle = .roundedRect
        packageTokenTextField.backgroundColor = .white
        packageTokenTextField.font = UIFont.systemFont(ofSize: 14)
        packageTokenTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(packageTokenTextField)
        
        // Get UDID Button
        getUDIDButton.setTitle("📱 Obter UDID", for: .normal)
        getUDIDButton.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0)
        getUDIDButton.setTitleColor(.white, for: .normal)
        getUDIDButton.layer.cornerRadius = 8
        getUDIDButton.translatesAutoresizingMaskIntoConstraints = false
        getUDIDButton.addTarget(self, action: #selector(getUDIDTapped), for: .touchUpInside)
        contentView.addSubview(getUDIDButton)
        
        // Tutorial Button
        tutorialButton.setTitle("📺 Tutorial", for: .normal)
        tutorialButton.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        tutorialButton.setTitleColor(.black, for: .normal)
        tutorialButton.layer.cornerRadius = 8
        tutorialButton.translatesAutoresizingMaskIntoConstraints = false
        tutorialButton.addTarget(self, action: #selector(tutorialTapped), for: .touchUpInside)
        contentView.addSubview(tutorialButton)
        
        // Login Button
        loginButton.setTitle("Entrar", for: .normal)
        loginButton.backgroundColor = UIColor(red: 0.0, green: 0.7, blue: 0.3, alpha: 1.0)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        loginButton.layer.cornerRadius = 8
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        contentView.addSubview(loginButton)
        
        // Copyright
        copyrightLabel.text = "© Todos os direitos reservados Ruan Dev"
        copyrightLabel.font = UIFont.systemFont(ofSize: 12)
        copyrightLabel.textAlignment = .center
        copyrightLabel.textColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
        copyrightLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(copyrightLabel)
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
            
            logoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60),
            logoLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            keyTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            keyTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            keyTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            keyTextField.heightAnchor.constraint(equalToConstant: 50),
            
            packageTokenTextField.topAnchor.constraint(equalTo: keyTextField.bottomAnchor, constant: 15),
            packageTokenTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            packageTokenTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            packageTokenTextField.heightAnchor.constraint(equalToConstant: 50),
            
            getUDIDButton.topAnchor.constraint(equalTo: packageTokenTextField.bottomAnchor, constant: 20),
            getUDIDButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            getUDIDButton.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -7),
            getUDIDButton.heightAnchor.constraint(equalToConstant: 45),
            
            tutorialButton.topAnchor.constraint(equalTo: packageTokenTextField.bottomAnchor, constant: 20),
            tutorialButton.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 7),
            tutorialButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            tutorialButton.heightAnchor.constraint(equalToConstant: 45),
            
            loginButton.topAnchor.constraint(equalTo: getUDIDButton.bottomAnchor, constant: 20),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            copyrightLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 40),
            copyrightLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            copyrightLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            copyrightLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
        ])
    }
    
    @objc private func getUDIDTapped() {
        let udidVC = UDIDViewController()
        navigationController?.pushViewController(udidVC, animated: true)
    }
    
    @objc private func tutorialTapped() {
        if let url = URL(string: "https://www.youtube.com/results?search_query=how+to+get+ios+udid") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func loginTapped() {
        guard let key = keyTextField.text, !key.isEmpty else {
            showAlert(title: "Erro", message: "Por favor, insira sua Key")
            return
        }
        
        guard let packageToken = packageTokenTextField.text, !packageToken.isEmpty else {
            showAlert(title: "Erro", message: "Por favor, insira o Token do Package")
            return
        }
        
        loginButton.isEnabled = false
        loginButton.alpha = 0.5
        
        APIService.shared.login(key: key, packageToken: packageToken) { [weak self] result in
            DispatchQueue.main.async {
                self?.loginButton.isEnabled = true
                self?.loginButton.alpha = 1.0
                
                switch result {
                case .success:
                    self?.navigateToDashboard()
                case .failure(let error):
                    self?.showAlert(title: "Erro", message: error.localizedDescription)
                }
            }
        }
    }
    
    private func navigateToDashboard() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let tabBarVC = createTabBarController()
        appDelegate.window?.rootViewController = tabBarVC
        UIView.transition(with: appDelegate.window!, duration: 0.3, options: .transitionCrossDissolve, animations: {})
    }
    
    private func createTabBarController() -> UITabBarController {
        let tabBar = UITabBarController()
        
        let dashboardVC = DashboardViewController()
        let dashboardNav = UINavigationController(rootViewController: dashboardVC)
        dashboardNav.tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(systemName: "chart.bar"), tag: 0)
        
        let keysVC = KeysViewController()
        let keysNav = UINavigationController(rootViewController: keysVC)
        keysNav.tabBarItem = UITabBarItem(title: "Keys", image: UIImage(systemName: "key"), tag: 1)
        
        let devicesVC = DevicesViewController()
        let devicesNav = UINavigationController(rootViewController: devicesVC)
        devicesNav.tabBarItem = UITabBarItem(title: "Devices", image: UIImage(systemName: "iphone"), tag: 2)
        
        let profileVC = ProfileViewController()
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.tabBarItem = UITabBarItem(title: "Perfil", image: UIImage(systemName: "person"), tag: 3)
        
        tabBar.viewControllers = [dashboardNav, keysNav, devicesNav, profileNav]
        return tabBar
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
