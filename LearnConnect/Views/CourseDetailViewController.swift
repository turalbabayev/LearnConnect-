//
//  CourseDetailViewController.swift
//  LearnConnect
//
//  Created by Tural Babayev on 26.11.2024.
//

import UIKit
import AVKit

class CourseDetailViewController: UIViewController {
    @IBOutlet weak var courseImage: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var courseRating: UILabel!
    @IBOutlet weak var courseEndrolledCount: UILabel!
    @IBOutlet weak var userProgress: UILabel!
    @IBOutlet weak var userProgressView: UIView!
    
    @IBOutlet weak var favButton: UIImageView!
    @IBOutlet weak var courseDescription: UILabel!
    @IBOutlet weak var instructorName: UILabel!
    
    @IBOutlet weak var instructorTitle: UILabel!
    @IBOutlet weak var instructorProfilePhoto: UIImageView!
    @IBOutlet weak var instructorView: UIView!
    @IBOutlet weak var enrollView: UIView!
    @IBOutlet weak var enrollDescription: UILabel!
    @IBOutlet weak var enrollCourseButton: UIButton!
    @IBOutlet weak var downloadVideoButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    
    var course: CourseModel?
    var userId =  UserDefaults.standard.string(forKey: "userId") ?? ""
    var internalCourseId: Int = 0
    private var isFavorited: Bool = false
    var uiHelper = Helper()

    let viewModel = CourseDetailViewModel()
    let notificationViewModel = NotificationViewModel()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchFavoriteStatus()
        updateDownloadButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
        fetchFavoriteStatus()
        updateDownloadButton()
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func playButtonAction(_ sender: UIButton) {
        playCourseAction()
    }
    
    @IBAction func enrollCourseButtonAction(_ sender: UIButton) {
        guard let course = course else { return }
        
        if enrollCourseButton.title(for: .normal) == "Kayıt Ol" {
            print(course.enrolledCount)
            
            viewModel.enrollUser(userId: userId, courseId: course.id, enrollled_count: course.enrolledCount)
                notificationViewModel.scheduleNotification(
                    title: "Kursa Kaydoldunuz",
                    message: "\(course.title) kursuna başarıyla kayıt oldunuz."
                )
                let alert = CustomAlertView(
                title: "Başarılı!",
                message: "Kursa başarıyla kayıt oldunuz.",
                buttonTitle: "Tamam",
                buttonAction: {
                }
            )
            alert.show(on: self)
            self.setupUI()
        } else{
            playCourseAction() // Ortak işlevi çağır
        }
    }
    
    @IBAction func downloadVideoButtonAction(_ sender: Any) {
        guard let course = course else { return }

        // Progress bar ve label görünür hale getiriliyor
        progressBar.isHidden = false
        progressBar.progress = 0.0

        viewModel.downloadVideo(
            course: course,
            progressHandler: { [weak self] progress in
                DispatchQueue.main.async {
                    self?.progressBar.progress = progress
                }
            },
            completion: { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        let alert = CustomAlertView(
                            title: "Başarılı!",
                            message: "Video başarıyla inidirildi. İnternet bağlantısına ihtiyaç duymadan offline olarak izleyebilirsiniz..",
                            buttonTitle: "Tamam",
                            buttonAction: {
                                self?.updateDownloadButton()
                            }
                        )
                        alert.show(on: self!)
                      
                    case .failure(_):
                        let alert = CustomAlertView(
                            title: "Hata!",
                            message: "Bu video daha önce indirildi. İnternet bağlantısına ihtiyaç duymadan offline olarak izleyebilirsiniz..",
                            buttonTitle: "Tamam",
                            buttonAction: {
                                self?.updateDownloadButton()
                            }
                        )
                        alert.show(on: self!)
                    }

                    // İndirme tamamlandığında progress bar gizlenir
                    self?.progressBar.isHidden = true
                }
            }
        )
    }
    
    
}

