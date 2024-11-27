//
//  UserCourseManager.swift
//  LearnConnect
//
//  Created by Tural Babayev on 26.11.2024.
//

import Foundation
import RxSwift

class UserCourseManager{
    static let shared = UserCourseManager()
    private let db: FMDatabase?
    var favCourseList = BehaviorSubject<[CourseModel]>(value: [CourseModel]())
    var favCourseCategory = BehaviorSubject<[String]>(value: [String]())
    var enrolledCourses = BehaviorSubject<[(course: CourseModel, progress: Double)]>(value: [(course: CourseModel, progress: Double)]())

    
    private init(){
        let destionationPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let databaseURL = URL(fileURLWithPath: destionationPath).appendingPathComponent("learnConnect.db")
        db = FMDatabase(path: databaseURL.path)
    }
    
    func isUserEnrolledInCourse(userId: String, courseId: Int) -> Bool {
        db?.open()
        var isEnrolled = false

        do {
            let resultSet = try db!.executeQuery(
                "SELECT COUNT(*) AS count FROM UserCourses WHERE user_id = ? AND course_id = ? AND is_enrolled = 1",
                values: [userId, courseId]
            )
            if resultSet.next() {
                isEnrolled = resultSet.int(forColumn: "count") > 0
            }
        } catch {
            print("Error checking enrollment: \(error.localizedDescription)")
        }
        
        db?.close()
        return isEnrolled
    }

    func enrollUserInCourse(userId: String, courseId: Int,enrollled_count:Int) {
        db?.open()
        do {
            try db!.executeUpdate("""
                INSERT INTO UserCourses (user_id, course_id, is_enrolled, watched_minutes, progress_percentage)
                VALUES (?, ?, 1, 0, 0)
            """, values: [userId, courseId])
            try db!.executeUpdate("UPDATE Courses SET enrolled_count = ? WHERE Id = ?", values: [enrollled_count,courseId])
            
        } catch {
            print("Error enrolling user: \(error.localizedDescription)")
        }
        db?.close()
    }

    func saveProgress(userId: String, courseId: Int, progressInSeconds: Double) {
        db?.open()
        let progressPercentage = (progressInSeconds / (60 * 60)) * 100 // Toplam süreye göre yüzde hesaplama
        do {
            try db!.executeUpdate("""
                UPDATE UserCourses SET watched_minutes = ?, progress_percentage = ?
                WHERE user_id = ? AND course_id = ?
            """, values: [progressInSeconds / 60, progressPercentage, userId, courseId]) // Dakika olarak kaydet
            print("Progress saved successfully: \(progressInSeconds / 60) minutes")
        } catch {
            print("Error saving progress: \(error.localizedDescription)")
        }
        db?.close()
    }

    func getProgress(userId: String, courseId: Int) -> Double {
        db?.open()
        var progressInSeconds: Double = 0

        do {
            let resultSet = try db!.executeQuery(
                "SELECT watched_minutes FROM UserCourses WHERE user_id = ? AND course_id = ?",
                values: [userId, courseId]
            )
            if resultSet.next() {
                progressInSeconds = resultSet.double(forColumn: "watched_minutes") * 60
                print("getProgress - Progress in Seconds: \(progressInSeconds)")

            }
        } catch {
            print("Error getting progress: \(error.localizedDescription)")
        }
        db?.close()
        return progressInSeconds
    }
    
    func getFavoriteStatus(userId: String, courseId: Int) -> Bool {
        db?.open()
        var isFavorited = false
        
        do {
            let resultSet = try db!.executeQuery(
                "SELECT is_favorited FROM UserCourses WHERE user_id = ? AND course_id = ?",
                values: [userId, courseId]
            )
            if resultSet.next() {
                isFavorited = resultSet.bool(forColumn: "is_favorited")
            } else {
                print("No rows found for the given user and course")
            }
        } catch {
            print("Error getting favorite status: \(error.localizedDescription)")
        }
        
        db?.close()
        return isFavorited
    }
    
    func updateFavoriteStatus(userId: String, courseId: Int, isFavorited: Bool) {
        db?.open()

        do {
            let checkQuery = "SELECT COUNT(*) AS count FROM UserCourses WHERE user_id = ? AND course_id = ?"
            let resultSet = try db!.executeQuery(checkQuery, values: [userId, courseId])

            if resultSet.next() && resultSet.int(forColumn: "count") == 0 {
                try db!.executeUpdate("""
                    INSERT INTO UserCourses (user_id, course_id, is_favorited)
                    VALUES (?, ?, ?)
                """, values: [userId, courseId, isFavorited ? 1 : 0])
            } else {
                try db!.executeUpdate(
                    "UPDATE UserCourses SET is_favorited = ? WHERE user_id = ? AND course_id = ?",
                    values: [isFavorited ? 1 : 0, userId, courseId]
                )
            }
        } catch {
            print("Error updating favorite status: \(error.localizedDescription)")
        }

        db?.close()
    }
    
