//
//  FavoriteViewModel.swift
//  LearnConnect
//
//  Created by Tural Babayev on 26.11.2024.
//

import Foundation
import RxSwift

class FavoriteViewModel{
    private let userCourseManager = UserCourseManager.shared
    var favCourseList = BehaviorSubject<[CourseModel]>(value: [CourseModel]())
    var favCourseCategory = BehaviorSubject<[String]>(value: [String]())
    let userId = UserDefaults.standard.string(forKey: "userId") ?? ""

    
    static let shared = FavoriteViewModel()

    init(){
        favCourseList = userCourseManager.favCourseList
        getFavoriteCourses()
        favCourseCategory = userCourseManager.favCourseCategory

    }
    
    func getFavoriteCourses(){
        userCourseManager.getFavoriteCourses(userId: userId)
    }
    
}
