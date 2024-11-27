//
//  ForgotPasswordViewController.swift
//  LearnConnect
//
//  Created by Tural Babayev on 23.11.2024.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertIcon: UIImageView!
    @IBOutlet weak var alertTitle: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    private let viewModel = ForgotPasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        UISetup()
        setupBindings()
        
        
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        NavigationManager.shared.navigate(to: .login, from: self)
    }
    
    @IBAction func sendButtonAction(_ sender: UIButton) {
        let email = emailTextField.text ?? ""

        if email.isEmpty {
            showMessage("Lütfen e-posta adresinizi girin.", isSuccess: false)
            return
        }

        viewModel.resetPassword(email: email)
    }
}

//MARK: - Extensions

extension ForgotPasswordViewController:UITextFieldDelegate{
    // Yazı yazılmaya başlandığında
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.updateBorder(isEditing: true)
    }
    
    // Yazı yazma bittiğinde
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            // Eğer text varsa turuncu border kalsın
            textField.layer.borderWidth = 1.5
            textField.layer.borderColor = UIColor(named: "primaryBlue")?.cgColor
        } else {
            // Eğer text yoksa border'ı kaldır
            textField.updateBorder(isEditing: false)
        }
    }
}

//MARK: - Private Functions
extension ForgotPasswordViewController{
    
    private func setupBindings() {
        viewModel.onSuccess = {
            self.showMessage("Şifre sıfırlama bağlantısı gönderildi.", isSuccess: true)
        }

        viewModel.onError = { errorMessage in
            self.showMessage(errorMessage, isSuccess: false)
        }
    }
    
    private func UISetup(){
        // Email alanı için ikon ekleme ve stil
        emailTextField.setLeftIcon(UIImage(named: "emailIcon")!)
        emailTextField.setupBorderStyle()
        
        sendButton.layer.cornerRadius = 8
        alertView.layer.cornerRadius = 8
        alertView.isHidden = true

    }
    
    private func showMessage(_ message: String, isSuccess: Bool) {
        alertView.isHidden = false
        alertView.backgroundColor = isSuccess ? .systemGreen.withAlphaComponent(0.5) : .systemRed.withAlphaComponent(0.5)
        alertIcon.image = UIImage(named: isSuccess ? "success" : "error")
        alertTitle.text = message
        alertTitle.textColor = isSuccess ? .systemGreen : .systemRed

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.alertView.isHidden = true
        }
    }
    
    
}

