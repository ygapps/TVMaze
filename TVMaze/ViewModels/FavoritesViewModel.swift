//
//  FavoritesViewModel.swift
//  TVMaze
//
//  Created by Youssef on 8/5/22.
//

import Foundation
import RealmSwift

class FavoritesViewModel {
    
    private let realmDB = try! Realm()
    private var notificationToken: NotificationToken?

    public var didReceiveUpdates: (() -> ())?
    public var likedShows: Results<LikedShow>
    public var title: String {
        return "Favorites"
    }
    
    init() {
        self.likedShows = realmDB.objects(LikedShow.self)
                                 .sorted(byKeyPath: "likedShowName", ascending: true)
        
        self.notificationToken = likedShows.observe { [weak self] _ in
            self?.didReceiveUpdates?()
        }
    }
    
    public func remove(seriesId: Int) {
        guard let likedShow = realmDB.object(ofType: LikedShow.self, forPrimaryKey: seriesId) else {
            return
        }
        
        try! realmDB.write {
            realmDB.delete(likedShow)
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }
}
