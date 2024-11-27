//
//  AuthManager.swift
//  LearnConnect
//
//  Created by Tural Babayev on 23.11.2024.
//

import FirebaseAuth

enum AuthError: Error {
    case custom(String)
}

final class AuthManager{
    static let shared = AuthManager()
    private init() {}
    
    func register(email: String, password: String, fullname: String , completion: @escaping (Result<User, AuthError>) -> Void) {
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error as NSError? {
                    let message = self.mapErrorToTurkishMessage(error)
                    completion(.failure(.custom(message))) // Custom error ile döndürüyoruz
                } else if let result = result {
                    let userId = result.user.uid
                    // Kullanıcıyı oluştur ve döndür
                    let newUser = User(
                        id: userId,
                        fullname: fullname,
                        email: email,
                        phone: nil,
                        birthday: nil,
                        gender: nil,
                        university: nil,
                        profilePhoto: nil
                    )
                    completion(.success(newUser))
                }
            }
        }
        
    func login(email: String, password: String, completion: @escaping (Result<User, AuthError>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error as NSError? {
                let message = self.mapErrorToTurkishMessage(error)
                completion(.failure(.custom(message))) // Custom error ile döndürüyoruz
            } else if let result = result {
                // Giriş yapan kullanıcı bilgilerini döndür
                let userId = result.user.uid
                let userEmail = result.user.email ?? ""
                // Varsayılan kullanıcı modeli oluştur
                let loggedInUser = User(
                    id: userId,
                    fullname: "", // Bu bilgi sonradan alınabilir
                    email: userEmail,
                    phone: nil,
                    birthday: nil,
                    gender: nil,
                    university: nil,
                    profilePhoto: nil
                )
                completion(.success(loggedInUser))
            }
        }
    }
    
    // Şifre Sıfırlama
    func resetPassword(email: String, completion: @escaping (Result<Void, AuthError>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error as NSError? {
                let message = self.mapErrorToTurkishMessage(error)
                completion(.failure(.custom(message)))
            } else {
                completion(.success(()))
            }
        }
    }
    
    private func mapErrorToTurkishMessage(_ error: NSError) -> String {
        switch error.code {
        case AuthErrorCode.invalidEmail.rawValue:
            return "Geçersiz bir e-posta adresi girdiniz."
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return "Bu e-posta adresi zaten kullanılıyor."
        case AuthErrorCode.weakPassword.rawValue:
            return "Şifreniz çok zayıf. Lütfen daha güçlü bir şifre seçin."
        case AuthErrorCode.wrongPassword.rawValue:
            return "Şifreniz yanlış. Lütfen tekrar deneyin."
        case 17011:
            return "Bu e-posta adresine ait bir kullanıcı bulunamadı."
        default:
            return "Bir hata oluştu. Lütfen tekrar deneyin."
        }
    }
}
