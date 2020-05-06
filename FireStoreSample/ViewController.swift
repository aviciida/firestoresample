//
//  ViewController.swift
//  FireStoreSample
//
//  Created by 飯田諒 on 2020/05/06.
//  Copyright © 2020 飯田諒. All rights reserved.
//

import UIKit
import FirebaseFirestore
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
        let storyBoard = UIStoryboard(name: "SignInViewController", bundle: Bundle(for: SignInViewController.self))
        let vc = storyBoard.instantiateInitialViewController()!
        self.present(vc, animated: true, completion: nil)
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

