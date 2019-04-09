//
//  HostViewControleller.swift
//  SFA
//
//  Created by Dani Tox on 24/11/2018.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit
import RealmSwift
import SafariServices

class HomeViewController : UIViewController, HasCustomView {
    typealias CustomView = HomeView
    override func loadView() {
        super.loadView()
        self.view = CustomView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        rootView.regolaButton.addTarget(self, action: #selector(showRegolaController), for: .touchUpInside)
        rootView.noteButton.addTarget(self, action: #selector(showNoteListController), for: .touchUpInside)
        rootView.teenStarButton.addTarget(self, action: #selector(showTeenStarController), for: .touchUpInside)
        rootView.compagniaButton.addTarget(self, action: #selector(showVerificaCompagniaController), for: .touchUpInside)
        
        let rightButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(calendarioButtonTapped))
        self.navigationItem.setRightBarButton(rightButton, animated: true)
    }
    
    @objc func calendarioButtonTapped() {
        guard let url = URL(string: "\(URLs.calendarioURL)") else { fatalError() }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    @objc func showRegolaController() {
        let vc = RiassuntoVC(style: .grouped)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func showNoteListController() {
        let noteListVC = NoteListVC()
        navigationController?.pushViewController(noteListVC, animated: true)
    }
    
    @objc private func showTeenStarController() {
        if let userGender = userLogged?.gender {
            if userGender == .boy {
                let vc = TeenStarListVC<TeenStarMaschio>()
                navigationController?.pushViewController(vc, animated: true)
            } else if userGender == .girl {
                let vc = TeenStarListVC<TeenStarFemmina>()
                navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            let vc = TeenStarListVC<TeenStarMaschio>()
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @objc private func showVerificaCompagniaController() {
        let vc = VerificaCompagniaVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension HomeViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, collapseSecondary vc2: UIViewController, onto vc1: UIViewController) -> Bool {
        return true
    }
}

