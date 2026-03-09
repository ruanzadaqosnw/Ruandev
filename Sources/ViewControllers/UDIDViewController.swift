import UIKit

class UDIDViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private let udidLabel = UILabel()
    private let udidValueLabel = UILabel()
    private let copyButton = UIButton(type: .system)
    
    private let deviceNameLabel = UILabel()
    private let deviceNameValueLabel = UILabel()
    
    private let osVersionLabel = UILabel()
    private let osVersionValueLabel = UILabel()
    
    private let modelLabel = UILabel()
    private let modelValueLabel = UILabel()
    
    private let tutorialButton = UIButton(type: .system)
    private let backButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadUDID()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)
        
        // ScrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Title
        titleLabel.text = "Obter UDID"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.3, alpha: 1.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // Description
        descriptionLabel.text = "Seu UDID é um identificador único do seu dispositivo iOS. Ele é necessário para registrar seu dispositivo no sistema."
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)
        
        // UDID Section
        udidLabel.text = "UDID:"
        udidLabel.font = UIFont.boldSystemFont(ofSize: 14)
        udidLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(udidLabel)
        
        udidValueLabel.text = "Carregando..."
        udidValueLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        udidValueLabel.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        udidValueLabel.numberOfLines = 0
        udidValueLabel.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.95, alpha: 1.0)
        udidValueLabel.layer.cornerRadius = 6
        udidValueLabel.layer.masksToBounds = true
        udidValueLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(udidValueLabel)
        
        copyButton.setTitle("📋 Copiar UDID", for: .normal)
        copyButton.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0)
        copyButton.setTitleColor(.white, for: .normal)
        copyButton.layer.cornerRadius = 8
        copyButton.translatesAutoresizingMaskIntoConstraints = false
        copyButton.addTarget(self, action: #selector(copyUDID), for: .touchUpInside)
        contentView.addSubview(copyButton)
        
        // Device Name
        deviceNameLabel.text = "Nome do Dispositivo:"
        deviceNameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        deviceNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(deviceNameLabel)
        
        deviceNameValueLabel.text = "-"
        deviceNameValueLabel.font = UIFont.systemFont(ofSize: 13)
        deviceNameValueLabel.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        deviceNameValueLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(deviceNameValueLabel)
        
        // OS Version
        osVersionLabel.text = "Versão do iOS:"
        osVersionLabel.font = UIFont.boldSystemFont(ofSize: 14)
        osVersionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(osVersionLabel)
        
        osVersionValueLabel.text = "-"
        osVersionValueLabel.font = UIFont.systemFont(ofSize: 13)
        osVersionValueLabel.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        osVersionValueLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(osVersionValueLabel)
        
        // Model
        modelLabel.text = "Modelo:"
        modelLabel.font = UIFont.boldSystemFont(ofSize: 14)
        modelLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(modelLabel)
        
        modelValueLabel.text = "-"
        modelValueLabel.font = UIFont.systemFont(ofSize: 13)
        modelValueLabel.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        modelValueLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(modelValueLabel)
        
        // Tutorial Button
        tutorialButton.setTitle("📺 Ver Tutorial", for: .normal)
        tutorialButton.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        tutorialButton.setTitleColor(.black, for: .normal)
        tutorialButton.layer.cornerRadius = 8
        tutorialButton.translatesAutoresizingMaskIntoConstraints = false
        tutorialButton.addTarget(self, action: #selector(openTutorial), for: .touchUpInside)
        contentView.addSubview(tutorialButton)
        
        // Back Button
        backButton.setTitle("← Voltar", for: .normal)
        backButton.backgroundColor = UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1.0)
        backButton.setTitleColor(.white, for: .normal)
        backButton.layer.cornerRadius = 8
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        contentView.addSubview(backButton)
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
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            udidLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 30),
            udidLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            udidValueLabel.topAnchor.constraint(equalTo: udidLabel.bottomAnchor, constant: 8),
            udidValueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            udidValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            udidValueLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            
            copyButton.topAnchor.constraint(equalTo: udidValueLabel.bottomAnchor, constant: 15),
            copyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            copyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            copyButton.heightAnchor.constraint(equalToConstant: 45),
            
            deviceNameLabel.topAnchor.constraint(equalTo: copyButton.bottomAnchor, constant: 25),
            deviceNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            deviceNameValueLabel.topAnchor.constraint(equalTo: deviceNameLabel.bottomAnchor, constant: 5),
            deviceNameValueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            osVersionLabel.topAnchor.constraint(equalTo: deviceNameValueLabel.bottomAnchor, constant: 15),
            osVersionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            osVersionValueLabel.topAnchor.constraint(equalTo: osVersionLabel.bottomAnchor, constant: 5),
            osVersionValueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            modelLabel.topAnchor.constraint(equalTo: osVersionValueLabel.bottomAnchor, constant: 15),
            modelLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            modelValueLabel.topAnchor.constraint(equalTo: modelLabel.bottomAnchor, constant: 5),
            modelValueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            tutorialButton.topAnchor.constraint(equalTo: modelValueLabel.bottomAnchor, constant: 30),
            tutorialButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            tutorialButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            tutorialButton.heightAnchor.constraint(equalToConstant: 45),
            
            backButton.topAnchor.constraint(equalTo: tutorialButton.bottomAnchor, constant: 15),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            backButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            backButton.heightAnchor.constraint(equalToConstant: 45),
            backButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
    }
    
    private func loadUDID() {
        if let udidInfo = APIService.shared.getUDID() {
            DispatchQueue.main.async {
                self.udidValueLabel.text = udidInfo.udid
                self.deviceNameValueLabel.text = udidInfo.deviceName
                self.osVersionValueLabel.text = udidInfo.osVersion
                self.modelValueLabel.text = udidInfo.modelName
            }
        }
    }
    
    @objc private func copyUDID() {
        if let udid = udidValueLabel.text {
            UIPasteboard.general.string = udid
            showAlert(title: "Sucesso", message: "UDID copiado para a área de transferência!")
        }
    }
    
    @objc private func openTutorial() {
        if let url = URL(string: "https://www.youtube.com/results?search_query=how+to+get+ios+udid") {
            UIApplication.shared.open(url)
        }
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
