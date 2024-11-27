//
//  CourseManagerGetCategoriesTests.swift
//  LearnConnectTests
//
//  Created by Tural Babayev on 27.11.2024.
//

import XCTest
import RxSwift
@testable import LearnConnect


final class CourseManagerGetCategoriesTests: XCTestCase {

    var courseManager: CourseManager!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        courseManager = CourseManager.shared
        disposeBag = DisposeBag()
        
        // Test veritabanını temizle ve kategoriler için örnek veriler ekle
        let db = courseManager.db
        db?.open()
        try? db?.executeUpdate("DELETE FROM Courses", values: nil)
        try? db?.executeUpdate("""
            INSERT INTO Courses (Id, category, title, description, instructor, enrolled_count, video_duration, courseVideoURL, thumbnail, rating)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, values: [1, "Programming", "Swift Basics", "Learn Swift", 1, 100, 120, "dummy1.mp4", "dummy1.jpg", 4.5])
        try? db?.executeUpdate("""
            INSERT INTO Courses (Id, category, title, description, instructor, enrolled_count, video_duration, courseVideoURL, thumbnail, rating)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, values: [2, "Programming", "Advanced Swift", "Master Swift", 2, 200, 180, "dummy2.mp4", "dummy2.jpg", 5.0])
        try? db?.executeUpdate("""
            INSERT INTO Courses (Id, category, title, description, instructor, enrolled_count, video_duration, courseVideoURL, thumbnail, rating)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, values: [3, "Design", "UI Design", "Learn UI/UX", 3, 150, 100, "dummy3.mp4", "dummy3.jpg", 4.0])
        db?.close()
    }
    
    override func tearDown() {
        courseManager = nil
        disposeBag = nil
        super.tearDown()
    }
    
    func testGetCategories_returnsUniqueCategories() {
        // Beklenen benzersiz kategoriler
        let expectation = XCTestExpectation(description: "Unique categories should be returned")
        
        // getCategories() fonksiyonunu çağır
        courseManager.getCategories()
        
        // categoryList BehaviorSubject'ini dinle
        courseManager.categoryList
            .subscribe(onNext: { categories in
                XCTAssertEqual(categories.count, 2) // "Programming" ve "Design"
                XCTAssertTrue(categories.contains("Programming"))
                XCTAssertTrue(categories.contains("Design"))
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 1.0)
    }

}
