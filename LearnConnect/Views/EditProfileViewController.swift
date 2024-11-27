//
//  EditProfileViewController.swift
//  LearnConnect
//
//  Created by Tural Babayev on 24.11.2024.
//

import UIKit

class EditProfileViewController:
    UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var genderSegment: UISegmentedControl!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var universityTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
        

    private let viewModel = EditProfileViewModel(userId: UserDefaults.standard.string(forKey: "userId") ?? "")
    private var selectedProfilePhoto: UIImage? // Seçilen profil fotoğrafını tutar


    
    override func viewDidLoad() {
        super.viewDidLoad()
        UISetup()
        setupBindings()
        viewModel.loadUserData()
        setupProfilePhotoTapGesture()
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        let fullname = fullnameTextField.text ?? ""
        let phone = phoneTextField.text
        let gender = genderSegment.selectedSegmentIndex == 0 ? "Erkek" : "Kadın"
        let birthday = birthdayTextField.text
        let university = universityTextField.text
        let profilePhotoBase64 = selectedProfilePhoto?.jpegData(compressionQuality: 0.8)?.base64EncodedString()

        viewModel.saveUserData(fullname: fullname, profilePhoto: profilePhotoBase64, birthday: birthday, gender: gender, university: university, phone: phone)
    }
    
    
}

//MARK: - Private Functions
extension EditProfileViewController {
    func UISetup() {
        fullnameTextField.setLeftIcon(UIImage(named: "person")!)
        fullnameTextField.setupBorderStyle()
        
        phoneTextField.text = "+90 "
        phoneTextField.setLeftIcon(UIImage(named: "person")!) // Telefon ikonu
        phoneTextField.setupBorderStyle()
        phoneTextField.keyboardType = .numberPad // Sadece numara girişi
        
        saveButton.layer.cornerRadius = 8
        setupDatePicker()
        setupGestureToDismissKeyboard()
        
        profilePhotoImageView.layer.cornerRadius = profilePhotoImageView.frame.size.width / 2

    }
    
    private func setupBindings() {
        viewModel.onUserLoaded = { user in
            self.fullnameTextField.text = user.fullname
            self.phoneTextField.text = user.phone ?? "+90 "
            self.genderSegment.selectedSegmentIndex = (user.gender == "Erkek") ? 0 : 1
            self.birthdayTextField.text = user.birthday
            self.universityTextField.text = user.university
            
            if let profilePhotoBase64 = user.profilePhoto,
               let photoData = Data(base64Encoded: profilePhotoBase64),
               let profileImage = UIImage(data: photoData) {
                self.profilePhotoImageView.image = profileImage
            } else{
                self.profilePhotoImageView.image = UIImage(named: "defaultAvatar")

            }
        }

        viewModel.onSaveSuccess = {
            self.showMessage("Bilgiler başarıyla güncellendi!", isSuccess: true)
            self.navigationController?.popViewController(animated: true)
        }

        viewModel.onSaveError = { error in
            self.showMessage(error, isSuccess: false)
        }
    }
    
    private func setupProfilePhotoTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profilePhotoTapped))
        profilePhotoImageView.isUserInteractionEnabled = true
        profilePhotoImageView.addGestureRecognizer(tapGesture)
    }

    @objc private func profilePhotoTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary // Galeriden seçmek için
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func showMessage(_ message: String, isSuccess: Bool) {
        let alert = UIAlertController(title: isSuccess ? "Başarılı" : "Hata", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func setupSegmentedControl() {
        genderSegment.removeAllSegments()
        genderSegment.insertSegment(withTitle: "Erkek", at: 0, animated: false)
        genderSegment.insertSegment(withTitle: "Kadın", at: 1, animated: false)
        genderSegment.selectedSegmentIndex = 0 // Varsayılan seçim
    }
    
    private func setupDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        datePicker.locale = Locale(identifier: "tr_TR")

        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Tamam", style: .done, target: self, action: #selector(dismissDatePicker))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: true)
        birthdayTextField.inputAccessoryView = toolbar
        birthdayTextField.inputView = datePicker
    }
    
    private func setupGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }


    @objc private func dateChanged(_ sender: UIDatePicker) {
        // Tarih formatı belirle
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy" // Gün/Ay/Yıl formatı
        birthdayTextField.text = formatter.string(from: sender.date)
    }

    @objc private func dismissDatePicker() {
        // DatePicker'ı kapat
        view.endEditing(true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
}

//MARK:-UIImagePickerControllerDelegate
extension EditProfileViewController: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let selectedImage = info[.editedImage] as? UIImage {
                profilePhotoImageView.image = selectedImage // Seçilen resmi göster
                selectedProfilePhoto = selectedImage
            }
            picker.dismiss(animated: true, completion: nil)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
}

