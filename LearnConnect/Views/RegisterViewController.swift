//
//  RegisterViewController.swift
//  LearnConnect
//
//  Created by Tural Babayev on 23.11.2024.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertIcon: UIImageView!
    @IBOutlet weak var alertTitle: UILabel!
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    
    //ViewModel
    private let viewModel = RegisterViewModel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fullnameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordAgainTextField.delegate = self
        setupBindings()
        UISetup()
        
        
        
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        NavigationManager.shared.navigate(to: .login, from: self)
    }
    
    @IBAction func signupButtonAction(_ sender: UIButton) {
        let fullname = fullnameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let passwordAgain = passwordAgainTextField.text ?? ""
        
        
        if fullname.isEmpty {
            showMessage("Lütfen adınızı girin.", isSuccess: false)
            return
        }
        
        if email.isEmpty{
            showMessage("Lütfen e-posta adresinizi girin.", isSuccess: false)
            return
        }
        
        if password.isEmpty{
            showMessage("Lütfen şifrenizi girin.", isSuccess: false)
            return
        }
        
        if password != passwordAgain {
            showMessage("Şifreleriniz birbiriyle uyuşmuyor.", isSuccess: false)
            return
        }
        
        
        
        viewModel.register(email: email, password: password, fullname: fullname)

        
    }
    
    @IBAction func googleButtonAction(_ sender: Any) {
        
    }

}

//MARK: - Extensions
extension RegisterViewController:UITextFieldDelegate{
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
extension RegisterViewController{
    
    private func setupBindings(){
        viewModel.onSuccess = { user in
            self.showMessage("Kayıt başarılı! Yönlendiriliyorsunuz...", isSuccess: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                // Yönlendirme işlemi burada yapılır
            
                UserDefaults.standard.isLoggedIn = true
                UserDefaults.standard.set(user.id, forKey: "userId") // UUID kaydediliyor
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
        
        //Fullname alanı için ikon ekleme ve stil
        fullnameTextField.setLeftIcon(UIImage(named: "person")!)
        fullnameTextField.setupBorderStyle()
        

        //Password alanı için ikon ekleme ve stil
        passwordTextField.setLeftIcon(UIImage(named: "passIcon")!)
        passwordTextField.setupBorderStyle()
        passwordAgainTextField.setLeftIcon(UIImage(named: "passIcon")!)
        passwordAgainTextField.setupBorderStyle()
        
        //View + Buton Styling
        signupButton.layer.cornerRadius = 8
        alertView.layer.cornerRadius = 8
        alertView.isHidden = true
        googleButton.layer.borderWidth = 0.5
        googleButton.layer.borderColor = UIColor.systemGray.cgColor
        googleButton.layer.cornerRadius = 8

    }
}
