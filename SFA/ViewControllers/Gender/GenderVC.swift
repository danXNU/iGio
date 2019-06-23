//
//  GenderVC.swift
//  SFA
//
//  Created by Dani Tox on 16/02/19.
//  Copyright © 2019 Dani Tox. All rights reserved.
//

import UIKit
import RealmSwift

class GenderVC: UIViewController, HasCustomView, OrderedFlowController {
    typealias CustomView = GenderVCView
    override func loadView() {
        super.loadView()
        view = CustomView()
    }
    
    var showCurrentValue: Bool = true
    var orderingCoordinator: OrderedFlowCoordinator?
    var finishAction : (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Maschio/Femmina"
        
        NotificationCenter.default.addObserver(forName: .updateTheme, object: nil, queue: .main) { (notification) in
            self.updateTheme()
        }
        
//        rootView.continueButton.addTarget(self, action: #selector(continueOnBoarding), for: .touchUpInside)
        
        rootView.maleButton.addTarget(self, action: #selector(maleButtonTouched), for: .touchUpInside)
        rootView.girlButton.addTarget(self, action: #selector(girlButtonTouched), for: .touchUpInside)
        if self.showCurrentValue {
            checkButton()
        }
        
    }
    
    
    func checkButton() {
        self.rootView.updateView(for: User.currentUser().gender)
    }
    
    @objc private func maleButtonTouched() {
        let realm = try! Realm()
        try? realm.write {
            User.currentUser().gender = .boy
        }
        
        workFinished()
        rootView.updateView(for: .boy)
    }
    
    @objc private func girlButtonTouched() {
        let realm = try! Realm()
        try? realm.write {
            User.currentUser().gender = .girl
        }
        workFinished()
        rootView.updateView(for: .girl)
    }
    
    func workFinished() {
        orderingCoordinator?.next()
        finishAction?()
        checkButton()
    }
    
    private func updateTheme() {
        rootView.backgroundColor = Theme.current.controllerBackground
    }
    
}
