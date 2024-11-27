//
//  HomeViewModel.swift
//  LearnConnect
//
//  Created by Tural Babayev on 25.11.2024.
//

import Foundation
import RxSwift
import UIKit

class HomeViewModel{
    static let themeDidChangeNotification = Notification.Name("themeDidChangeNotification")
    private let courseManager = CourseManager.shared
    private let userManager = UserManager.shared
    let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
    
    var categoryList = BehaviorSubject<[String]>(value: [String]())
    var courseList = BehaviorSubject<[CourseModel]>(value: [CourseModel]())
    var popularCourseList = BehaviorSubject<[CourseModel]>(value: [CourseModel]())


    static let shared = HomeViewModel()

    
    init(){
        getCategories()
        categoryList = courseManager.categoryList
        getCourses()
        courseList = courseManager.courseList
        popularCourseList = courseManager.popularCourseList
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
    
    
    
    func getCategories(){
        courseManager.getCategories()
    }
    
    func getCourses(){
        courseManager.getCourses()
    }
    
    func searchCourse(searchText:String){
        courseManager.searchCourse(searchText: searchText)
    }
    
    func getCourseByCategory(category:String){
        courseManager.getCourseByCategory(category: category)
    }
    
    func toggleTheme(currentStyle: UIUserInterfaceStyle) {
        let newStyle: UIUserInterfaceStyle = (currentStyle == .dark) ? .light : .dark
        UserDefaults.standard.set(newStyle == .dark ? "dark" : "light", forKey: "theme")

        // Tema değişikliği bildirimi gönder
        NotificationCenter.default.post(name: HomeViewModel.themeDidChangeNotification, object: nil, userInfo: ["style": newStyle])

        // SceneDelegate üzerinden temayı uygula
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.applyTheme(style: newStyle)
        }
    }

    func loadSavedTheme() -> UIUserInterfaceStyle {
        let theme = UserDefaults.standard.string(forKey: "theme")
        return (theme == "dark") ? .dark : .light
    }
    
    
    
}
