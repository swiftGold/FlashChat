//
//  RegisterViewController.swift
//  FlashChat
//
//  Created by Сергей Золотухин on 17.03.2023.
//

import UIKit
import FirebaseAuth

final class RegisterViewController: UIViewController {
    
    private let errorLabel = make(UILabel()) {
        $0.text = ""
        $0.textColor = .red
        $0.font = UIFont.boldSystemFont(ofSize: 18)
        $0.numberOfLines = 0
    }
    
    private lazy var emailTextField = make(UITextField()) {
        $0.placeholder = "EMAIL"
        $0.textAlignment = .center
        $0.textColor = .black
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
    }
    
    private lazy var passwordTextField = make(UITextField()) {
        $0.placeholder = "PASSWORD"
        $0.textAlignment = .center
        $0.textColor = .black
        $0.backgroundColor = .white
        $0.isSecureTextEntry = true
        $0.layer.cornerRadius = 16
    }
    
    private lazy var registerButton = make(UIButton(type: .system)) {
        $0.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        $0.layer.backgroundColor = UIColor(named: "BrandLightBlue")?.cgColor
        $0.setTitleColor(UIColor(named: "BrandBlue"), for: .normal)
        $0.setTitle("Register", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        $0.layer.borderColor = UIColor(named: "BrandPurple")?.cgColor
        $0.layer.borderWidth = 1.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    @objc
    private func didTapRegisterButton() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text
        else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let e = error {
                self?.errorLabel.text = e.localizedDescription
            } else {
                let viewController = ChatViewController()
                self?.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
}

private extension RegisterViewController {
    func setupViewController() {
        view.backgroundColor = .systemBackground
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        view.myAddSubView(errorLabel)
        view.myAddSubView(emailTextField)
        view.myAddSubView(passwordTextField)
        view.myAddSubView(registerButton)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            errorLabel.heightAnchor.constraint(equalToConstant: 80),
            
            emailTextField.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            registerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
