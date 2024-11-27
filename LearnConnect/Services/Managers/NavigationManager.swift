//
//  NavigationManager.swift
//  LearnConnect
//
//  Created by Tural Babayev on 23.11.2024.
//

import UIKit

enum AppScreen {
    case login
    case forgotPassword
    case onboarding
    case register
    case home
    case mainNavigation
    
    var storyboardID: String {
        switch self {
        case .login:
            return "LoginVC"
        case .forgotPassword:
            return "ForgotPasswordVC"
        case .onboarding:
            return "OnboardingVC"
        case .register:
            return "RegisterVC"
        case .home:
            return "HomeVC"
        case .mainNavigation:
            return "homeNavigationController"
        }
        
    
    }
}

class NavigationManager{
    static let shared = NavigationManager()
    
    private init() {}
    
    func setRootViewController(for window: UIWindow?){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if UserDefaults.standard.hasSeenOnboarding{
            
            if UserDefaults.standard.isLoggedIn{
                let homeNavigationController = storyboard.instantiateViewController(withIdentifier: "homeNavigationController") as! UINavigationController
                homeNavigationController.isNavigationBarHidden = true
                window?.rootViewController = homeNavigationController
                
            } else{
                // Kullanıcı onboarding ekranını gördüyse, Login ekranını root yap
                let loginVC = storyboard.instantiateViewController(identifier: "LoginVC")
                let navigationController = UINavigationController(rootViewController: loginVC)
                navigationController.isNavigationBarHidden = true
                window?.rootViewController = navigationController
            }
            
        } else{
            let onboardingVC = storyboard.instantiateViewController(identifier: "OnboardingVC")
            let navigationController = UINavigationController(rootViewController: onboardingVC)
            navigationController.isNavigationBarHidden = true
            window?.rootViewController = navigationController
        }
        window?.makeKeyAndVisible()
    }
    
    func navigate(to screen: AppScreen, from viewController: UIViewController, parameters: ((UIViewController) -> Void)? = nil) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(identifier: screen.storyboardID)
        
            if screen == .mainNavigation {
                let homeNavigationController = storyboard.instantiateViewController(withIdentifier: "homeNavigationController") as! UINavigationController
                viewController.view.window?.rootViewController = homeNavigationController
                return
            }
            
            // Parametreleri aktarma
            parameters?(destinationVC)
            
            // Geçişi gerçekleştirme
            viewController.navigationController?.pushViewController(destinationVC, animated: true)
        }
    
    
    
    
     
}
