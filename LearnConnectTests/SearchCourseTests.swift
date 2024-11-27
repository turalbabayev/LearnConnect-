//
//  CourseManagerTests.swift
//  LearnConnectTests
//
//  Created by Tural Babayev on 27.11.2024.
//

import XCTest
import RxSwift
@testable import LearnConnect


final class SearchCourseTests: XCTestCase {

    var courseManager: CourseManager!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        courseManager = CourseManager.shared
        disposeBag = DisposeBag()
        
        // Veritabanını temizle ve test verilerini ekle
        let db = courseManager.db
        db?.open()
        try? db?.executeUpdate("DELETE FROM Courses", values: nil)
        try? db?.executeUpdate("""
            INSERT INTO Courses (Id, category, title, description, instructor, enrolled_count, video_duration, courseVideoURL, thumbnail, rating)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, values: [1, "Programming", "Swift Basics", "Learn the basics of Swift", 1, 100, 120, "dummy1.mp4", "dummy1.jpg", 4.5])
        try? db?.executeUpdate("""
            INSERT INTO Courses (Id, category, title, description, instructor, enrolled_count, video_duration, courseVideoURL, thumbnail, rating)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, values: [2, "Design", "UI Design", "Learn UI/UX design principles", 2, 50, 90, "dummy2.mp4", "dummy2.jpg", 5.0])
        db?.close()
    }
    
    override func tearDown() {
        courseManager = nil
        disposeBag = nil
        super.tearDown()
    }
    
    func testSearchCourse_withEmptyText_returnsAllCourses() {
        // Arama metni boşken tüm kurslar dönmeli
        let expectation = XCTestExpectation(description: "All courses should be returned")
        
        courseManager.searchCourse(searchText: "")
        courseManager.courseList
            .subscribe(onNext: { courses in
                XCTAssertEqual(courses.count, 2)
                XCTAssertEqual(courses[0].title, "Swift Basics")
                XCTAssertEqual(courses[1].title, "UI Design")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSearchCourse_withMatchingText_returnsFilteredCourses() {
        // "Swift" içeren başlık dönmeli
        let expectation = XCTestExpectation(description: "Matching courses should be returned")
        
        courseManager.searchCourse(searchText: "Swift")
        courseManager.courseList
            .subscribe(onNext: { courses in
                XCTAssertEqual(courses.count, 1)
                XCTAssertEqual(courses[0].title, "Swift Basics")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSearchCourse_withNonMatchingText_returnsEmptyList() {
        // Eşleşmeyen arama metni boş liste döndürmeli
        let expectation = XCTestExpectation(description: "No courses should be returned")
        
        courseManager.searchCourse(searchText: "NonExistingCourse")
        courseManager.courseList
            .subscribe(onNext: { courses in
                XCTAssertEqual(courses.count, 0)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 1.0)
    }

}
