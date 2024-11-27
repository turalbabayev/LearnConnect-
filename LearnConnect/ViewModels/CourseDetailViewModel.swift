//
//  CourseDetailViewModel.swift
//  LearnConnect
//
//  Created by Tural Babayev on 26.11.2024.
//

import Foundation
import AVKit

class CourseDetailViewModel:NSObject, URLSessionDownloadDelegate{
    private let userCourseManager = UserCourseManager.shared
    private var downloadCompletionHandler: ((Result<URL, Error>) -> Void)?
    private var progressHandler: ((Float) -> Void)?
    
    func isUserEnrolled(userId: String, courseId: Int) -> Bool {
        return userCourseManager.isUserEnrolledInCourse(userId: userId, courseId: courseId)
    }

    func enrollUser(userId: String, courseId: Int,enrollled_count: Int) {
        var count = enrollled_count
        count += 1
        userCourseManager.enrollUserInCourse(userId: userId, courseId: courseId, enrollled_count: count)
    }

    func saveProgress(userId: String, courseId: Int, progressInSeconds: Double) {
        userCourseManager.saveProgress(userId: userId, courseId: courseId, progressInSeconds: progressInSeconds)
    }

    func getProgress(userId: String, courseId: Int) -> Double {
        return userCourseManager.getProgress(userId: userId, courseId: courseId)
    }
    
    func getEnrolledCount(courseId: Int)->Int{
        return CourseManager.shared.getEnrolledCount(courseId: courseId)
    }

    func playVideo(course: CourseModel, progress: Double, onPlayerReady: @escaping (AVPlayerViewController, Double) -> Void) async {
        guard let videoURL = URL(string: course.videoURL) else {
            print("Invalid video URL")
            return
        }

        let player = AVPlayer(url: videoURL)

        if progress > 0 {
            let time = CMTime(seconds: progress, preferredTimescale: 1)
            await player.seek(to: time)
        }

        // Videonun toplam süresini hesapla
        let totalDurationInSeconds = await getVideoDuration(from: videoURL)

        DispatchQueue.main.async {
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player

            self.addProgressObserver(to: player, forCourse: course, totalDuration: totalDurationInSeconds)
            onPlayerReady(playerViewController, totalDurationInSeconds)
        }
    }

    private func addProgressObserver(to player: AVPlayer, forCourse course: CourseModel, totalDuration: Double) {
        player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 5, preferredTimescale: 1), queue: .main) { [weak self] currentTime in
            guard let self = self else { return }
            let progressInSeconds = CMTimeGetSeconds(currentTime)
            let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
            // İlerlemenin yüzdesini dinamik olarak hesapla
            //let progressPercentage = (progressInSeconds / totalDuration) * 100
            self.saveProgress(userId: userId, courseId: course.id, progressInSeconds: progressInSeconds)
        }
    }

    func getVideoDuration(from url: URL) async -> Double {
        let asset = AVAsset(url: url)

        do {
            let duration = try await asset.load(.duration)
            let durationInSeconds = CMTimeGetSeconds(duration)
            return durationInSeconds
        } catch {
            print("Error loading video duration: \(error.localizedDescription)")
            return 0 // Hata durumunda varsayılan değer
        }
    }
    
    func fetchFavoriteStatus(userId: String, courseId: Int)->Bool {
        let isFavorited = userCourseManager.getFavoriteStatus(userId: userId, courseId: courseId)
        return isFavorited
    }
    
    func toggleFavoriteStatus(userId: String, courseId: Int, currentStatus: Bool) {
        let newStatus = !currentStatus
        userCourseManager.updateFavoriteStatus(userId: userId, courseId: courseId, isFavorited: newStatus)
    }
    
    // Videoyu indir
    func downloadVideo(course: CourseModel, progressHandler: @escaping (Float) -> Void,completion: @escaping (Result<URL, Error>) -> Void) {
        guard let videoURL = URL(string: course.videoURL) else {
               completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
               return
           }

           let fileManager = FileManager.default
           let destinationURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(course.id).mp4")

           if fileManager.fileExists(atPath: destinationURL.path) {
               completion(.success(destinationURL))
               return
           }

           // URLSession için bir yapılandırma ve delegate
           let configuration = URLSessionConfiguration.default
           let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)

           self.downloadCompletionHandler = completion
           self.progressHandler = progressHandler

           let task = session.downloadTask(with: videoURL)
           task.resume()
    }
    
    // Delegate: İndirme İlerlemesi
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        progressHandler?(progress)
    }

    // Delegate: İndirme Tamamlandığında
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let fileManager = FileManager.default
        let destinationURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(downloadTask.originalRequest?.url?.lastPathComponent ?? "video").mp4")

        do {
            try fileManager.moveItem(at: location, to: destinationURL)
            downloadCompletionHandler?(.success(destinationURL))
        } catch {
            downloadCompletionHandler?(.failure(error))
        }
    }

    // Delegate: Hata Durumu
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            downloadCompletionHandler?(.failure(error))
        }
    }

    // Video indirildi mi kontrol et
    func isVideoDownloaded(course: CourseModel) -> Bool {
        let fileManager = FileManager.default
        let filePath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(course.id).mp4")
        return fileManager.fileExists(atPath: filePath.path)
    }

    func playOfflineVideo(course: CourseModel, onPlayerReady: @escaping (AVPlayerViewController, Double) -> Void) {
        let fileManager = FileManager.default
        let filePath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(course.id).mp4")

        guard fileManager.fileExists(atPath: filePath.path) else {
            print("Video not downloaded")
            return
        }

        let player = AVPlayer(url: filePath)

        // Kaydedilen ilerlemeyi kontrol et
        let progressInSeconds = getProgress(userId: UserDefaults.standard.string(forKey: "userId") ?? "", courseId: course.id)
        if progressInSeconds > 0 {
            let startTime = CMTime(seconds: progressInSeconds, preferredTimescale: 1)
            player.seek(to: startTime)
        }

        // Videonun toplam süresini hesapla
        let videoURL = URL(fileURLWithPath: filePath.path)
        Task {
            let totalDurationInSeconds = await getVideoDuration(from: videoURL)

            DispatchQueue.main.async {
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player

                self.addProgressObserver(to: player, forCourse: course, totalDuration: totalDurationInSeconds)
                onPlayerReady(playerViewController, totalDurationInSeconds)
            }
        }
    }

    
}
