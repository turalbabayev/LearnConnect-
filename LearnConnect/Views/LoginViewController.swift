//
//  LoginViewController.swift
//  LearnConnect
//
//  Created by Tural Babayev on 23.11.2024.
//

import UIKit

class LoginViewController: UIViewController {

    //IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertIcon: UIImageView!
    @IBOutlet weak var alertTitle: UILabel!
    
    
    //ViewModel
    private let viewModel = LoginViewModel()

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        setupBindings()
        UISetup()
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        NavigationManager.shared.navigate(to: .onboarding, from: self)
    }
    
    
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        if email.isEmpty{
            showMessage("Lütfen e-posta adresinizi girin.", isSuccess: false)
            return
        }
        
        if password.isEmpty{
            showMessage("Lütfen şifrenizi girin.", isSuccess: false)
            return
        }
        
        viewModel.login(email: email, password: password)
    }
    
    @IBAction func forgotPasswordAction(_ sender: UIButton) {
        NavigationManager.shared.navigate(to: .forgotPassword, from: self)
    }
    
    @IBAction func signupButtonAction(_ sender: UIButton) {
        NavigationManager.shared.navigate(to: .register, from: self)
    }
    
    @IBAction func googleButtonAction(_ sender: UIButton) {
        
    }

}

//MARK: - Extensions

extension LoginViewController:UITextFieldDelegate{
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
extension LoginViewController{
    
    private func setupBindings(){
        viewModel.onSuccess = { user in
            self.showMessage("Giriş başarılı! Yönlendiriliyorsunuz...", isSuccess: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                // Yönlendirme işlemi burada yapılır
                UserDefaults.standard.isLoggedIn = true
                NavigationManager.shared.navigate(to: .mainNavigation, from: self)
            }
        }
        
        viewModel.onError = { errorMessage in
            self.showMessage(errorMessage, isSuccess: false)
        }
    }
    
    private func showMessage(_ message: String , isSuccess: Bool){
        alertView.isHidden = false
        alertView.backgroundColor = isSuccess ? .systemGreen.withAlphaComponent(0.5) : .systemRed.withAlphaComponent(0.5)
        alertIcon.image = UIImage(named: isSuccess ? "success" : "error")
        alertTitle.text = message
        alertTitle.textColor = isSuccess ? .systemGreen : .systemRed

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.alertView.isHidden = true
        }
    }
    
    private func UISetup(){
        // Email alanı için ikon ekleme ve stil
        emailTextField.setLeftIcon(UIImage(named: "emailIcon")!)
        emailTextField.setupBorderStyle()

        // Şifre alanı için sol ve sağ ikon ekleme ve stil
        passwordTextField.setLeftIcon(UIImage(named: "passIcon")!)
        passwordTextField.setupBorderStyle()
        
        loginButton.layer.cornerRadius = 8
        signupButton.layer.cornerRadius = 8
        signupButton.layer.borderWidth = 1
        signupButton.layer.borderColor = UIColor(named: "primaryBlue")?.cgColor
        alertView.layer.cornerRadius = 8
        alertView.isHidden = true
        
        googleButton.layer.borderWidth = 0.5
        googleButton.layer.borderColor = UIColor.systemGray.cgColor
        googleButton.layer.cornerRadius = 8
    }
}
