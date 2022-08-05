//
//  LikedShow.swift
//  TVMaze
//
//  Created by Youssef on 8/5/22.
//

import Foundation
import RealmSwift

class LikedShow: Object {
    
    @Persisted(primaryKey: true)
    var likedShowId: Int
    @Persisted
    var likedShowName: String?
    @Persisted
    var likedShowImageURL: String?
    
    convenience init(likedShowId: Int, likedShowName: String?, likedShowImageURL: String?) {
        self.init()
        self.likedShowId = likedShowId
        self.likedShowName = likedShowName
        self.likedShowImageURL = likedShowImageURL
    }
}
