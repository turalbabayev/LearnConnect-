//
//  LoginViewModel.swift
//  LearnConnect
//
//  Created by Tural Babayev on 23.11.2024.
//

import Foundation

class LoginViewModel{
    var onSuccess: ((User) -> Void)?
    var onError: ((String)->Void)?
    
    func login(email: String, password: String) {
        AuthManager.shared.login(email: email, password: password) { result in
            switch result {
            case .success(let user):
                UserDefaults.standard.set(user.id, forKey: "userId") // UUID saklanıyor
                self.onSuccess?(user)
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
