//
//  DiocesiVC.swift
//  MGS
//
//  Created by Dani Tox on 17/06/2019.
//  Copyright © 2019 Dani Tox. All rights reserved.
//

import UIKit

class DiocesiVC: UITableViewController {
    
    var dataSource = DiocesiDataSource()
    var cRefreshControl : UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Diocesi"
        
        cRefreshControl.addTarget(self, action: #selector(refreshed), for: .valueChanged)
        tableView.refreshControl = cRefreshControl
        
        tableView.dataSource = dataSource
        tableView.backgroundColor = Theme.current.tableViewBackground
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(LocationCell.self, forCellReuseIdentifier: "locCell")
        tableView.register(BoldCell.self, forCellReuseIdentifier: "boldCell")
        
        dataSource.errorHandler = self.errorHandler
        dataSource.updateHandler = self.updateOccurred
        
        dataSource.load()
    }
    
    func errorHandler(err: Error) {
        self.showError(withTitle: "Errore", andMessage: "\(err.localizedDescription)")
    }
    
    @objc private func refreshed() {
        self.cRefreshControl.beginRefreshing()
        dataSource.load()
    }
    
    func updateOccurred() {
        DispatchQueue.main.async {
            self.cRefreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
}

extension DiocesiVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let diocesi = dataSource.allDiocesi[indexPath.row]
        
        if diocesi.isSelected {
            //
        } else {
            self.dataSource.loadingDiocesi.append(diocesi)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            let agent = dataSource.agent
            
            agent.fetchLocalizedWebsites(for: diocesi) { (list) in
                print("\n\nINIZIO\n")
                for site in list.siti {
                    print(site.urlString)
                }
                print("\nFINEEE\n\n")
                self.dataSource.loadingDiocesi.removeAll { $0 == diocesi }
                agent.toggle(diocesi: diocesi)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}