//
//  ViewControllerRequests.swift
//  FireStoreSample
//
//  Created by 飯田諒 on 2020/05/10.
//  Copyright © 2020 飯田諒. All rights reserved.
//

import Foundation

struct MyPageViewControllerRequest: ViewControllerRequest {
    var inputValue: Input
    struct Input {
        let nameString: String
        let uidString: String
        let date: Date?
        init(nameString: String, uidString: String, date: Date?) {
            self.nameString = nameString
            self.uidString = uidString
            self.date = date
        }
    }
}
