//
//  SignUpViewController.swift
//  FireStoreSample
//
//  Created by 飯田諒 on 2020/05/06.
//  Copyright © 2020 飯田諒. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var registerButton: UIButton! {
        didSet {
            self.registerButton.isEnabled = false
        }
    }
    
    @IBAction func registerButtonDidTap(_ sender: Any) {
        guard let email = emailField.text, let password = passwordField.text else { return }
        Auth.auth().createUser(withEmail: email, password: password, completion: {[weak self] (res, err) in
            if let error = err {
                print(error.localizedDescription)
            }
            print(res)
            self?.dismiss(animated: true, completion: nil)
        })

    }
    
    @IBAction func fieldEdited(_ sender: Any) {
        inputted()
    }
    
    func inputted() {
        self.registerButton.isEnabled = emailField.hasText && passwordField.hasText
    }
}
