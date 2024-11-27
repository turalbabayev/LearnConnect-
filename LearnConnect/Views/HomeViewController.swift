//
//  HomeViewController.swift
//  LearnConnect
//
//  Created by Tural Babayev on 23.11.2024.
//

import UIKit
import RxSwift

class HomeViewController: UIViewController {
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var adCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var popularCollectionView: UICollectionView!
    @IBOutlet weak var allCourseCollectionView: UICollectionView!
    @IBOutlet weak var allCourseTextBackgroundView: UIView!
    
    @IBOutlet weak var popularCourseTextBackgroundView: UIView!
    @IBOutlet weak var toggleDarkMode: UIButton!
    
    
    var categoryList = [String]()
    var courseList = [CourseModel]()
    var popularCourseList = [CourseModel]()
    var viewModel = HomeViewModel.shared
    var notificationViewModel = NotificationViewModel()
    var selectedIndex =  0
    var uiHelper = Helper()
    var bannerList = ["banner1","banner2"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        overrideUserInterfaceStyle = viewModel.loadSavedTheme()
        setupThemeListener()

    }
    
    deinit {
        removeThemeListener()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getCategories()
        bindViewModel()
        viewModel.getCourses()

    }
    
    @IBAction func notificationButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func filterButtonAction(_ sender: UIButton) {
        
    }
    
    
    @IBAction func toggleDarkMode(_ sender: UIButton) {
        // Tema değişimi ViewModel'e delegelendi
        let currentStyle = traitCollection.userInterfaceStyle
        viewModel.toggleTheme(currentStyle: currentStyle)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCourseDetail" {
            if let course = sender as? CourseModel {
                let destinationVC = segue.destination as! CourseDetailViewController
                destinationVC.course = course
            }
        }
    }
}

//MARK: - Private Functions
extension HomeViewController{
    private func setupUI(){
        profilePhotoImageView.layer.cornerRadius = profilePhotoImageView.frame.width / 2
        
        filterButton.layer.cornerRadius = 12
        allCourseTextBackgroundView.backgroundColor = .clear
        popularCourseTextBackgroundView.backgroundColor = .clear
        searchTextField.setupBorderStyle()
        searchTextField.setRightIconNonClickable(UIImage(systemName: "magnifyingglass")!)
        searchTextField.delegate = self
        overrideUserInterfaceStyle = viewModel.loadSavedTheme()
        notificationViewModel.requestNotificationAuthorization()

        // Set Delegates and Data Sources
        [adCollectionView, categoryCollectionView, popularCollectionView, allCourseCollectionView].enumerated().forEach { index, collectionView in
            collectionView?.delegate = self
            collectionView?.dataSource = self
            collectionView?.tag = index + 1
        }
        
    }
    
    private func bindViewModel(){
        _ = viewModel.categoryList.subscribe(onNext: { list in
            self.categoryList = list
            self.categoryCollectionView.reloadData()
            self.setupUI()
        })
        
        _ = viewModel.courseList.subscribe(onNext: { list in
            self.courseList = list
            self.allCourseCollectionView.reloadData()
            self.setupUI()
        })
        
        _ = viewModel.popularCourseList.subscribe(onNext: { list in
            self.popularCourseList = list
            self.popularCollectionView.reloadData()
            self.setupUI()
        })
        
        viewModel.fetchUserData { user in
            self.profileName.text = user.fullname
            if let profilePhotoBase64 = user.profilePhoto,
               let photoData = Data(base64Encoded: profilePhotoBase64),
               let profileImage = UIImage(data: photoData) {
                self.profilePhotoImageView.image = profileImage
            } else {
                self.profilePhotoImageView.image = UIImage(named: "defaultAvatar") // Varsayılan fotoğraf
            }
        }
        
    }
}

//MARK: - Collection View Extension
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 1: return bannerList.count
        case 2: return categoryList.count + 1
        case 3: return popularCourseList.count
        case 4: return courseList.count
        default: return 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "adCell", for: indexPath) as! AdCollectionViewCell
            cell.configure(imageName: bannerList[indexPath.row])
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
            let name = indexPath.row == 0 ? "Tümü" : categoryList[indexPath.row - 1]
            let isSelected = indexPath.row == selectedIndex
            cell.configure(name: name, isSelected: isSelected)
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "popularCourseCell", for: indexPath) as! PopulerCourseCollectionViewCell
            cell.configure(self.popularCourseList[indexPath.row])
            return cell
        case 4:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "allCourseCell", for: indexPath) as! allCourseCollectionViewCell
            cell.configure(self.courseList[indexPath.row])
            return cell
        default:
            fatalError("Unexpected collection view tag")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag {
        case 1:
            let screenWidth = UIScreen.main.bounds.width
            let itemWidth = (screenWidth-100)
            return CGSize(width: itemWidth, height: itemWidth)
        case 2:
            let label = UILabel()
            label.text = indexPath.row == 0 ? "Tümü" : categoryList[indexPath.row - 1]
            label.font = UIFont.systemFont(ofSize: 15)
            let labelSize = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 30))
            return CGSize(width: labelSize.width + 30, height: 30)
        case 3, 4:
            let width = popularCollectionView.frame.width / 2.4
            let height = popularCollectionView.frame.height
            return CGSize(width: width, height: height)
        default:
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView.tag == 1{
            return 5
        } else if collectionView.tag == 2{
            return 10
        } else if collectionView.tag == 3{
            return 10
        } else{
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.tag == 1{ // Ad
            return 0
        } else{ // Category Collection View
            return 10
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1{
            
        }else{
            selectedIndex = indexPath.row
            collectionView.reloadData() // Tüm collection view'i yeniden yükleyerek görünümü güncelle
        }
        
        switch collectionView.tag{
        case 1:print("tag 1 selected")
        case 2:
            selectedIndex = indexPath.row
            collectionView.reloadData()
            if selectedIndex == 0{
                viewModel.getCourses()
            }else{
                viewModel.getCourseByCategory(category: categoryList[indexPath.row - 1])
            }
        case 3:
            let course = popularCourseList[indexPath.row]
            performSegue(withIdentifier: "toCourseDetail", sender: course)
        case 4:
            let course = courseList[indexPath.row]
            performSegue(withIdentifier: "toCourseDetail", sender: course)
        default:
            print("Default Value")
        }
    }
    
    func setupThemeListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateTheme), name: HomeViewModel.themeDidChangeNotification, object: nil)
        }

    @objc func updateTheme(notification: Notification) {
        if let style = notification.userInfo?["style"] as? UIUserInterfaceStyle {
            overrideUserInterfaceStyle = style
            view.setNeedsLayout() // Görünümü yeniden çiz

            // Buton simgesini güncelle
            let buttonImage = style == .dark ? UIImage(systemName: "sun.max.fill") : UIImage(systemName: "moon.fill")
            toggleDarkMode.setImage(buttonImage, for: .normal)
        }
    }

    func removeThemeListener() {
        NotificationCenter.default.removeObserver(self, name: HomeViewModel.themeDidChangeNotification, object: nil)
    }
    
    
}

//MARK: - Extension TextField
extension HomeViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        viewModel.searchCourse(searchText: currentText)
        return true
    }
}
