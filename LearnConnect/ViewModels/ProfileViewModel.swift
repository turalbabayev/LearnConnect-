//
//  ProfileViewModel.swift
//  LearnConnect
//
//  Created by Tural Babayev on 24.11.2024.
//

import Foundation

class ProfileViewModel {
    private let userManager: UserManager
    private let userId: String
    
    var onProfileCompletion: ((String, String) -> Void)? // Tamamlama mesajları için callback

    init(userId: String, userManager: UserManager = .shared) {
        self.userId = userId
        self.userManager = userManager
    }

    func fetchUserData(completion: @escaping (User) -> Void) {
        userManager.getUser(byId: userId) { user in
            if let user = user {
                completion(user)
            } else {
                let emptyUser = User(
                    id: self.userId,
                    fullname: "Ad Soyad",
                    email: "example@example.com",
                    phone: nil,
                    birthday: nil,
                    gender: nil,
                    university: nil,
                    profilePhoto: nil
                )
                completion(emptyUser)
            }
        }
    }


    func calculateProfileCompletion(for user: User) -> Float {
        // Doldurulması gereken tüm alanlar
        let fields = [
            user.fullname,
            user.email,
            user.phone,
            user.birthday,
            user.gender,
            user.university,
            user.profilePhoto // Fotoğraf da bir alan olarak eklendi
        ]
        
        // Dolu olan alanların sayısını hesapla
        let completedFields = fields.filter { $0 != nil && !$0!.isEmpty }
        
        // Tamamlama yüzdesini hesapla
        return Float(completedFields.count) / Float(fields.count)
    }
}
