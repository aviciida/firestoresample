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
    
    @IBOutlet weak var postsTableView: UITableView!
    
    var firestore: Firestore!
    override func viewDidLoad() {
        super.viewDidLoad()
        firestore = Firestore.firestore()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let rightBarButton = UIBarButtonItem(title: "menu", style: .plain, target: self, action: #selector(rightBarButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let user = Auth.auth().currentUser else {
            let storyBoard = UIStoryboard(name: String(describing: SignInViewController.self), bundle: Bundle(for: SignInViewController.self))
            let vc = storyBoard.instantiateInitialViewController()!
            self.present(vc, animated: true, completion: nil)
            return
        }
    }
    
    @objc func rightBarButtonTapped() {
        let sheet = UIAlertController(title: "menu", message: nil, preferredStyle: .actionSheet)
        let signOut = UIAlertAction(title: "SignOut", style: .default, handler: {[weak self] _ in
            guard let self = self else { return }
            let auth = Auth.auth()
            do {
                try auth.signOut()
            } catch let signOutError as NSError {
              print ("Error signing out: %@", signOutError)
            }
            
            let vc = UIStoryboard(name: String(describing: SignInViewController.self), bundle: Bundle(for: SignInViewController.self)).instantiateInitialViewController()!
            self.present(vc, animated: true, completion: nil)
        })
        
        let myPage = UIAlertAction(title: "Mypage", style: .default, handler: {[weak self] _ in
            guard let self = self else { return }
            guard let user = Auth.auth().currentUser else { return }
            var date: Date? = nil
            let docRef = self.firestore.collection("users").document(user.uid)
            docRef.getDocument { [weak self] (document, error) in
                guard let self = self else { return }
                if let err = error {
                    print(err.localizedDescription)
                } else if let doc = document {
                    guard let data = doc.data() else { return }
                    let timeInterval = data["createdAt"] as! Double
                    date = Date(timeIntervalSince1970: timeInterval)
                }
                let vc = MyPageViewController.instantiate(nameString: user.displayName ?? "名無さん", uidString: user.uid, date: date)
                self.present(vc, animated: true, completion: nil)
            }
        })
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        sheet.addAction(signOut)
        sheet.addAction(myPage)
        sheet.addAction(cancel)
        present(sheet, animated: true, completion: nil)
    }

    @IBAction func addData(_ sender: Any) {
        firestore.collection("posts").addDocument(data: ["user" : "ryo", "postedAt": Date(), "content": "Firebase勉強中"]){ err in
            if let err = err {
                print(err.localizedDescription)
            } else {
                
            }
        }
    }

    
}

