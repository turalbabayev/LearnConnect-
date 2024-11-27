//
//  CustomAlertView.swift
//  LearnConnect
//
//  Created by Tural Babayev on 27.11.2024.
//


import UIKit

class CustomAlertView: UIView {
    
    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let actionButton = UIButton(type: .system)
    private let containerView = UIView()
    
    // MARK: - Initializer
    init(title: String, message: String, buttonTitle: String, buttonAction: @escaping () -> Void) {
        super.init(frame: UIScreen.main.bounds)
        setupView(title: title, message: message, buttonTitle: buttonTitle, buttonAction: buttonAction)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Setup
    private func setupView(title: String, message: String, buttonTitle: String, buttonAction: @escaping () -> Void) {
        // Background
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        // Container View
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(containerView)
        
        // Title Label
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        // Message Label
        messageLabel.text = message
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textColor = .darkGray
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(messageLabel)
        
        // Action Button
        actionButton.setTitle(buttonTitle, for: .normal)
        actionButton.backgroundColor = UIColor(named: "primaryBlue")
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        actionButton.layer.cornerRadius = 8
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.addAction(UIAction { _ in
            buttonAction()
            self.dismiss()
        }, for: .touchUpInside)
        containerView.addSubview(actionButton)
        
        // Layout Constraints
        NSLayoutConstraint.activate([
            // Container View
            containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            // Message Label
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            // Action Button
            actionButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 40),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -40),
            actionButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    // MARK: - Show and Dismiss Methods
    func show(on viewController: UIViewController) {
        viewController.view.addSubview(self)
        self.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
    
    private func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
}