    func getFavoriteCourses(userId: String){
        db?.open()
        
        do{
            var listCourse = [CourseModel]()

            let query = """
                    SELECT c.Id, c.category, c.title, c.description, c.thumbnail, c.courseVideoURL,
                           c.instructor, c.rating, c.enrolled_count, c.video_duration
                    FROM Courses c
                    JOIN UserCourses uc ON c.Id = uc.course_id
                    WHERE uc.user_id = ? AND uc.is_favorited = 1
                    """
            
            let rs = try db!.executeQuery(query, values: [userId])
            
            while rs.next(){
                let course = CourseModel(
                    id: Int(rs.int(forColumn: "Id")),
                    category: rs.string(forColumn: "category") ?? "",
                    title: rs.string(forColumn: "title") ?? "",
                    description: rs.string(forColumn: "description"),
                    thumbnailURL: rs.string(forColumn: "thumbnail"),
                    videoURL: rs.string(forColumn: "courseVideoURL") ?? "",
                    instructorId: Int(rs.int(forColumn: "instructor")),
                    rating: rs.double(forColumn: "rating"),
                    enrolledCount: Int(rs.int(forColumn: "enrolled_count")),
                    totalDuration: Int(rs.int(forColumn: "video_duration"))
                )
                listCourse.append(course)
            }
            favCourseList.onNext(listCourse)//Tetikleme

            let categories = getUniqueCategories(from: listCourse)
            favCourseCategory.onNext(categories)

        }catch{
            print("Error fetching favorite courses: \(error.localizedDescription)")
        }
        
        db?.close()
    }
    
    func getUniqueCategories(from courses: [CourseModel]) -> [String] {
        let categories = Set(courses.map { $0.category })
        return Array(categories)
    }
    
    func getOngoingCourses(userId: String){
        db?.open()
        
        do{
            var listCourse = [CourseModel]()

            let query = """
                    SELECT c.Id, c.category, c.title, c.description, c.thumbnail, c.courseVideoURL,
                           c.instructor, c.rating, c.enrolled_count, c.video_duration
                    FROM Courses c
                    JOIN UserCourses uc ON c.Id = uc.course_id
                    WHERE uc.user_id = ? AND uc.is_favorited = 1
                    """
            
            let rs = try db!.executeQuery(query, values: [userId])
            
            while rs.next(){
                let course = CourseModel(
                    id: Int(rs.int(forColumn: "Id")),
                    category: rs.string(forColumn: "category") ?? "",
                    title: rs.string(forColumn: "title") ?? "",
                    description: rs.string(forColumn: "description"),
                    thumbnailURL: rs.string(forColumn: "thumbnail"),
                    videoURL: rs.string(forColumn: "courseVideoURL") ?? "",
                    instructorId: Int(rs.int(forColumn: "instructor")),
                    rating: rs.double(forColumn: "rating"),
                    enrolledCount: Int(rs.int(forColumn: "enrolled_count")),
                    totalDuration: Int(rs.int(forColumn: "video_duration"))
                )
                listCourse.append(course)
            }
            favCourseList.onNext(listCourse)//Tetikleme

        }catch{
            print("Error fetching favorite courses: \(error.localizedDescription)")
        }
        
        db?.close()
    }
    
    func getEnrolledCoursesWithProgress(userId: String) {
        var enrolledCoursesWithProcess: [(course: CourseModel, progress: Double)] = []
        db?.open()

        do {
            let query = """
            SELECT
                c.Id,
                c.category,
                c.title,
                c.description,
                c.thumbnail,
                c.courseVideoURL,
                c.instructor,
                c.rating,
                c.enrolled_count,
                c.video_duration,
                uc.progress_percentage
            FROM
                Courses c
            JOIN
                UserCourses uc
            ON
                c.Id = uc.course_id
            WHERE
                uc.user_id = ? AND uc.is_enrolled = 1;
            """
            
            let resultSet = try db!.executeQuery(query, values: [userId])

            while resultSet.next() {
                let course = CourseModel(
                    id: Int(resultSet.int(forColumn: "Id")),
                    category: resultSet.string(forColumn: "category") ?? "",
                    title: resultSet.string(forColumn: "title") ?? "",
                    description: resultSet.string(forColumn: "description"),
                    thumbnailURL: resultSet.string(forColumn: "thumbnail"),
                    videoURL: resultSet.string(forColumn: "courseVideoURL") ?? "",
                    instructorId: Int(resultSet.int(forColumn: "instructor")),
                    rating: resultSet.double(forColumn: "rating"),
                    enrolledCount: Int(resultSet.int(forColumn: "enrolled_count")),
                    totalDuration: Int(resultSet.int(forColumn: "video_duration"))
                )
                let progress = resultSet.double(forColumn: "progress_percentage")
                enrolledCoursesWithProcess.append((course, progress))
                
            }
            enrolledCourses.onNext(enrolledCoursesWithProcess)
        } catch {
            print("Error fetching enrolled courses with progress: \(error.localizedDescription)")
        }

        db?.close()
    }
}
