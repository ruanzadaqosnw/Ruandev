import UIKit
import Foundation

/**
 RuanDevAPIServerDylib
 
 Dylib para injetar em qualquer app iOS e controlar acesso via sistema de licenças.
 
 Uso:
 1. Compile este arquivo como dylib
 2. Injete em seu app iOS
 3. Chame RuanDevAPIServer.initialize(apiURL: "seu-servidor", packageToken: "seu-token")
 4. O sistema automaticamente:
    - Obtém o UDID do dispositivo
    - Carrega os packages disponíveis
    - Pede a Key do usuário
    - Valida a Key
    - Libera o acesso ao app
 */

public class RuanDevAPIServer {
    
    public static let shared = RuanDevAPIServer()
    
    private var apiURL: String = ""
    private var packageToken: String = ""
    private var currentKey: String?
    private var isAuthenticated: Bool = false
    private var lockWindow: UIWindow?
    
    // MARK: - Initialization
    
    public func initialize(apiURL: String, packageToken: String) {
        self.apiURL = apiURL
        self.packageToken = packageToken
        
        DispatchQueue.main.async {
            self.presentLockScreen()
        }
    }
    
    // MARK: - Lock Screen
    
    private func presentLockScreen() {
        let lockVC = RuanDevLockViewController(dylib: self)
        
        lockWindow = UIWindow(frame: UIScreen.main.bounds)
        lockWindow?.windowLevel = .alert
        lockWindow?.rootViewController = lockVC
        lockWindow?.makeKeyAndVisible()
    }
    
    private func dismissLockScreen() {
        lockWindow?.isHidden = true
        lockWindow = nil
        isAuthenticated = true
    }
    
    // MARK: - UDID
    
    public func getUDID() -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    // MARK: - Authentication
    
    public func authenticateWithKey(_ key: String, completion: @escaping (Bool) -> Void) {
        let endpoint = "\(apiURL)/auth/validate-key"
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "key": key,
            "packageToken": packageToken,
            "udid": getUDID(),
            "deviceName": UIDevice.current.name,
            "osVersion": UIDevice.current.systemVersion
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("RuanDev Error: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                guard let data = data else {
                    completion(false)
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let isValid = json["isValid"] as? Bool {
                        self.currentKey = key
                        completion(isValid)
                    } else {
                        completion(false)
                    }
                } catch {
                    completion(false)
                }
            }
        }.resume()
    }
    
    // MARK: - Package Management
    
    public func loadPackages(completion: @escaping ([Package]?) -> Void) {
        let endpoint = "\(apiURL)/packages/\(packageToken)"
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("RuanDev Error: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                guard let data = data else {
                    completion(nil)
                    return
                }
                
                do {
                    let packages = try JSONDecoder().decode([Package].self, from: data)
                    completion(packages)
                } catch {
                    completion(nil)
                }
            }
        }.resume()
    }
    
    // MARK: - Status Check
    
    public func isAppLocked() -> Bool {
        return !isAuthenticated
    }
    
    public func getKeyInfo(completion: @escaping (KeyInfo?) -> Void) {
        guard let key = currentKey else {
            completion(nil)
            return
        }
        
        let endpoint = "\(apiURL)/keys/info"
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("RuanDev Error: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                guard let data = data else {
                    completion(nil)
                    return
                }
                
                do {
                    let keyInfo = try JSONDecoder().decode(KeyInfo.self, from: data)
                    completion(keyInfo)
                } catch {
                    completion(nil)
                }
            }
        }.resume()
    }
}

// MARK: - Lock View Controller

class RuanDevLockViewController: UIViewController {
    
    private let dylib: RuanDevAPIServer
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let logoLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    private let stepLabel = UILabel()
    private let keyTextField = UITextField()
    private let submitButton = UIButton(type: .system)
    private let getUDIDButton = UIButton(type: .system)
    private let tutorialButton = UIButton(type: .system)
    
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    init(dylib: RuanDevAPIServer) {
        self.dylib = dylib
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        logoLabel.text = "🔐"
        logoLabel.font = UIFont.systemFont(ofSize: 60)
        logoLabel.textAlignment = .center
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(logoLabel)
        
        titleLabel.text = "Ruan Dev"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.3, alpha: 1.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        subtitleLabel.text = "API Server"
        subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subtitleLabel)
        
