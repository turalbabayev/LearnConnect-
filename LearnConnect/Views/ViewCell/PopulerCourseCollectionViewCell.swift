//
//  PopulerCourseCollectionViewCell.swift
//  LearnConnect
//
//  Created by Tural Babayev on 25.11.2024.
//

import UIKit

class PopulerCourseCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var courseImage: UIImageView!
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var courseEndrolledCount: UILabel!
    @IBOutlet weak var backgroundViewCell: UIView!
    @IBOutlet weak var backgroundSub: UIView!
    var uiHelper = Helper()
    
    func configure(_ course: CourseModel) {
        self.courseName.text = course.title
        courseEndrolledCount.text = String(course.enrolledCount)
        courseImage.image = UIImage(named: course.thumbnailURL ?? "kurs")
        courseImage.layer.cornerRadius = 8
        backgroundSub.backgroundColor = .clear
        backgroundViewCell.layer.cornerRadius = 8
        uiHelper.addShadowToView(view: backgroundViewCell)
        //layer.cornerRadius = 8
        //layer.borderWidth = 0.2
        //layer.borderColor = UIColor.lightGray.cgColor
        
    }
}
