//
//  WelcomeViewController.swift
//  FlashChat
//
//  Created by Сергей Золотухин on 17.03.2023.
//

import UIKit

final class WelcomeViewController: UIViewController {
    
    private let titleLabel = make(UILabel()) {
        $0.text = ""
        $0.textColor = UIColor(named: "BrandBlue")
        $0.font = UIFont.boldSystemFont(ofSize: 50)
        $0.layer.borderColor = UIColor(named: "BrandPurple")?.cgColor
        $0.layer.borderWidth = 1.0
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
    
    private lazy var logInButton = make(UIButton(type: .system)) {
        $0.addTarget(self, action: #selector(didTapLogInButton), for: .touchUpInside)
        $0.layer.backgroundColor = UIColor.systemTeal.cgColor
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.setTitle("Log In", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        $0.layer.borderColor = UIColor(named: "BrandPurple")?.cgColor
        $0.layer.borderWidth = 1.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        startedTitleAnimation()
        setupViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    @objc
    private func didTapRegisterButton() {
        let viewController = RegisterViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc
    private func didTapLogInButton() {
        let viewController = LoginViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

private extension WelcomeViewController {
    func setupNavBar() {
        navigationItem.hidesBackButton = true
    }
    
    func startedTitleAnimation() {
        var characterIndex = 0.0
        let titleText = "⚡️FlashChat "
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * characterIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
            characterIndex += 1
        }
    }
    
    func setupViewController() {
        view.backgroundColor = .systemBackground
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        view.myAddSubView(titleLabel)
        view.myAddSubView(logInButton)
        view.myAddSubView(registerButton)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            logInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            logInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            logInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            logInButton.heightAnchor.constraint(equalToConstant: 50),
            
            registerButton.bottomAnchor.constraint(equalTo: logInButton.topAnchor, constant: -10),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            registerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
