//
//  FavoritesViewController.swift
//  LearnConnect
//
//  Created by Tural Babayev on 26.11.2024.
//

import UIKit
import RxSwift

class FavoritesViewController: UIViewController {
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var favoriteCoursesTableView: UITableView!
    var selectedIndex = 0
    
    var isFavCourseList = [CourseModel]()
    var favCourseCategory = [String]()
    var viewModel = FavoriteViewModel.shared
    let uiHelper = Helper()
    private var emptyStateView: EmptyStateView?


    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        setupUI()
        bindViewModel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getFavoriteCourses()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            if let course = sender as? CourseModel {
                let destinationVC = segue.destination as! CourseDetailViewController
                destinationVC.course = course
            }
        }
    }
    
    
}

//MARK: - Private Functions
extension FavoritesViewController{
    private func bindViewModel(){
        _ = viewModel.favCourseList.subscribe(onNext: { list in
            self.isFavCourseList = list
            self.favoriteCoursesTableView.reloadData()
            
            if list.isEmpty {
                self.showEmptyStateView()  // Liste boşsa "EmptyStateView" göster
            } else {
                self.hideEmptyState()  // Liste doluysa "EmptyStateView" gizle
            }
            
        })
        
        _ = viewModel.favCourseCategory.subscribe(onNext: { list in
            self.favCourseCategory = list
            self.categoryCollectionView.reloadData()
        })
    }
    
    private func setupUI(){
        favoriteCoursesTableView.backgroundColor = .clear
        favoriteCoursesTableView.separatorStyle = .none
    }
    
    private func setDelegates(){
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        favoriteCoursesTableView.delegate = self
        favoriteCoursesTableView.dataSource = self
    }
    
    private func showEmptyStateView() {
        if emptyStateView == nil {
        let emptyView = EmptyStateView(
            image: UIImage(named: "no_found") ?? UIImage(),
            message: "Henüz bir kursu favorilere almadınız.\nYeni kursları keşfetmeye başlayın!"
        )
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(emptyView)
        
        // Constraints
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: self.view.topAnchor),
            emptyView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            emptyView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        
        emptyStateView = emptyView
    }
    }

    private func hideEmptyState() {
        emptyStateView?.removeFromSuperview()
        emptyStateView = nil
    }
}

//MARK: - Collection View Extensions
extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favCourseCategory.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
        let name = indexPath.row == 0 ? "Tümü" : favCourseCategory[indexPath.row - 1]
        let isSelected = indexPath.row == selectedIndex
        cell.configure(name: name, isSelected: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.text = indexPath.row == 0 ? "Tümü" : favCourseCategory[indexPath.row - 1]
        label.font = UIFont.systemFont(ofSize: 15)
        let labelSize = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 30))
        return CGSize(width: labelSize.width + 30, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        collectionView.reloadData()
    }
}

//MARK: - TableView Extensions
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFavCourseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let course = isFavCourseList[indexPath.row]
        let courseCell = favoriteCoursesTableView.dequeueReusableCell(withIdentifier: "FavoriteCoursesCell") as! FavoriteCoursesTableViewCell
        courseCell.configure(course)
        uiHelper.addShadowToView(view: courseCell.backgroundViewCell)
        
        return courseCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let course = isFavCourseList[indexPath.row]
        self.performSegue(withIdentifier: "toDetail", sender: course)
    }
    
    
}
