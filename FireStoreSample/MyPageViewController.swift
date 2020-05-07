//
//  MyPageViewController.swift
//  FireStoreSample
//
//  Created by 飯田諒 on 2020/05/06.
//  Copyright © 2020 飯田諒. All rights reserved.
//

import Foundation
import UIKit

class MyPageViewController: UIViewController {
    
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var uid: UILabel!
    @IBOutlet weak var createdDate: UILabel!
    var nameString: String = ""
    var uidString: String = ""
    var date: Date? = nil
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}
