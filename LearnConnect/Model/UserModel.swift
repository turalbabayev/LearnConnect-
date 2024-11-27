//
//  UserModel.swift
//  LearnConnect
//
//  Created by Tural Babayev on 24.11.2024.
//

import Foundation

struct User {
    let id: String
    var fullname: String
    var email: String
    var phone: String?
    var birthday: String?
    var gender: String?
    var university: String?
    var profilePhoto: String? // URL veya local dosya yolu
}

