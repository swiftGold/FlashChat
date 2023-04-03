//
//  MessageTableViewCell.swift
//  FlashChat
//
//  Created by Сергей Золотухин on 17.03.2023.
//

import UIKit
import FirebaseAuth

final class MessageTableViewCell: UITableViewCell {
    
    private let messageLabel = make(UILabel()) {
        $0.text = "here will be your message"
        $0.textColor = .black
        $0.textAlignment = .left
        $0.backgroundColor = UIColor(named: "BrandPurple")
        $0.numberOfLines = 0
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
    }
    
    private let meImageView = make(UIImageView()) {
        $0.image = UIImage(named: "MeAvatar")
    }
    
    private let youImageView = make(UIImageView()) {
        $0.image = UIImage(named: "YouAvatar")
    }
    
    private let stackView = make(UIStackView()) {
        $0.spacing = 10
        $0.distribution = .fill
        $0.alignment = .fill
        $0.axis = .horizontal
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with model: Message) {
        messageLabel.text = model.body

        if model.sender == Auth.auth().currentUser?.email {
            youImageView.isHidden = true
            meImageView.isHidden = false
            messageLabel.backgroundColor = UIColor(named: "BrandLightPurple")
        } else {
            youImageView.isHidden = false
            meImageView.isHidden = true
            messageLabel.backgroundColor = UIColor(named: "BrandLightBlue")
        }
    }
}

private extension MessageTableViewCell {
    func setupCell() {
        
        stackView.addArrangedSubview(youImageView)
        stackView.addArrangedSubview(messageLabel)
        stackView.addArrangedSubview(meImageView)
        
        myAddSubView(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),

            youImageView.widthAnchor.constraint(equalToConstant: 50),
            youImageView.heightAnchor.constraint(equalToConstant: 50),
            meImageView.widthAnchor.constraint(equalToConstant: 50),
            meImageView.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}

struct Message {
    let sender: String
    let body: String
}
