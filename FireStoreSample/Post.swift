//
//  Post.swift
//  FireStoreSample
//
//  Created by 飯田諒 on 2020/05/07.
//  Copyright © 2020 飯田諒. All rights reserved.
//

import Foundation
import FirebaseFirestore
struct Post {
    let id: String
    let userId: String
    let content: String
    let postedAt: String
    var likedUserIds: [String]
    var likes: Int {
        return likedUserIds.count
    }
    
    init(id: String, userId: String, content: String, postedDate: Double, likedUserIds: [String]) {
        self.id = id
        self.userId = userId
        self.content = content
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
        self.postedAt = formatter.string(from: Date(timeIntervalSince1970: postedDate))
        self.likedUserIds = likedUserIds
    }
    
    init?(snapShot: QueryDocumentSnapshot) {
        let data = snapShot.data()
        guard let userId = data["userId"] as? String, let content = data["content"] as? String, let postedDate = data["postedAt"] as? Double, let likedUserIds = data["likedUserIds"] as? [String] else { return nil }
        self.init(id: snapShot.documentID, userId: userId, content: content, postedDate: postedDate, likedUserIds: likedUserIds)

    }
}
