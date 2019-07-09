//
//  NotificheDataSource.swift
//  MGS
//
//  Created by Dani Tox on 07/07/2019.
//  Copyright © 2019 Dani Tox. All rights reserved.
//

import UIKit
import UserNotifications

class NotificheDataSource: NSObject, UITableViewDataSource {
    
    var controller: UIViewController?
    var tableView: UITableView!
    var notifiche = Notifiche.NotificheType.allCases
    var areNotificheActive : Bool = Notifiche.areNotificheActive {
        didSet {
            Notifiche.areNotificheActive = areNotificheActive
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return notifiche.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0: return makeSwitchCell(in: tableView)
        case 1:
            let notifica = self.notifiche[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "boldCell") as! BoldCell

            cell.mainLabel.text = notifiche[indexPath.row].stringValue
            cell.mainLabel.textColor = areNotificheActive ? Theme.current.textColor : .gray
            
            cell.accessoryType = Notifiche.activeNotifiche.contains(notifica) ? .checkmark : .none
            
            return cell
        default: fatalError()
        }
        
    }
    
    func makeSwitchCell(in tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell") as! SwitchCell
        cell.mainLabel.text = "Attiva le notifiche"
        cell.accessoryType = .none
        cell.cellSwitch.isOn = self.areNotificheActive
        cell.cellSwitch.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        return cell
    }
    
    @objc private func switchChanged(_ sender: UISwitch) {
        self.areNotificheActive = sender.isOn
        
        if sender.isOn {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                switch settings.authorizationStatus {
                case .authorized, .provisional: Notifiche.subscribeToActiveNotifications()
                case .denied: self.showNotifSettingsAlert()
                case .notDetermined: Notifiche.requestAuthorization()
                @unknown default: break
                }
            }
        } else {
            Notifiche.unsubscribeToAllNotifications()
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return nil
        case 1: return "Seleziona le categorie"
        default: return nil
        }
    }
    
    private func showNotifSettingsAlert() {
        let alert = UIAlertController(title: "Attenzione", message: "In passato non hai dato l'autorizzazione ad iGio di mandarti le notifiche. Per questo motivo, devi riattivarl dalle impostazioni del telefono.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Apri Impostazioni", style: .default, handler: { (_) in
            Notifiche.openSettings()
        }))
        alert.addAction(UIAlertAction(title: "Annulla", style: .cancel, handler: nil))
        self.controller?.present(alert, animated: true)
    }
    
}
