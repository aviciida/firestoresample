//
//  SignInViewController.swift
//  FireStoreSample
//
//  Created by 飯田諒 on 2020/05/06.
//  Copyright © 2020 飯田諒. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton! {
        didSet {
            self.signInButton.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = Auth.auth().currentUser {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func segueToSignUp(_ sender: Any) {
        let vc = UIStoryboard(name: "SignUpViewController", bundle: Bundle(for: SignUpViewController.self)).instantiateInitialViewController()!
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func fieldEdited(_ sender: Any) {
        signInButton.isEnabled = emailField.hasText && passwordField.hasText
    }
    
    @IBAction func signInDidTap(_ sender: Any) {
        guard let email = emailField.text, let password = passwordField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self] (res, err) in
            guard let self = self else { return }
            if let error = err {
                print(error.localizedDescription)
            }
            if let result = res {
                print(result.user)
                self.dismiss(animated: true, completion: nil)
                guard let presentationController = self.presentationController else { return }
                presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
            }
        })
    }
}
