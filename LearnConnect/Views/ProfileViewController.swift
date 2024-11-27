//
//  ProfileViewController.swift
//  LearnConnect
//
//  Created by Tural Babayev on 24.11.2024.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var complateProfileCardView: UIView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var alertTitle: UILabel!
    @IBOutlet weak var alertSubTitle: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var complateButton: UIButton!
    
    
    private let viewModel = ProfileViewModel(userId: UserDefaults.standard.string(forKey: "userId") ?? "")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadProfileData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadProfileData()
    }
    
    
    @IBAction func exitButtonAction(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.isLoggedIn = false
        NavigationManager.shared.navigate(to: .login, from: self)
    }
    
    
}

//MARK: - Private Functions

extension ProfileViewController{
    
    private func handleProfileCompletion() {
        // alertTitle ve alertSubTitle güncellenir
        self.alertTitle.text = "Kişisel bilgileriniz tamamlandı"
        self.alertSubTitle.text = "Ders yönetimi amacıyla kişisel bilgilerinizi doldurduğunuz için teşekkür ederiz."

        self.complateProfileCardView.layer.borderColor = UIColor.systemGreen.cgColor
        progressLabel.text = "100%"
        progressLabel.textColor = UIColor.systemGreen
        complateButton.isHidden = true
    }
    
    private func loadProfileData() {
        viewModel.fetchUserData { user in
            if let profilePhotoBase64 = user.profilePhoto,
               let photoData = Data(base64Encoded: profilePhotoBase64),
               let profileImage = UIImage(data: photoData) {
                self.profilePhoto.image = profileImage
            } else {
                self.profilePhoto.image = UIImage(named: "defaultAvatar") // Varsayılan fotoğraf
            }
            self.nameLabel.text = user.fullname
            self.emailLabel.text = user.email
            self.updateCircularProgress(for: user)
        }
    }
    
    private func updateCircularProgress(for user: User) {
        let completionPercentage = viewModel.calculateProfileCompletion(for: user)
        setupCircularProgress(percantage: completionPercentage)
        if completionPercentage == 1.0 {
            handleProfileCompletion()
            setupCircularProgress(percantage: completionPercentage)
        }else{
            progressLabel.text = "\(Int(completionPercentage * 100))%"
            setupUI()
        }
    }
    
    private func setupCircularProgress(percantage: Float) {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: progressView.bounds.width / 2, y: progressView.bounds.height / 2),
                                      radius: progressView.bounds.width / 2,
                                      startAngle: -CGFloat.pi / 2,
                                      endAngle: 2 * CGFloat.pi - CGFloat.pi / 2,
                                      clockwise: true)
        
        // Arka plan çemberi
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.path = circlePath.cgPath
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.strokeColor = UIColor.lightGray.cgColor
        backgroundLayer.lineWidth = 4
        progressView.layer.addSublayer(backgroundLayer)
        
        // İlerleme çemberi
        let progressLayer = CAShapeLayer()
        progressLayer.path = circlePath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = percantage == 1.0 ? UIColor.systemGreen.cgColor : UIColor(named: "primaryBlue")?.cgColor
        progressLayer.lineWidth = 4
        progressLayer.strokeEnd = CGFloat(percantage) // %20'lik ilerleme
        progressView.layer.addSublayer(progressLayer)
        
        // Animasyon
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0 // Animasyonun başlangıç değeri
        animation.toValue = percantage // Animasyonun bitiş değeri
        animation.duration = 1.0 // Animasyon süresi (saniye)
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        progressLayer.strokeEnd = CGFloat(percantage) // Katmanın bitiş değeri güncellenir
        progressLayer.add(animation, forKey: "progressAnimation")
    }
    
    private func setupUI(){
        setupCircularProgress(percantage: 0.4)
        complateProfileCardView.layer.borderColor = UIColor(named: "primaryBlue")?.cgColor
        complateProfileCardView.layer.borderWidth = 1
        complateProfileCardView.layer.cornerRadius = 8
        complateProfileCardView.clipsToBounds = true
        profilePhoto.layer.cornerRadius = profilePhoto.frame.size.width / 2
        profilePhoto.clipsToBounds = true
        editProfileButton.layer.cornerRadius = 8
        progressLabel.textColor = UIColor(named: "primaryBlue")
        complateButton.isHidden = false

    }
}


