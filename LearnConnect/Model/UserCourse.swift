//
//  UserCourse.swift
//  LearnConnect
//
//  Created by Tural Babayev on 25.11.2024.
//

import Foundation

struct UserCourse{
    let id: Int
    let userId: Int
    let courseId: Int
    let watchedMinutes: Int
    let progressPercentage: Double // İlerleme yüzdesi
    let isFavorited: Bool // Favori durumu
    let isEnrolled: Bool // Kayıt durumu
}
