//
//  RegisterViewModel.swift
//  LearnConnect
//
//  Created by Tural Babayev on 23.11.2024.
//

import Foundation

final class RegisterViewModel{
    private let userManager = UserManager.shared
    var onSuccess: ((User) -> Void)?
    var onError: ((String)->Void)?
    
    
    func register(email: String, password: String,fullname: String) {
        AuthManager.shared.register(email: email, password: password,fullname: fullname) { result in
            switch result {
            case .success(let user):
                self.userManager.saveUser(user) { success in
                    if success {
                        // Kaydetme başarılı, success callback çağrılıyor
                        self.onSuccess?(user)
                    } else {
                        // Kaydetme sırasında hata oluştu
                        self.onError?("Kullanıcı verileri kaydedilirken bir hata oluştu.")
                    }
                }
            case .failure(let authError): // AuthError türünde hata alıyoruz
                if case let .custom(message) = authError {
                    self.onError?(message) // Hata mesajını gönderiyoruz
                } else {
                    self.onError?("Bilinmeyen bir hata oluştu.") // Genel bir hata mesajı
                }
            }
        }
    }
}
