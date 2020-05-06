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
    var nameString: String
    var uidString: String
    var date: Date?
    
    init(nameString: String, uidString: String, date: Date?) {

       // 受け取った引数でプロパティを初期化
       self.nameString = nameString
       self.uidString = uidString
        self.date = date
        
       // クラスの持つ指定イニシャライザを呼び出す
       super.init(nibName: nil, bundle: nil)
   }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.displayName.text = nameString
        self.uid.text = uidString
        let formatter = DateFormatter()
        if let date = date {
            self.createdDate.text = formatter.string(from: date)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
   // 新しく init を定義した場合に必須
   required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
}
