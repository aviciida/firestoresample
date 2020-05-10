//
//  MyPageViewController.swift
//  FireStoreSample
//
//  Created by 飯田諒 on 2020/05/10.
//  Copyright © 2020 飯田諒. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
final class MyPageViewController: UIViewController, Instantiatable {
    typealias Input = MyPageViewControllerRequest.Input
    typealias Environment = EnvironmentProvider
    var environment: Environment
    var firestore: Firestore!
    var uidString: String
    var nameString: String
    var date: Date?
    private lazy var myPageView: MyPageView = MyPageView(frame: self.view.bounds)
    init(with input: MyPageViewControllerRequest.Input, environment: EnvironmentProvider) {
        self.environment = environment
        self.uidString = input.uidString
        self.nameString = input.nameString
        self.date = input.date
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = myPageView
        myPageView.instantiate(nameString: nameString, uidString: uidString, date: date)
        let ref = Storage.storage().reference().child("images").child(uidString).child("profile")
        let imageView: UIImageView = self.myPageView.icon
        imageView.sd_setImage(with: ref)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firestore = Firestore.firestore()
        myPageView.doneButtonTappedHandler = { [weak self] name in
            guard let user = Auth.auth().currentUser, let self = self else { return }
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = name
            changeRequest.commitChanges { (error) in
                if let err = error {
                    print("Failed to update displayname: \(err.localizedDescription)")
                }
            }
            self.firestore.collection("users").document(user.uid).updateData(["displayName": name]) { error in
                if let err = error {
                    print("Failed to update user's name: \(err.localizedDescription)")
                }
            }
            
        }
        
        myPageView.imageUploadButtonTappedHandler = { [weak self] in
            guard let self = self else { return }
            let picker: UIImagePickerController = UIImagePickerController()
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
            picker.delegate = self
            picker.navigationBar.tintColor = UIColor.white
            picker.navigationBar.barTintColor = UIColor.gray
            self.present(picker, animated: true, completion: nil)
            
        }
    }
}

extension MyPageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {

            //ボタンの背景に選択した画像を設定
            myPageView.icon.image = image
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
