//
//  SettingsVC.swift
//  SFA
//
//  Created by Dani Tox on 04/01/19.
//  Copyright © 2019 Dani Tox. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController, HasCustomView {
    typealias CustomView = SettingsView
    override func loadView() {
        super.loadView()
        view = CustomView()
    }
    
    var themeObserver : NSObjectProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        themeObserver = NotificationCenter.default.addObserver(forName: .updateTheme, object: nil, queue: .main, using: { (notification) in
            UIView.animate(withDuration: 0.3, animations: { self.updateTheme() })
        })
        rootView.tableView.register(SettingsUserCell.self, forCellReuseIdentifier: "UserCell")
        rootView.tableView.register(BasicCell.self, forCellReuseIdentifier: "cell")
        rootView.tableView.register(BoldCell.self, forCellReuseIdentifier: "boldCell")
        rootView.tableView.register(SwitchCell.self, forCellReuseIdentifier: "switchCell")
        rootView.tableView.delegate = self
        rootView.tableView.dataSource = self
    
        if #available(iOS 14, *) {
            rootView.tableView.register(GenderCell.self, forCellReuseIdentifier: "genderCell")
            rootView.tableView.register(AgeCell.self, forCellReuseIdentifier: "ageCell")
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(themeObserver as Any)
    }
    
    private func updateTheme() {
        rootView.tableView.backgroundColor = Theme.current.tableViewBackground
        rootView.tableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rootView.tableView.reloadData()
    }
    
    @objc private func themeSwitchChanged(_ sender: UISwitch) {
        Theme.current = (sender.isOn) ? DarkTheme() : LightTheme()
    }
}

extension SettingsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let headers = ["Utente", "Generale"]
        return headers[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            #if DEBUG
            if #available(iOS 13, *) {
                return 4
            } else {
                return 5
            }
            #else
            if #available(iOS 13, *) {
                return 3
            } else {
                return 4
            }
            #endif
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0, 1:
            return 100
        default:
            fatalError()
        }
    }
    
    @available(iOS 14, *)
    fileprivate func makeAgeCellWithMenu(in tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ageCell") as! AgeCell
        cell.mainLabel.text = "Età"
        return cell
    }
    
    @available(iOS 14, *)
    fileprivate func makeGenderCellWithMenu(in tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "genderCell") as! GenderCell
        cell.mainLabel.text = "Maschio/Femmina"
        return cell
    }
    
    fileprivate func makeDisclosureCell(with text: String, in tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "boldCell") as! BoldCell
        cell.mainLabel.text = text
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    fileprivate func makeThemeSwitchCell(_ tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell") as! SwitchCell
        cell.cellSwitch.isOn = (Theme.current is DarkTheme) ? true : false
        cell.cellSwitch.addTarget(self, action: #selector(themeSwitchChanged(_:)), for: .valueChanged)
        cell.mainLabel.text = "Tema scuro"
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
//        case 0:
//            return makeDisclosureCell(with: "Backup (ancora in sviluppo)", in: tableView)
        case 0:
            switch indexPath.row {
            case 0:
                if #available(iOS 14, *) { return makeAgeCellWithMenu(in: tableView)}
                return makeDisclosureCell(with: "Età", in: tableView)
            case 1:
                if #available(iOS 14, *) { return makeGenderCellWithMenu(in: tableView)}
                return makeDisclosureCell(with: "Maschio/Femmina", in: tableView)
            case 2: return makeDisclosureCell(with: "Provincia & Città", in: tableView)
            default: fatalError()
            }
        case 1:
            #if DEBUG
            if #available(iOS 13, *) {
                switch indexPath.row {
                case 0: return makeDisclosureCell(with: "Info", in: tableView)
                case 1: return makeDisclosureCell(with: "Notifiche", in: tableView)
                case 2: return makeDisclosureCell(with: "Licenze", in: tableView)
                case 3: return makeDisclosureCell(with: "Debug", in: tableView)
                default: fatalError()
                }
            } else {
                switch indexPath.row {
                case 0: return makeDisclosureCell(with: "Info", in: tableView)
                case 1: return makeDisclosureCell(with: "Notifiche", in: tableView)
                case 2: return makeDisclosureCell(with: "Tema colori", in: tableView)
                case 3: return makeDisclosureCell(with: "Licenze", in: tableView)
                case 4: return makeDisclosureCell(with: "Debug", in: tableView)
                default: fatalError()
                }
            }
            #else
            if #available(iOS 13, *) {
                switch indexPath.row {
                case 0: return makeDisclosureCell(with: "Info", in: tableView)
                case 1: return makeDisclosureCell(with: "Notifiche", in: tableView)
                case 2: return makeDisclosureCell(with: "Licenze", in: tableView)
                default: fatalError()
                }
            } else {
                switch indexPath.row {
                case 0: return makeDisclosureCell(with: "Info", in: tableView)
                case 1: return makeDisclosureCell(with: "Notifiche", in: tableView)
                case 2: return makeDisclosureCell(with: "Tema colori", in: tableView)
                case 3: return makeDisclosureCell(with: "Licenze", in: tableView)
                default: fatalError()
                }
            }
            #endif
            
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
//        case 0: break
        case 0:
            switch indexPath.row {
            case 0:
                if #available(iOS 14, *) { break }
                navigationController?.pushViewController(UserAgeVC(), animated: true)
            case 1:
                if #available(iOS 14, *) { break }
                navigationController?.pushViewController(GenderVC(), animated: true)
            case 2: navigationController?.pushViewController(LocationVC(), animated: true)
            default: break
            }
        case 1:
            #if DEBUG
            if #available(iOS 13, *) {
                switch indexPath.row {
                case 0: navigationController?.pushViewController(InfoVC(), animated: true)
                case 1: navigationController?.pushViewController(NotificheVC(style: .grouped), animated: true)
                case 2: navigationController?.pushViewController(LicenseVC(), animated: true)
                case 3: navigationController?.pushViewController(DebugVC(), animated: true)
                
                default: break
                }
            } else {
                switch indexPath.row {
                case 0: navigationController?.pushViewController(InfoVC(), animated: true)
                case 1: navigationController?.pushViewController(NotificheVC(style: .grouped), animated: true)
                case 2: navigationController?.pushViewController(ColorThemeVC(), animated: true)
                case 3: navigationController?.pushViewController(LicenseVC(), animated: true)
                case 4: navigationController?.pushViewController(DebugVC(), animated: true)
                
                default: break
                }
            }
            #else
            if #available(iOS 13, *) {
                switch indexPath.row {
                case 0: navigationController?.pushViewController(InfoVC(), animated: true)
                case 1: navigationController?.pushViewController(NotificheVC(style: .grouped), animated: true)
                case 2: navigationController?.pushViewController(LicenseVC(style: .grouped), animated: true)
                
                default: break
                }
            } else {
                switch indexPath.row {
                case 0: navigationController?.pushViewController(InfoVC(), animated: true)
                case 1: navigationController?.pushViewController(NotificheVC(style: .grouped), animated: true)
                case 2: navigationController?.pushViewController(ColorThemeVC(), animated: true)
                case 3: navigationController?.pushViewController(LicenseVC(style: .grouped), animated: true)
                
                default: break
                }
            }
            #endif
        default: fatalError()
        }
    }
}
