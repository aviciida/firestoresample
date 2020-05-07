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
class ViewController: UIViewController, UIAdaptivePresentationControllerDelegate {
    
    @IBOutlet weak var postsTableView: UITableView!
    var posts: [Post] = []
    var firestore: Firestore!
    override func viewDidLoad() {
        super.viewDidLoad()
        postsTableView.delegate = self
        postsTableView.dataSource = self
        firestore = Firestore.firestore()
        postsTableView.register(UINib(nibName: String(describing: PostTableViewCell.self), bundle: Bundle(for: PostTableViewCell.self)), forCellReuseIdentifier: String(describing: PostTableViewCell.self))

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let rightBarButton = UIBarButtonItem(title: "menu", style: .plain, target: self, action: #selector(rightBarButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButton
        
        getPosts()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let _ = Auth.auth().currentUser else {
            let storyBoard = UIStoryboard(name: String(describing: SignInViewController.self), bundle: Bundle(for: SignInViewController.self))
            let vc = storyBoard.instantiateInitialViewController()!
            self.present(vc, animated: true, completion: nil)
            return
        }
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        getPosts()
    }
    
    func getPosts() {
        firestore.collection("posts").getDocuments { [weak self] (result, error) in
            guard let self = self else { return }
            if let err = error {
                print("Failed to get content: \(err.localizedDescription)")
            }
            guard let content = result else {
                print("result was nil")
                return
            }
            self.posts = []
            for snapShot in content.documents {
                guard let post = Post(snapShot: snapShot) else { continue }
                self.posts.append(post)
            }
            self.postsTableView.reloadData()
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
    
    @IBAction func segueToNewPost(_ sender: Any) {
        let vc = UIStoryboard(name: String(describing: NewPostViewController.self), bundle: Bundle(for: NewPostViewController.self)).instantiateInitialViewController()!
        vc.presentationController?.delegate = self
        present(vc, animated: true, completion: nil)
    }
    

    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostTableViewCell.self), for: indexPath) as! PostTableViewCell

        cell.userIdLabel.text = post.userId
        cell.postContentLabel.text = post.content
        cell.postedDateLabel.text = post.postedAt
        cell.likedLabel.text = String(post.likes)
        return cell
    }
    
    
}
