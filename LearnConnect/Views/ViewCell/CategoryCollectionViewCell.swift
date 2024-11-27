//
//  CategoryCollectionViewCell.swift
//  LearnConnect
//
//  Created by Tural Babayev on 25.11.2024.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var backgroundViewItem: UIView!
    @IBOutlet weak var categoryName: UILabel!
    var uiHelper = Helper()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Arka planın yuvarlanmasını sağlamak
        backgroundViewItem.layer.cornerRadius = 10
        uiHelper.addShadowToView(view: backgroundViewItem)
        backgroundView?.backgroundColor = .clear
    }
    
    func configure(name: String, isSelected: Bool) {
        categoryName.text = name
        backgroundViewItem.backgroundColor = isSelected ? UIColor(named: "primaryBlue") : .white
        categoryName.textColor = isSelected ? .white : .black
        categoryName.font = .systemFont(ofSize: 15, weight: isSelected ? .semibold : .light)
    }
    
    
}
