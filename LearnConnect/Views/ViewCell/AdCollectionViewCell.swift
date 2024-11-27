//
//  AdCollectionViewCell.swift
//  LearnConnect
//
//  Created by Tural Babayev on 25.11.2024.
//

import UIKit

class AdCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var adImageView: UIImageView!
    
    func configure(imageName: String) {
        adImageView.image = UIImage(named: imageName)
        adImageView.layer.cornerRadius = 12
        layer.cornerRadius = 12
    }
}
