//
//  MyPageViewController.swift
//  FireStoreSample
//
//  Created by 飯田諒 on 2020/05/06.
//  Copyright © 2020 飯田諒. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
class MyPageViewController: UIViewController {
    
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var uid: UILabel!
    @IBOutlet weak var createdDate: UILabel!
    @IBOutlet weak var displayNameEditField: UITextField! {
        didSet {
            self.displayNameEditField.isHidden = true
        }
    }
    @IBOutlet weak var doneButton: UIButton! {
        didSet {
            self.doneButton.isHidden = true
        }
    }
    
    var nameString: String = ""
    var uidString: String = ""
    var date: Date? = nil
    var firestore: Firestore!
    
    static func instantiate(nameString: String, uidString: String, date: Date?) -> MyPageViewController {
        let vc = UIStoryboard(name: String(describing: MyPageViewController.self), bundle: Bundle(for: MyPageViewController.self)).instantiateInitialViewController()! as MyPageViewController
        vc.nameString = nameString
        vc.uidString = uidString
        vc.date = date
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.displayName.text = nameString
        self.uid.text = uidString
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
        if let date = date {
            self.createdDate.text = formatter.string(from: date)
        }
        firestore = Firestore.firestore()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func displayNameDidTap(_ sender: Any) {
        displayName.isHidden = true
        displayNameEditField.isHidden = false
        doneButton.isHidden = false
        displayNameEditField.text = nameString
        displayNameEditField.becomeFirstResponder()
    }
    
    @IBAction func doneButtonDidTap(_ sender: Any) {
        guard let name = displayNameEditField.text, let user = Auth.auth().currentUser else { return }
        displayName.isHidden = false
        displayNameEditField.isHidden = true
        doneButton.isHidden = true
        displayName.text = name
        nameString = name
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        changeRequest.commitChanges { (error) in
            if let err = error {
                print("Failed to update displayname: \(err.localizedDescription)")
            }
        }
        firestore.collection("users").document(user.uid).updateData(["displayName": name]) { error in
            if let err = error {
                print("Failed to update user's name: \(err.localizedDescription)")
            }
        }
    }
    
}
