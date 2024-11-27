//
//  MainTabBarController.swift
//  LearnConnect
//
//  Created by Tural Babayev on 24.11.2024.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupViewControllers()
        customizeTabBarAppearance()
    }

    private func customizeTabBarAppearance() {
        let appearance = UITabBarAppearance()
        //appearance.backgroundColor = UIColor(named: "appSecondary_1")
        appearance.shadowColor = nil
        

        // Normal durumdaki ikon renkleri
        appearance.stackedLayoutAppearance.normal.iconColor = .gray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]

        // Seçili durumdaki ikon renkleri
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(named: "primaryBlue")
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(named: "primaryBlue")!]

        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    
}

