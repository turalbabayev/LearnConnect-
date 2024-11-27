//
//  MyCoursesViewModel.swift
//  LearnConnect
//
//  Created by Tural Babayev on 27.11.2024.
//

import Foundation
import RxSwift

class MyCoursesViewModel{
    private let userCourseManager = UserCourseManager.shared
    var enrolledCourses = BehaviorSubject<[(course: CourseModel, progress: Double)]>(value: [(course: CourseModel, progress: Double)]())
    let userId = UserDefaults.standard.string(forKey: "userId") ?? ""

    
    static let shared = MyCoursesViewModel()

    init(){
        enrolledCourses = userCourseManager.enrolledCourses
        getEnrolledCoursesWithProgress()
    }
    
    func getEnrolledCoursesWithProgress(){
        userCourseManager.getEnrolledCoursesWithProgress(userId: userId)
    }
    
}
