//
//  DisplayRealmView.swift
//  hundred_list_year
//
//  Created by 渡邊涼太 on 2024/07/13.
//

//

import SwiftUI
import RealmSwift

struct DisplayRealmView: View {
    
    //Realm表示関係
    @Binding var selected_Tag:String
    @Binding var is_Important:Bool
    var year:Int
    @ObservedResults(BucketList.self, where: ({$0.achievement == false})) var bucketLists
    
    //タグ
    @State private var tags = ["旅行", "食事", "買い物", "仕事", "勉強・資格", "ヘルスケア", "人間関係", "趣味", "美容", "その他"]
    
    //ダイアログ表示
    @State private var showingDialog = false
    @State private var showingEditView = false
    @State private var showingAchievementView = false
    
    @State var bucketitem: BucketList?
    
    var body: some View {
        NavigationStack{
            VStack{
                if bucketLists.isEmpty {
                    Text("表示するアイテムがありません")
                        .foregroundColor(Color.button)
                }
                
                List{
                    if selected_Tag == "未選択" {
                        //全体をセクションで出す
                        ForEach(tags, id: \.self) { tag in
                            
                            if is_Important{
                                //星あり
                                //Emptyじゃなければ表示
                                if !bucketLists.where({$0.tag == tag && $0.important == is_Important && $0.year == year}).isEmpty {
                                    Section(header: Text("\(tag)")){
                                        ForEach(bucketLists, id: \.id){ bucketItem in
                                            if bucketItem.tag == tag{
                                                if bucketItem.important == true{
                                                    if bucketItem.year == year{
                                                        Button{
                                                            bucketitem = bucketItem
                                                            showingDialog = true
                                                        }label:{
                                                            Text(bucketItem.name)
                                                                .foregroundStyle(.button)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }//section
                                }else{
                                    EmptyView()
                                }
                                
                            }else{
                                //星なし
                                //Emptyじゃなければ表示
                                if !bucketLists.where({$0.tag == tag && $0.year == year}).isEmpty {
                                    Section(header: Text("\(tag)")){
                                        ForEach(bucketLists, id: \.id){ bucketItem in
                                            if bucketItem.tag == tag{
                                                if bucketItem.year == year{
                                                    Button{
                                                        bucketitem = bucketItem
                                                        showingDialog = true
                                                    }label:{
                                                        Text(bucketItem.name)
                                                            .foregroundStyle(.button)
                                                    }
                                                }
                                            }
                                        }
                                    }//section
                                }
                            }//if
                        }//foreach
                        .onDelete(perform: delete)
                    }else{//カテゴリが選択されている時
                        ForEach(bucketLists, id: \.id) { bucketItem in
                            if  bucketItem.year == year{
                                if is_Important {
                                    //星のみ表示
                                    if bucketItem.important == is_Important {
                                        if bucketItem.tag == selected_Tag {
                                            Button{
                                                bucketitem = bucketItem
                                                showingDialog = true
                                            }label:{
                                                Text(bucketItem.name)
                                                    .foregroundStyle(.button)
                                            }
                                        }
                                    }
                                }else{
                                    //カテゴリ全表示
                                    if bucketItem.tag == selected_Tag {
                                        Button{
                                            bucketitem = bucketItem
                                            showingDialog = true
                                        }label:{
                                            Text(bucketItem.name)
                                                .foregroundStyle(.button)
                                        }
                                    }
                                }
                                
                            }//if
                        }//ForEach
                        .onDelete(perform: delete)
                    }//if
                }//List
                .scrollContentBackground(.hidden)
            }//VStack
            //画面遷移（編集）
            .navigationDestination(isPresented: $showingEditView){
                if bucketitem != nil {
                    EditView(bucket_item: bucketitem!)
                }
            }
            .navigationDestination(isPresented: $showingAchievementView){
                if bucketitem != nil{
                    AchievementView(bucket_item: bucketitem!)
                }
            }
        }//navigationStack
        .confirmationDialog("何をしますか？", isPresented: $showingDialog, titleVisibility: .hidden){
            Button("達成した") {
                //->achievementView(sheet)
                showingAchievementView = true
            }
            Button("編集する") {
                //->EditView(navigationview)
                //guard let pass_bucketitem = bucketitem else {return}
                showingEditView = true
                
            }
        }
    }
    func delete(offsets: IndexSet) {
        for index in offsets {
            print("Index to remove: \(index), Item: \(bucketLists[index])")
            //$bucketLists.remove(atOffsets: offsets)
            $bucketLists.remove(bucketLists[index])
        }
    }
}
