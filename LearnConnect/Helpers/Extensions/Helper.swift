//
//  UIView+Extensions.swift
//  LearnConnect
//
//  Created by Tural Babayev on 23.11.2024.
//

import UIKit

class Helper{
    func addShadowToView(view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor  // Gölgenin rengi
        view.layer.shadowOpacity = 0.1  // Gölgenin opaklığı (0 ile 1 arasında)
        view.layer.shadowOffset = CGSize(width: 0, height: 0)  // Gölgenin ofseti (yatay ve dikey kayma)
        view.layer.shadowRadius = 3  // Gölgenin yayılma mesafesi
        view.layer.masksToBounds = false  // Gölgenin görünmesi için gerekli
    }
}
