//
//  NewPostViewController.swift
//  FireStoreSample
//
//  Created by 飯田諒 on 2020/05/07.
//  Copyright © 2020 飯田諒. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth
class NewPostViewController: UIViewController {
    
    @IBOutlet weak var postField: UITextView!
    var user: User!
    var firestore: Firestore!
    override func viewDidLoad() {
        super.viewDidLoad()
        firestore = Firestore.firestore()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let user = Auth.auth().currentUser else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        self.user = user
    }
    
    @IBAction func postButtonDidTap(_ sender: Any) {
        guard let post = postField.text else { return }
        firestore.collection("posts").addDocument(data: ["userId": user.uid, "content": post, "postedTimeInterval": Date().timeIntervalSince1970, "likedUserIds": []], completion: {[weak self] error in
            guard let self = self else { return }
            if let err = error {
                print("failed to post: \(err.localizedDescription)")
            }
            self.dismiss(animated: true, completion: nil)
            guard let presentationController = self.presentationController else { return }
            presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
        })
    }
}
