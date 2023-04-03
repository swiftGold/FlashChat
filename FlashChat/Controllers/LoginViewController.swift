//
//  LoginViewController.swift
//  FlashChat
//
//  Created by Сергей Золотухин on 17.03.2023.
//

import UIKit
import FirebaseAuth

final class LoginViewController: UIViewController {
    private let errorLabel = make(UILabel()) {
        $0.text = ""
        $0.textColor = .red
        $0.font = UIFont.boldSystemFont(ofSize: 18)
        $0.numberOfLines = 0
    }
    
    private lazy var emailTextField = make(UITextField()) {
        $0.placeholder = "EMAIL"
        $0.text = "1@1.com"
        $0.textAlignment = .center
        $0.textColor = .black
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
    }
    
    private lazy var passwordTextField = make(UITextField()) {
        $0.placeholder = "PASSWORD"
        $0.text = "123456"
        $0.textAlignment = .center
        $0.textColor = .black
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
    }
    
    private lazy var logInButton = make(UIButton(type: .system)) {
        $0.addTarget(self, action: #selector(didTapLogInButton), for: .touchUpInside)
        $0.setTitleColor(UIColor(named: "BrandBlue"), for: .normal)
        $0.setTitle("Log In", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        $0.layer.borderColor = UIColor(named: "BrandPurple")?.cgColor
        $0.layer.borderWidth = 1.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    @objc
    private func didTapLogInButton() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text
        else {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            if let e = error {
                self?.errorLabel.text = e.localizedDescription
            } else {
                let viewController = ChatViewController()
                self?.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
}

private extension LoginViewController {
    func routeToVC(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupViewController() {
        view.backgroundColor = .systemMint
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        view.myAddSubView(errorLabel)
        view.myAddSubView(emailTextField)
        view.myAddSubView(passwordTextField)
        view.myAddSubView(logInButton)
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
            
            logInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            logInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            logInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            logInButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
