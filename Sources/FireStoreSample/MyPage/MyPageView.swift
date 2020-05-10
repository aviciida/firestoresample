//
//  MyPageView.swift
//  FireStoreSample
//
//  Created by 飯田諒 on 2020/05/10.
//  Copyright © 2020 飯田諒. All rights reserved.
//

import Foundation
import UIKit
class MyPageView: XibView  {
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
        }
    }
    
    var doneButtonTappedHandler: ((String)->Void)? = nil
    var imageUploadButtonTappedHandler: (()-> Void)? = nil
    
    @IBAction func displayNameDidTap(_ sender: Any) {
        displayName.isHidden = true
        displayNameEditField.isHidden = false
        doneButton.isHidden = false
        displayNameEditField.text = displayName.text
        displayNameEditField.becomeFirstResponder()
    }
    
    @IBAction func doneButtonDidTap(_ sender: Any) {
        guard let name = displayNameEditField.text else { return }
        displayName.isHidden = false
        displayNameEditField.isHidden = true
        doneButton.isHidden = true
        displayName.text = name
        
        doneButtonTappedHandler?(name)
    }
    
    @IBAction func imageUploadButtonDidTap(_ sender: Any) {
        imageUploadButtonTappedHandler?()
    }
    
    func instantiate(nameString: String, uidString: String, date: Date?) {
        self.displayName.text = nameString
        self.uid.text = uidString
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
        if let date = date {
            self.createdDate.text = formatter.string(from: date)
        }
    }
}
