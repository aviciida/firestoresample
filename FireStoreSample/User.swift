//
//  User.swift
//  FireStoreSample
//
//  Created by 飯田諒 on 2020/05/07.
//  Copyright © 2020 飯田諒. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
struct User {
    let uid: String
    let displayName: String
    let createdTimeInterval: Double
    var createdAt: String {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMdkHms", options: 0, locale: Locale(identifier: "ja_JP"))
        return formatter.string(from: Date(timeIntervalSince1970: createdTimeInterval))
    }
    
    init(uid: String, displayName: String, createdTimeInterval: Double) {
        self.uid = uid
        self.displayName = displayName
        self.createdTimeInterval = createdTimeInterval
    }
    
    init?(snapShot: QueryDocumentSnapshot) {
        let data = snapShot.data()
        guard let uid = data["uid"] as? String, let displayName = data["displayName"] as? String, let createdTimeInterval = data["createdTimeInterval"] as? Double else { return nil }
        self.init(uid: uid, displayName: displayName, createdTimeInterval: createdTimeInterval)
    }
}
