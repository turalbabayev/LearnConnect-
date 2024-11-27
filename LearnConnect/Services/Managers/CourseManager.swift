//
//  CourseManager.swift
//  LearnConnect
//
//  Created by Tural Babayev on 25.11.2024.
//

import Foundation
import RxSwift


class CourseManager{
    static let shared = CourseManager()
    let db: FMDatabase?
    var categoryList = BehaviorSubject<[String]>(value: [String]())
    var courseList = BehaviorSubject<[CourseModel]>(value: [CourseModel]())
    var popularCourseList = BehaviorSubject<[CourseModel]>(value: [CourseModel]())


    
    private init() {
        let destionationPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let databaseURL = URL(fileURLWithPath: destionationPath).appendingPathComponent("learnConnect.db")
        db = FMDatabase(path: databaseURL.path)
    }
    
    func getCategories(){
        db?.open()
        
        do{
            var uniqueCategories = Set<String>() // Tekrarlayan verileri engellemek için Set kullanıyoruz
            var liste = [String]()
            
            let rs = try db!.executeQuery("SELECT * FROM Courses", values: nil)
            
            while rs.next() {
                let category = String(rs.string(forColumn: "category") ?? "Default")
                // Eğer Set'e eklenirse (yeni bir kategori ise), listeye de ekliyoruz
                if uniqueCategories.insert(category).inserted {
                    liste.append(category)
                }
            }
            
            categoryList.onNext(liste)//Tetikleme
        }catch{
            print(error.localizedDescription)
        }
        
        db?.close()
    }
    
    func getCourses(){
        db?.open()
        
        do{
            var listCourse = [CourseModel]()
            
            let rs = try db!.executeQuery("SELECT * FROM Courses", values: nil)
            
            while rs.next() {
                let courseId = Int(rs.string(forColumn: "Id") ?? "0")
                let category = String(rs.string(forColumn: "category") ?? "Default")
                let title = String(rs.string(forColumn: "title") ?? "Default")
                let description = String(rs.string(forColumn: "description") ?? "Default")
                let instructor = Int(rs.string(forColumn: "instructor") ?? "0") ?? 0
                let endrolledCount = Int(rs.string(forColumn: "enrolled_count") ?? "Default")
                let _ = String(rs.string(forColumn: "comments") ?? "Default")
                let totalDuration = Int(rs.string(forColumn: "video_duration") ?? "0") ?? 0
                let videoURL = String(rs.string(forColumn: "courseVideoURL") ?? "Default")
                let thumbnail = String(rs.string(forColumn: "thumbnail") ?? "Default")
                let rating = Int(rs.string(forColumn: "rating") ?? "5")
                
                let course = CourseModel(id: courseId!, category: category, title: title,description: description, thumbnailURL: thumbnail, videoURL: videoURL, instructorId: instructor, rating: Double(rating ?? 5), enrolledCount: endrolledCount!, totalDuration: totalDuration)
                
                listCourse.append(course)
            }
            
            courseList.onNext(listCourse)//Tetikleme
            
            // Popüler kurslardan rastgele 5 tane seç
            let popularCourses = getRandomPopularCourses(from: listCourse, count: 5)
            popularCourseList.onNext(popularCourses)
            
        }catch{
            print(error.localizedDescription)
        }
        
        db?.close()
    }
    
    func getRandomPopularCourses(from courses: [CourseModel], count: Int) -> [CourseModel] {
        guard courses.count > count else {
            // Eğer kurs sayısı istenen miktardan az ise, tüm kursları döndür
            return courses
        }
        
        // Rastgele kursları seçmek için shuffle ve prefix kullanıyoruz
        return Array(courses.shuffled().prefix(count))
    }
    
    func searchCourse(searchText:String){
        db?.open()
        
        do{
            var listCourse = [CourseModel]()
            
            let rs = try db!.executeQuery("SELECT * FROM Courses WHERE title like '%\(searchText)%'", values: nil)
            
            while rs.next(){
                let courseId = Int(rs.string(forColumn: "Id") ?? "0")
                let category = String(rs.string(forColumn: "category") ?? "Default")
                let title = String(rs.string(forColumn: "title") ?? "Default")
                let description = String(rs.string(forColumn: "description") ?? "Default")
                let instructor = Int(rs.string(forColumn: "instructor") ?? "0") ?? 0
                let endrolledCount = Int(rs.string(forColumn: "enrolled_count") ?? "Default")
                let _ = String(rs.string(forColumn: "comments") ?? "Default")
                let totalDuration = Int(rs.string(forColumn: "video_duration") ?? "0") ?? 0
                let videoURL = String(rs.string(forColumn: "courseVideoURL") ?? "Default")
                let thumbnail = String(rs.string(forColumn: "thumbnail") ?? "Default")
                let rating = Int(rs.string(forColumn: "rating") ?? "5")
                
                let course = CourseModel(id: courseId!, category: category, title: title,description: description, thumbnailURL: thumbnail, videoURL: videoURL, instructorId: instructor, rating: Double(rating ?? 5), enrolledCount: endrolledCount!, totalDuration: totalDuration)
                
                listCourse.append(course)
                
            }
            courseList.onNext(listCourse)//Tetikleme
        }catch{
            print(error.localizedDescription)
        }
        
        db?.close()
    }
    
    
    func getCourseByCategory(category:String){
        db?.open()
        
        do{
            var listCourse = [CourseModel]()
            
            let rs = try db!.executeQuery("SELECT * FROM Courses WHERE category = ?", values: [category])
            
            while rs.next(){
                let courseId = Int(rs.string(forColumn: "Id") ?? "0")
                let category = String(rs.string(forColumn: "category") ?? "Default")
                let title = String(rs.string(forColumn: "title") ?? "Default")
                let description = String(rs.string(forColumn: "description") ?? "Default")
                let instructor = Int(rs.string(forColumn: "instructor") ?? "0") ?? 0
                let endrolledCount = Int(rs.string(forColumn: "enrolled_count") ?? "Default")
                let _ = String(rs.string(forColumn: "comments") ?? "Default")
                let totalDuration = Int(rs.string(forColumn: "video_duration") ?? "0") ?? 0
                let videoURL = String(rs.string(forColumn: "courseVideoURL") ?? "Default")
                let thumbnail = String(rs.string(forColumn: "thumbnail") ?? "Default")
                let rating = Int(rs.string(forColumn: "rating") ?? "5")
                
                let course = CourseModel(id: courseId!, category: category, title: title,description: description, thumbnailURL: thumbnail, videoURL: videoURL, instructorId: instructor, rating: Double(rating!), enrolledCount: endrolledCount!, totalDuration: totalDuration)
                
                listCourse.append(course)
                
            }
            courseList.onNext(listCourse)//Tetikleme
        }catch{
            print(error.localizedDescription)
        }
        
        db?.close()
    }
    
    func getEnrolledCount(courseId: Int) -> Int {
        db?.open()
        var enrolledCount = 0

        do {
            let resultSet = try db!.executeQuery("""
                SELECT enrolled_count FROM Courses WHERE id = ?
            """, values: [courseId])
            
            if resultSet.next() {
                enrolledCount = Int(resultSet.int(forColumn: "enrolled_count"))
            }
        } catch {
            print("Error fetching enrolled count: \(error.localizedDescription)")
        }
        db?.close()
        return enrolledCount
    }
    
}
