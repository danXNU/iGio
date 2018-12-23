//
//  LoginVC.swift
//  SFA
//
//  Created by Dani Tox on 21/11/2018.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, HasCustomView {
    typealias CustomView = LoginView
    override func loadView() {
        super.loadView()
        view = CustomView()
    }
    
    let model = NetworkAgent()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        
        model.errorHandler = { [weak self] errorString in
            self?.showError(withTitle: "Errore", andMessage: errorString) //function already in MainQueue
        }
        
        enableAutoHideKeyboardAfterTouch(in: [rootView])
        
        let backButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(backAction))
        navigationItem.setLeftBarButton(backButton, animated: true)
        
        rootView.loginButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
    }
    
    @objc private func loginAction() {
        let email = rootView.emailField.text ?? ""
        let password = rootView.passwordField.text ?? ""
        
        model.login(email: email, password: password) { [weak self] in
            let string = "Il login è stato eseguito con successo!\nBenvenuto \(userLogged!.name)"
            self?.showAlert(withTitle: "Successo!", andMessage: string) //function already in MainQueue
        }
    }
    
    @objc private func backAction() {
        dismiss(animated: true, completion: nil)
    }
}
