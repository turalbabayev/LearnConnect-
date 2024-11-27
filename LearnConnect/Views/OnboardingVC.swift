//
//  ViewController.swift
//  LearnConnect
//
//  Created by Tural Babayev on 22.11.2024.
//

import UIKit

class OnboardingVC: UIViewController {

    //IBOutlets
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //ViewModel
    private var viewModel: OnboardingViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ViewModel'in Başlatılması
        let items = [
                    OnboardingModel(image: UIImage(named: "onboarding1")!, title: "Yeni bir şey öğrenmek ister misin?", subTitle: "Öğrenme stilinize uygun bir ders programını LearnConnect'te deneyebilirsiniz. Hemen kaydolun!"),
                    OnboardingModel(image: UIImage(named: "onboarding2")!, title: "Ücretsiz öğrenme materyalleri", subTitle: "Binlerce bölümden oluşan okuma materyalinden 567 dakikalık video materyaline kadar, en son dijital konuların keyfini ücretsiz çıkarabilirsiniz."),
                    OnboardingModel(image: UIImage(named: "onboarding3")!, title: "Başarıya Ulaşın", subTitle: "Hedeflerinize ulaşmanız için yanınızdayız.")
        ]
        
        viewModel = OnboardingViewModel(items: items)
        
        //Setup
        collectionView.dataSource = self
        collectionView.delegate = self
        
        pageControl.numberOfPages = viewModel.numberOfItems()
        updateButtons()

        // Button Styling
        signupButton.layer.cornerRadius = 12
        loginButton.layer.cornerRadius = 12
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor(named: "primaryBlue")?.cgColor
    }
    
    // Butonları Güncelle
    private func updateButtons() {
        let isLastPage = viewModel.isLastPage()
        skipButton.isHidden = isLastPage
        signupButton.isHidden = !isLastPage
        loginButton.isHidden = !isLastPage
    }
    
    // Geçerli sayfaya kaydırma
    private func scrollToPage(_ page: Int) {
        let indexPath = IndexPath(item: page, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        viewModel.currentPage = page
        pageControl.currentPage = page
        updateButtons()
    }
    
    //IBActions
    @IBAction func skipButtonAction(_ sender: UIButton) {
        scrollToPage(viewModel.numberOfItems() - 1)
    }
    
    @IBAction func signupButtonAction(_ sender: UIButton) {
        NavigationManager.shared.navigate(to: .register, from: self)
    }
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        UserDefaults.standard.hasSeenOnboarding = true
        NavigationManager.shared.navigate(to: .login, from: self)
    }
    
    @IBAction func pageControlChanged(_ sender: UIPageControl) {
        scrollToPage(sender.currentPage)
    }
    
    
}


//MARK: - UICollectionView Delegate & DataSource
extension OnboardingVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCell", for: indexPath) as! OnboardingCollectionViewCell
        let item = viewModel.item(at: indexPath.row)
        cell.imageView.image = item.image
        cell.headingLabel.text = item.title
        cell.subHeadingLabel.text = item.subTitle
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let currentPage = Int(scrollView.contentOffset.x / pageWidth)
        pageControl.currentPage = currentPage
        viewModel.currentPage = currentPage
        updateButtons()
    }
}