//MARK: - Private Functions
extension CourseDetailViewController{
    func setupUI(){
        guard let course = course else { return }
        
        courseImage.image = UIImage(named: course.thumbnailURL ?? "kurs")
        courseTitle.text = course.title
        courseDescription.text = course.description
        courseRating.text = String(course.rating)
        courseEndrolledCount.text = String(course.enrolledCount)
        internalCourseId = course.id
        courseImage.layer.cornerRadius = 8
        userProgressView.layer.cornerRadius = userProgressView.frame.width/2
        instructorProfilePhoto.layer.cornerRadius = instructorProfilePhoto.frame.width/2
        enrollCourseButton.layer.cornerRadius = 8
        instructorView.layer.cornerRadius = 8
        instructorView.layer.borderColor = UIColor.gray.withAlphaComponent(0.2).cgColor
        instructorView.layer.borderWidth = 1
        
        favButton.isUserInteractionEnabled = true // Gesture tanımlanması için gerekli
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(favoriteTapped))
        favButton.addGestureRecognizer(tapGesture)
        
        // Kullanıcı kayıtlıysa ve ilerleme varsa
        if viewModel.isUserEnrolled(userId: userId, courseId: course.id) {
            //let progress = viewModel.getProgress(userId: userId, courseId: course.id)
            enrollCourseButton.setTitle("Devam Et", for: .normal)
            enrollDescription.text = "Eğitiminize kaldığınız yerden devam etmek için aşağıdaki butonu kullanabilirsiniz."
            playButton.isHidden = false
            
            //userProgress.text = String(format: "%%%d", (progress / 1) * 100) // Varsayılan 1 kullanılır, çünkü dinamik olarak ayarlanacak
            //self.userProgress.text = String(format: "%%%d", (progress / totalDuration) * 100)
        } else {
            enrollCourseButton.setTitle("Kayıt Ol", for: .normal)
            enrollDescription.text = "Kursa kayit olmak için aşağıdaki butonu kullanabilirsiniz."
            playButton.isHidden = true
            userProgress.text = "%0"
        }
        
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    private func fetchFavoriteStatus() {
        guard let course = course else { return }

        let isFavorited = viewModel.fetchFavoriteStatus(userId: userId, courseId: course.id)
            self.isFavorited = isFavorited
            self.updateFavoriteImage()
    }

    @objc private func favoriteTapped() {
        guard let course = course else { return }

        viewModel.toggleFavoriteStatus(userId: userId, courseId: course.id, currentStatus: isFavorited)
        self.isFavorited = !isFavorited
        self.updateFavoriteImage()
        
        // Favori durumuna göre mesaj
        let alertMessage = isFavorited ? "Bu kurs favorilere eklendi." : "Bu kurs favorilerden çıkarıldı."
        showFavoriteAlert(message: alertMessage)
    }
    
    private func updateFavoriteImage() {
        let imageName = isFavorited ? "bookmark.fill" : "bookmark"
        favButton.image = UIImage(systemName: imageName)
    }
    
    private func updateDownloadButton() {
        guard let course = course else { return }

        let isDownloaded = viewModel.isVideoDownloaded(course: course)
        if isDownloaded {
            downloadVideoButton.setTitle("İndirildi", for: .normal)
            downloadVideoButton.isEnabled = false
        } else {
            downloadVideoButton.setTitle("İndir", for: .normal)
            downloadVideoButton.isEnabled = true
        }
    }
    
    private func playCourseAction() {
        guard let course = course else { return }

        if viewModel.isVideoDownloaded(course: course) {
            // Offline oynat
            viewModel.playOfflineVideo(course: course) { [weak self] playerViewController,arg in
                self?.present(playerViewController, animated: true) {
                    playerViewController.player?.play()
                }
            }
        } else {
            // Online oynat
            Task { @MainActor in
                let progress = viewModel.getProgress(userId: userId, courseId: course.id)

                await viewModel.playVideo(course: course, progress: progress) { playerViewController, totalDuration in
                    self.present(playerViewController, animated: true) {
                        playerViewController.player?.play()
                    }
                    self.userProgress.text = String(format: "%%%d", (progress / totalDuration) * 100)
                }
            }
        }
    }
    
    private func showFavoriteAlert(message: String) {
        let alert = CustomAlertView(
            title: "Favori Durumu",
            message: message,
            buttonTitle: "Tamam",
            buttonAction: {
                print("Favori durumu bildirimi kapatıldı.")
            }
        )
        alert.show(on: self)
    }
}
