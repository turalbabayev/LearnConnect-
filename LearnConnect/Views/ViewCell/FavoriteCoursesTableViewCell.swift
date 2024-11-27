//
//  FavoriteCoursesTableViewCell.swift
//  LearnConnect
//
//  Created by Tural Babayev on 26.11.2024.
//

import UIKit

class FavoriteCoursesTableViewCell: UITableViewCell {
    @IBOutlet weak var backgroundViewCell: UIView!
    @IBOutlet weak var courseImage: UIImageView!
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var courseRating: UILabel!
    @IBOutlet weak var courseEnrolledCount: UILabel!
    @IBOutlet weak var toDetailButton: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        backgroundColor = .clear
        
    }
    
    func configure(_ course: CourseModel) {
        courseTitle.text = course.title
        courseEnrolledCount.text = String(course.enrolledCount)
        courseImage.image = UIImage(named: course.thumbnailURL ?? "kurs")
        courseImage.layer.cornerRadius = 8
        courseRating.text = String(course.rating)
        courseEnrolledCount.text = String(course.enrolledCount)
        backgroundViewCell.layer.cornerRadius = 8
        layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func toDetailButton(_ sender: UIButton) {
    }
    

}
