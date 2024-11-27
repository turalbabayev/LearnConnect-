//
//  EmtpyStateView.swift
//  LearnConnect
//
//  Created by Tural Babayev on 27.11.2024.
//

import UIKit

class EmptyStateView: UIView {

    // MARK: - UI Elements
    private let imageView = UIImageView()
    private let messageLabel = UILabel()

    // MARK: - Initializer
    init(image: UIImage, message: String) {
        super.init(frame: .zero)
        setupView(image: image, message: message)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Setup
    private func setupView(image: UIImage, message: String) {
        // Self Background
        self.backgroundColor = .white
        
        // Image View
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)

        // Message Label
        messageLabel.text = message
        messageLabel.textColor = .darkGray
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(messageLabel)

        // Constraints
        NSLayoutConstraint.activate([
            // Image Constraints
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -50),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 150),

            // Label Constraints
            messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
    }
}
