//
//  RealmDatabase.swift
//  hundred_list_year
//
//  Created by 渡邊涼太 on 2024/07/02.
//

import Foundation
import RealmSwift

class BucketList: Object, Identifiable {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var tag: String
    @Persisted var important: Bool
    @Persisted var year:Int
    @Persisted var imagedata: Data
    @Persisted var memo: String
    @Persisted var achievement: Bool
    @Persisted var achivement_date: Date
    
    override class func primaryKey() -> String? {
        "id"
    }
    
}
