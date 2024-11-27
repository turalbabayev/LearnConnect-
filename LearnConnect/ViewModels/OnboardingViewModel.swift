//
//  OnboardingViewModel.swift
//  LearnConnect
//
//  Created by Tural Babayev on 23.11.2024.
//

import UIKit

class OnboardingViewModel{
    private let items:[OnboardingModel]
    var currentPage: Int = 0
    
    init(items: [OnboardingModel]) {
        self.items = items
        copyDatabase()
    }
    
    func numberOfItems()->Int{
        return items.count
    }
    
    func item(at index: Int) ->OnboardingModel{
        return items[index]
    }
    
    func isLastPage() -> Bool{
        return currentPage == items.count - 1
    }
    
    func copyDatabase(){
        let bundleYolu = Bundle.main.path(forResource: "learnConnect", ofType: ".db")
        let hedefYol = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let kopyalanacakYer = URL(fileURLWithPath: hedefYol).appendingPathComponent("learnConnect.db")
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: kopyalanacakYer.path){
            print("Veritabanı zaten var")
        }else{
            do{
                try fileManager.copyItem(atPath: bundleYolu!, toPath: kopyalanacakYer.path)
            }catch{}
        }
    }
}