        stepLabel.text = "1️⃣ Obter UDID"
        stepLabel.font = UIFont.boldSystemFont(ofSize: 16)
        stepLabel.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.3, alpha: 1.0)
        stepLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stepLabel)
        
        getUDIDButton.setTitle("📱 Obter UDID", for: .normal)
        getUDIDButton.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0)
        getUDIDButton.setTitleColor(.white, for: .normal)
        getUDIDButton.layer.cornerRadius = 8
        getUDIDButton.translatesAutoresizingMaskIntoConstraints = false
        getUDIDButton.addTarget(self, action: #selector(getUDIDTapped), for: .touchUpInside)
        contentView.addSubview(getUDIDButton)
        
        tutorialButton.setTitle("📺 Tutorial", for: .normal)
        tutorialButton.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        tutorialButton.setTitleColor(.black, for: .normal)
        tutorialButton.layer.cornerRadius = 8
        tutorialButton.translatesAutoresizingMaskIntoConstraints = false
        tutorialButton.addTarget(self, action: #selector(tutorialTapped), for: .touchUpInside)
        contentView.addSubview(tutorialButton)
        
        keyTextField.placeholder = "Cole sua Key aqui"
        keyTextField.borderStyle = .roundedRect
        keyTextField.backgroundColor = .white
        keyTextField.font = UIFont.systemFont(ofSize: 14)
        keyTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(keyTextField)
        
        submitButton.setTitle("Entrar", for: .normal)
        submitButton.backgroundColor = UIColor(red: 0.0, green: 0.7, blue: 0.3, alpha: 1.0)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        submitButton.layer.cornerRadius = 8
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        contentView.addSubview(submitButton)
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(loadingIndicator)
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
            
            stepLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            stepLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            getUDIDButton.topAnchor.constraint(equalTo: stepLabel.bottomAnchor, constant: 15),
            getUDIDButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            getUDIDButton.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -7),
            getUDIDButton.heightAnchor.constraint(equalToConstant: 45),
            
            tutorialButton.topAnchor.constraint(equalTo: stepLabel.bottomAnchor, constant: 15),
            tutorialButton.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 7),
            tutorialButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            tutorialButton.heightAnchor.constraint(equalToConstant: 45),
            
            keyTextField.topAnchor.constraint(equalTo: getUDIDButton.bottomAnchor, constant: 25),
            keyTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            keyTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            keyTextField.heightAnchor.constraint(equalToConstant: 50),
            
            submitButton.topAnchor.constraint(equalTo: keyTextField.bottomAnchor, constant: 20),
            submitButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            submitButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    @objc private func getUDIDTapped() {
        let udid = dylib.getUDID()
        UIPasteboard.general.string = udid
        showAlert(title: "UDID Copiado", message: "UDID: \(udid)\n\nCopiado para a área de transferência!")
    }
    
    @objc private func tutorialTapped() {
        if let url = URL(string: "https://www.youtube.com/results?search_query=how+to+get+ios+udid") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func submitTapped() {
        guard let key = keyTextField.text, !key.isEmpty else {
            showAlert(title: "Erro", message: "Por favor, insira sua Key")
            return
        }
        
        submitButton.isEnabled = false
        loadingIndicator.startAnimating()
        
        dylib.authenticateWithKey(key) { [weak self] isValid in
            self?.loadingIndicator.stopAnimating()
            self?.submitButton.isEnabled = true
            
            if isValid {
                self?.dismiss(animated: true) {
                    if let window = self?.view.window {
                        window.isHidden = true
                    }
                }
            } else {
                self?.showAlert(title: "Erro", message: "Key inválida ou expirada")
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Models

struct Package: Codable {
    let id: String
    let name: String
    let token: String
    let isActive: Bool
}

struct KeyInfo: Codable {
    let keyValue: String
    let packageName: String
    let expiresAt: Date
    let activatedAt: Date?
    let isActive: Bool
}
