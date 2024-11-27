//
//  MyCoursesViewController.swift
//  LearnConnect
//
//  Created by Tural Babayev on 27.11.2024.
//

import UIKit

class MyCoursesViewController: UIViewController {

    @IBOutlet weak var MyCoursesTableView: UITableView!
    
    var viewModel = MyCoursesViewModel.shared
    let uiHelper = Helper()
    var enrolledCourses: [(course: CourseModel, progress: Double)] = []
    private var emptyStateView: EmptyStateView?


    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        setupUI()
        bindViewModel()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getEnrolledCoursesWithProgress()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailFromMyCourses" {
            if let course = sender as? CourseModel {
                let destinationVC = segue.destination as! CourseDetailViewController
                destinationVC.course = course
            }
        }
    }
    

}
//MARK: - Private Functions
extension MyCoursesViewController{
    private func bindViewModel(){
        _ = viewModel.enrolledCourses.subscribe(onNext: { list in
            self.enrolledCourses = list
            self.MyCoursesTableView.reloadData()
            
            if list.isEmpty {
                self.showEmptyStateView()  // Liste boşsa "EmptyStateView" göster
            } else {
                self.hideEmptyState()  // Liste doluysa "EmptyStateView" gizle
            }
        })
        
    }
    
    private func setupUI(){
        MyCoursesTableView.backgroundColor = .clear
        MyCoursesTableView.separatorStyle = .none
    }
    
    private func setDelegates(){
        MyCoursesTableView.delegate = self
        MyCoursesTableView.dataSource = self
    }
    
    private func showEmptyStateView() {
        if emptyStateView == nil {
        let emptyView = EmptyStateView(
            image: UIImage(named: "no_found") ?? UIImage(),
            message: "Henüz bir kursa kayıt olmadınız.\nYeni kursları keşfetmeye başlayın!"
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

//MARK: - TableView Extensions
extension MyCoursesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return enrolledCourses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let courseWithProgress = enrolledCourses[indexPath.row]
        let course = courseWithProgress.course
        //Daha sonra kullanılacak
        let _ = courseWithProgress.progress
        let myCourseCell = MyCoursesTableView.dequeueReusableCell(withIdentifier: "myCoursesCell") as! MyCoursesTableViewCell
        myCourseCell.configure(course)
        uiHelper.addShadowToView(view: myCourseCell.backgroundViewCell)
        
        return myCourseCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let courseWithProgress = enrolledCourses[indexPath.row]
        let course = courseWithProgress.course
        self.performSegue(withIdentifier: "toDetailFromMyCourses", sender: course)
    }
    
    
}
