//
//  EditProfileViewModel.swift
//  LearnConnect
//
//  Created by Tural Babayev on 24.11.2024.
//

import Foundation

class EditProfileViewModel{
    private let userManager:UserManager
    private let userId: String

    var onUserLoaded: ((User) -> Void)?
    var onSaveSuccess: (() -> Void)?
    var onSaveError: ((String) -> Void)?
    
    init(userId: String, userManager: UserManager = .shared) {
        self.userId = userId
        self.userManager = userManager
    }
    
    func loadUserData() {
        userManager.getUser(byId: userId) { user in
            if let user = user {
                self.onUserLoaded?(user)
            } else {
                self.onSaveError?("Kullanıcı bulunamadı.")
            }
        }
    }
    
    func saveUserData(fullname: String, profilePhoto: String?, birthday: String?, gender: String, university: String?, phone: String?) {
        userManager.getUser(byId: userId) { existingUser in
            guard let existingUser = existingUser else {
                self.onSaveError?("Kullanıcı bilgileri alınamadı.")
                return
            }

            // Güncellenmiş kullanıcı bilgisi
            let updatedUser = User(
                id: existingUser.id,
                fullname: fullname,
                email: existingUser.email, // Email sabit kalır
                phone: phone, // Telefon numarası sabit kalır
                birthday: birthday,
                gender: gender,
                university: university,
                profilePhoto: profilePhoto
            )

            // UserManager üzerinden kaydetme işlemi
            self.userManager.updateUser(updatedUser) { success in
                if success {
                    self.onSaveSuccess?()
                } else {
                    self.onSaveError?("Bilgiler güncellenirken bir hata oluştu.")
                }
            }
        }
    }
}
