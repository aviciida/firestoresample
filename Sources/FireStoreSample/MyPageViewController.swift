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
import FirebaseStorage
import FirebaseUI

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
    @IBOutlet weak var icon: UIImageView! {
        didSet {
            self.icon.layer.masksToBounds = true
            self.icon.layer.cornerRadius = self.icon.bounds.width / 2
            let ref = Storage.storage().reference().child("images").child(uidString).child("profile")
            let imageView: UIImageView = self.icon
            imageView.sd_setImage(with: ref)

        }
    }
    var nameString: String = ""
    var uidString: String = ""
    var date: Date? = nil
    var firestore: Firestore!
    var picker: UIImagePickerController! = UIImagePickerController()
    
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
    
    @IBAction func imageUpload(_ sender: Any) {
        //PhotoLibraryから画像を選択
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary

        //デリゲートを設定する
        picker.delegate = self

        //現れるピッカーNavigationBarの文字色を設定する
        picker.navigationBar.tintColor = UIColor.white

        //現れるピッカーNavigationBarの背景色を設定する
        picker.navigationBar.barTintColor = UIColor.gray

        //ピッカーを表示する
        present(picker, animated: true, completion: nil)
    }
}

extension MyPageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {

            //ボタンの背景に選択した画像を設定
            icon.image = image
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let storageImagesRef =  storageRef.child("images").child(uidString).child("profile")
            guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            storageImagesRef.putData(imageData, metadata: metaData){ (storageMetaData, error) in
                if let err = error {
                    print("Failed to upload image: \(err.localizedDescription)")
                }
                storageImagesRef.downloadURL { [weak self](url, error) in
                    guard let self = self, let url = url?.absoluteString else { return }
                    self.firestore.collection("users").document(self.uidString).updateData(["profileImageUrl": url]) { error in
                        if let err = error {
                            print("Failed to upload image URL to \(self.uidString): \(err.localizedDescription)")
                        }
                    }
                }
            }
        } else{
            print("Error")
        }
        self.dismiss(animated: true, completion: nil)
    }
}
