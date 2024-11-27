//
//  ForgotPasswordViewModel.swift
//  LearnConnect
//
//  Created by Tural Babayev on 23.11.2024.
//

import Foundation


class ForgotPasswordViewModel {
    var onSuccess: (() -> Void)?
    var onError: ((String) -> Void)?

    func resetPassword(email: String) {
        AuthManager.shared.resetPassword(email: email) { result in
            switch result {
            case .success:
                self.onSuccess?()
            case .failure(let authError):
                if case let .custom(message) = authError {
                    self.onError?(message) // Hata mesajını gönderiyoruz
                } else {
                    self.onError?("Bilinmeyen bir hata oluştu.") // Genel bir hata mesajı
                }
            }
        }
    }
}
