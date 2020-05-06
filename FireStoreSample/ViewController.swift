//
//  ViewController.swift
//  FireStoreSample
//
//  Created by 飯田諒 on 2020/05/06.
//  Copyright © 2020 飯田諒. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
class ViewController: UIViewController {
    var firestore: Firestore!
    override func viewDidLoad() {
        super.viewDidLoad()
        firestore = Firestore.firestore()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let user = Auth.auth().currentUser else {
            let storyBoard = UIStoryboard(name: String(describing: SignInViewController.self), bundle: Bundle(for: SignInViewController.self))
            let vc = storyBoard.instantiateInitialViewController()!
            self.present(vc, animated: true, completion: nil)
            return
        }
        
        print(user.uid)
    }

    @IBAction func addData(_ sender: Any) {
        firestore.collection("posts").addDocument(data: ["user" : "ryo", "postedAt": Date(), "content": "Firebase勉強中"]){ err in
            if let err = err {
                print(err.localizedDescription)
            } else {
                
            }
        }
    }
    
    @IBAction func signOut(_ sender: Any) {
        let auth = Auth.auth()
        do {
            try auth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        
        let vc = UIStoryboard(name: String(describing: SignInViewController.self), bundle: Bundle(for: SignInViewController.self)).instantiateInitialViewController()!
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func segueToMyPage(_ sender: Any) {
        guard let user = Auth.auth().currentUser else { return }
        var date: Date? = nil
        let docRef = firestore.collection("users").document(user.uid)
        docRef.getDocument { [weak self] (document, error) in
            if let err = error {
                print(err.localizedDescription)
            } else if let doc = document {
                guard let data = doc.data() else { return }
                date = data["createdAt"] as? Date
            }
        }
        let vc = MyPageViewController(nameString: user.displayName ?? "名無さん", uidString: user.uid, date: date)
        self.present(vc, animated: true, completion: nil)
    }
    
}

