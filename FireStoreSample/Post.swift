//
//  Post.swift
//  FireStoreSample
//
//  Created by 飯田諒 on 2020/05/07.
//  Copyright © 2020 飯田諒. All rights reserved.
//

import Foundation

struct Post {
    let id: String
    let userId: String
    let content: String
    let postedAt: String
    let likes: Int
    
    init(id: String, userId: String, content: String, postedDate: Double, likes: Int) {
        self.id = id
        self.userId = userId
        self.content = content
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
        self.postedAt = formatter.string(from: Date(timeIntervalSince1970: postedDate))
        self.likes = likes
    }
}
