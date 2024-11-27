//
//  CourseModel.swift
//  LearnConnect
//
//  Created by Tural Babayev on 25.11.2024.
//

import Foundation

struct CourseModel{
    let id: Int
    var category: String
    var title: String
    var description: String?
    var thumbnailURL: String?
    var videoURL: String
    var instructorId: Int
    var rating: Double
    var enrolledCount: Int
    var totalDuration: Int
    
    mutating func updateTotalDuration(_ duration: Int) {
        self.totalDuration = duration
    }
}
