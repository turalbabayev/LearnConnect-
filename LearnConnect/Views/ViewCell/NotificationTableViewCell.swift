//
//  NotificationTableViewCell.swift
//  LearnConnect
//
//  Created by Tural Babayev on 27.11.2024.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    @IBOutlet weak var backgroundViewCell: UIView!
    @IBOutlet weak var notificationTitle: UILabel!
    @IBOutlet weak var notificationDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
