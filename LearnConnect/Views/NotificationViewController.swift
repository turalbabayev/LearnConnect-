//
//  NotificationViewController.swift
//  LearnConnect
//
//  Created by Tural Babayev on 27.11.2024.
//

import UIKit

class NotificationViewController: UIViewController {
    @IBOutlet weak var notificationTableView: UITableView!
    
    private var viewModel = NotificationViewModel()


    override func viewDidLoad() {
        super.viewDidLoad()
        notificationTableView.delegate = self
        notificationTableView.dataSource = self
        
        
        // Bildirimler güncellendiğinde tableView'i yenile
        viewModel.onNotificationsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.notificationTableView.reloadData()
            }
        }

        // Bildirim izinlerini iste
        viewModel.requestNotificationAuthorization()
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    


}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNotifications().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notiticationCell", for: indexPath) as! NotificationTableViewCell
        let notification = viewModel.getNotifications()[indexPath.row]
        cell.notificationTitle?.text = notification.message
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR") // Türkçe dil ayarı
        formatter.dateFormat = "dd MMM yyyy, HH:mm" // Örneğin: 27 Kas 2024, 15:30
        cell.notificationDate?.text = formatter.string(from: notification.date)
        return cell
    }
    
    
}
