import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private var profileSections: [ProfileSection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupProfileSections()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)
        
        title = "Perfil"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupProfileSections() {
        let username = UserDefaults.standard.string(forKey: "username") ?? "Usuário"
        let email = UserDefaults.standard.string(forKey: "email") ?? "email@example.com"
        
        profileSections = [
            ProfileSection(title: "Informações Pessoais", items: [
                ProfileItem(icon: "👤", title: "Usuário", value: username),
                ProfileItem(icon: "📧", title: "Email", value: email),
            ]),
            ProfileSection(title: "Configurações", items: [
                ProfileItem(icon: "🌐", title: "Idioma", value: "Português (BR)", action: { self.changeLanguage() }),
                ProfileItem(icon: "🔐", title: "Alterar Senha", value: "", action: { self.changePassword() }),
            ]),
            ProfileSection(title: "Dispositivos", items: [
                ProfileItem(icon: "📱", title: "Dispositivos Logados", value: "", action: { self.showLoggedDevices() }),
                ProfileItem(icon: "🚪", title: "Limpar Sessões", value: "", action: { self.clearSessions() }),
            ]),
            ProfileSection(title: "Conta", items: [
                ProfileItem(icon: "🚪", title: "Sair", value: "", action: { self.logout() }),
            ]),
        ]
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return profileSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileSections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = profileSections[indexPath.section].items[indexPath.row]
        
        var config = cell.defaultContentConfiguration()
        config.text = "\(item.icon) \(item.title)"
        config.secondaryText = item.value
        config.textProperties.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        config.secondaryTextProperties.font = UIFont.systemFont(ofSize: 12)
        config.secondaryTextProperties.color = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        
        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return profileSections[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = profileSections[indexPath.section].items[indexPath.row]
        item.action?()
    }
    
    // MARK: - Actions
    
    private func changeLanguage() {
        let alert = UIAlertController(title: "Selecionar Idioma", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Português (BR)", style: .default) { _ in
            UserDefaults.standard.set("pt-BR", forKey: "language")
            self.showAlert(title: "Sucesso", message: "Idioma alterado para Português")
        })
        alert.addAction(UIAlertAction(title: "English", style: .default) { _ in
            UserDefaults.standard.set("en", forKey: "language")
            self.showAlert(title: "Success", message: "Language changed to English")
        })
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }
    
    private func changePassword() {
        let alert = UIAlertController(title: "Alterar Senha", message: "Digite sua nova senha", preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Nova senha"; $0.isSecureTextEntry = true }
        alert.addTextField { $0.placeholder = "Confirmar senha"; $0.isSecureTextEntry = true }
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Alterar", style: .default) { _ in
            if let password1 = alert.textFields?[0].text,
               let password2 = alert.textFields?[1].text,
               !password1.isEmpty, password1 == password2 {
                self.showAlert(title: "Sucesso", message: "Senha alterada com sucesso!")
            } else {
                self.showAlert(title: "Erro", message: "As senhas não correspondem ou estão vazias")
            }
        })
        present(alert, animated: true)
    }
    
    private func showLoggedDevices() {
        let alert = UIAlertController(title: "Dispositivos Logados", message: "Você está logado em:\n\n📱 iPhone (Este dispositivo)\n💻 Safari Web\n⌚ Apple Watch", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func clearSessions() {
        let alert = UIAlertController(title: "Limpar Sessões", message: "Deslogar de todos os dispositivos?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Deslogar", style: .destructive) { _ in
            self.showAlert(title: "Sucesso", message: "Todas as sessões foram encerradas!")
        })
        present(alert, animated: true)
    }
    
    private func logout() {
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
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Models

struct ProfileSection {
    let title: String
    let items: [ProfileItem]
}

struct ProfileItem {
    let icon: String
    let title: String
    let value: String
    let action: (() -> Void)?
    
    init(icon: String, title: String, value: String, action: (() -> Void)? = nil) {
        self.icon = icon
        self.title = title
        self.value = value
        self.action = action
    }
}
