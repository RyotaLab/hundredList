//
//  RealmController.swift
//  hundred_list_year
//
//  Created by 渡邊涼太 on 2024/07/06.
//

import Foundation
import RealmSwift
//import SwiftUI

class RealmController {
    
    //let typeConversion = TypeConversion()
    
    //新しいリストを作成するとき
    func MakeList(bucket_name:String, bucket_tag:String, bucket_important: Bool){
        
        @ObservedResults(BucketList.self) var bucket_Lists
        
        //UIImageとして保存
        guard let uiimage = UIImage(named:"imageEx1") else{
            print("error(assets->UIImage)")
            return
        }
        //UIImage -> Data型へ変更
        guard let bucket_image_data = uiimage.jpegData(compressionQuality: 0.1) else{
            print("error(UIImage->Data)")
            return
        }
        let calendar = Calendar.current
        let year = calendar.component(.year, from: Date())
        
        let bucketItem = BucketList()
        bucketItem.name = bucket_name
        bucketItem.imagedata = bucket_image_data
        bucketItem.tag = bucket_tag
        bucketItem.year = year
        bucketItem.important = bucket_important
        bucketItem.memo = ""
        bucketItem.achievement = false
        bucketItem.achivement_date = Date()
        
        
        $bucket_Lists.append(bucketItem)
        print(bucketItem)
    }
    
    
    //リストを更新するとき
    func UpdateList(bucketItem:BucketList, bucket_name:String, bucket_tag:String,  bucket_important: Bool){
        do {
            let realm = try Realm()
            guard let UpdateObject = realm.object(ofType: BucketList.self, forPrimaryKey: bucketItem.id) else {return}
            
            try realm.write{
                UpdateObject.name = bucket_name
                UpdateObject.tag = bucket_tag
                UpdateObject.important = bucket_important
            }
        }catch{
            print("updateError")
        }
    }
    
    //達成済みリストを更新するとき
    func UpdateAchievedList(bucketItem:BucketList, bucket_name:String, bucket_image_data:Data, bucket_tag:String, bucket_date:Date, bucket_memo: String){
        do {
            let realm = try Realm()
            guard let UpdateObject = realm.object(ofType: BucketList.self, forPrimaryKey: bucketItem.id) else {return}
            
            try realm.write{
                UpdateObject.name = bucket_name
                UpdateObject.imagedata = bucket_image_data
                UpdateObject.tag = bucket_tag
                UpdateObject.achivement_date = bucket_date
                UpdateObject.memo = bucket_memo
            }
        }catch{
            print("updateError")
        }
    }
    
    //達成したとき
    func AcievementList(bucketItem:BucketList,bucket_date:Date, bucket_image:UIImage, bucket_memo: String){
        do {
            let realm = try Realm()
            guard let UpdateObject = realm.object(ofType: BucketList.self, forPrimaryKey: bucketItem.id) else {return}
            
            guard let bucket_image_data = bucket_image.jpegData(compressionQuality: 0.1) else{
                print("error(UIImage->Data)")
                return
            }
            
            try realm.write{
                UpdateObject.achivement_date = bucket_date
                UpdateObject.imagedata = bucket_image_data
                UpdateObject.memo = bucket_memo
                UpdateObject.achievement = true
            }
        }catch{
            print("updateError")
        }
    }
    
}
