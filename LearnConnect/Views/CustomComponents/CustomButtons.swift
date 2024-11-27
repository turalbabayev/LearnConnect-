//
//  CustomButtons.swift
//  LearnConnect
//
//  Created by Tural Babayev on 23.11.2024.
//

import UIKit

extension UIButton{
    func addBorderWithShadow(
        borderWidth: CGFloat = 2.0,
        borderColor: UIColor = .black,
        shadowColor: UIColor = .black,
        shadowOpacity: Float = 0.5,
        shadowOffset: CGSize = CGSize(width: 3, height: 3),
        shadowRadius: CGFloat = 5
    ) {
        // Kenarlık ekle
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        
        // Gölge ekle
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        self.layer.masksToBounds = false // Gölgenin görünmesi için
    }
}
