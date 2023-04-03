//
//  ChatViewController.swift
//  FlashChat
//
//  Created by Сергей Золотухин on 17.03.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

final class ChatViewController: UIViewController {
    
    private lazy var barButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(didTapBarButton))
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: "MessageTableViewCell")
        return tableView
    }()
    
    private let messageView = make(UIView()) {
        $0.backgroundColor = UIColor(named: "BrandPurple")
    }
    
    private lazy var messageTextField = make(UITextField()) {
        $0.placeholder = "enter your message"
        $0.textAlignment = .left
        $0.textColor = .black
        //        $0.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
    }
    
    private lazy var messageButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(didTapMessageButton), for: .touchUpInside)
        button.setImage(UIImage(systemName: "paperplane")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    private let messageStackView = make(UIStackView()) {
        $0.spacing = 10
        $0.distribution = .fillProportionally
        $0.axis = .horizontal
    }
    
    private var messages: [Message] = []
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupViewController()
        loadMessages()
    }
    
    @objc
    private func didTapBarButton() {
        do {
            try Auth.auth().signOut()
            let viewController = WelcomeViewController()
            navigationController?.pushViewController(viewController, animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    @objc
    private func didTapMessageButton() {
        saveMessage()
        messageTextField.text = ""
    }
}

extension ChatViewController: UITableViewDelegate {}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as? MessageTableViewCell else { fatalError()
        }
        cell.configureCell(with: messages[indexPath.item])
        return cell
    }
}

private extension ChatViewController {
    func loadMessages() {
        db.collection("messages")
            .order(by: "date")
            .addSnapshotListener { [weak self]
                querySnapshot, error in
                
                guard let self = self else { return }
                self.messages = []
                if let e = error {
                    print("There was an issue saving data to firestore, \(e.localizedDescription)")
                } else {
                    if let snapShotDocuments = querySnapshot?.documents {
                        for doc in snapShotDocuments {
                            let data = doc.data()
                            if let messageSender = data["sender"] as? String, let messageBody = data["message"] as? String {
                                let newMessage = Message(
                                    sender: messageSender,
                                    body: messageBody
                                )
                                self.messages.append(newMessage)
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                                }
                            }
                        }
                    }
                }
            }
    }
    
    func saveMessage() {
        guard let messageBody = messageTextField.text, let messageSender = Auth.auth().currentUser?.email else { return }
        db.collection("messages").addDocument(data: [
            "sender" : messageSender,
            "message" : messageBody,
            "date" : Date().timeIntervalSince1970
        ]) {
            (error) in
            if let e = error {
                print("There was an issue saving data to firestore, \(e.localizedDescription)")
            } else {
                print("Successfully saved data.")
            }
        }
    }
    
    func setupNavBar() {
        title = "⚡️FlashChat "
        navigationItem.rightBarButtonItem = barButtonItem
        navigationItem.hidesBackButton = true
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "BrandBlue")
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

    }
    
    func setupViewController() {
        view.backgroundColor = .white
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        messageStackView.addArrangedSubview(messageTextField)
        messageStackView.addArrangedSubview(messageButton)
        
        view.myAddSubView(tableView)
        view.myAddSubView(messageView)
        view.myAddSubView(messageStackView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: messageView.topAnchor),
            
            messageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            messageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageView.heightAnchor.constraint(equalToConstant: 90),
            
            messageStackView.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 15),
            messageStackView.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -16),
            messageStackView.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -35),
            messageStackView.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 16),
            
            messageButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}
