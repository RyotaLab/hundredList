//
//  First_Tab_View.swift
//  hundred_list_year
//
//  Created by 渡邊涼太 on 2024/07/02.
//

import SwiftUI
import RealmSwift

struct FirstTabView: View {
    
    //タグ関係
    private let tags = ["未選択", "旅行", "食事", "買い物", "仕事", "勉強・資格", "ヘルスケア", "人間関係", "趣味", "美容", "その他"]
    
    @State var isImportant = false
    @State var selectedTag = "未選択"
    
    let dateCalculation = DateCalculation()
    
    //今年の設定数
    @ObservedResults(BucketList.self) var bucketLists
    
    var body: some View {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: Date())
        
        NavigationStack{
            ZStack{
                Color.background
                
                VStack{
                    if bucketLists.where({$0.year == year}).count < 100 {
                        NavigationLink(destination: AddView()){
                            Text("\(Image(systemName: "plus"))登録")
                                .fontWeight(.bold)
                                .frame(width: 100, height: 50, alignment: .center)
                                .foregroundColor(.orange)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.orange, lineWidth: 1.0)
                                )
                                .background(Color.white, in: RoundedRectangle(cornerRadius: 15))
                        }
                        .padding(.top)
                        
                        Text("100個登録されていません")
                            .foregroundColor(Color.button)
                        Text("現在\(bucketLists.where({$0.year == year}).count)個です")
                            .foregroundColor(Color.button)
                    }else{
                        NavigationLink(destination: SecretView()){
                            Text("Good Luck to you!")
                                .font(.title)
                                .foregroundColor(.orange)
                                .fontWeight(.bold)
                                .padding(.top)
                        }
                    }//if
                    
                    if bucketLists.where({$0.year == year && $0.achievement == true}).count == 100 {
                        
                        Image("Clover")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:150)
                        Text("達成おめでとう！")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.button)
                            .padding()
                        VStack(alignment: .leading){
                            Text("あなたの一年はどうでしたか？")
                                .foregroundColor(.button)
                            Text("このアプリのおかげで、")
                                .foregroundColor(.button)
                            Text("少しでもポジティブ効果があれば幸いです！")
                                .foregroundColor(.button)
                            Text("来年も良い一年でありますよに！")
                                .foregroundColor(.button)
                            Text("（開発者のコメント）")
                                .foregroundColor(.button)
                            
                                
                        }.padding(.horizontal)
                    }else{
                        HStack{
                            //星マーク
                            if isImportant{
                                //星マーク
                                Text("\(Image(systemName:"star.fill"))")
                                    .padding(10)
                                    .foregroundColor(.orange)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.orange, lineWidth: 1.0)
                                    )
                                    .background(.white, in: RoundedRectangle(cornerRadius: 10))
                                    .onTapGesture {
                                        withAnimation {
                                            isImportant.toggle()
                                        }
                                    }
                                    .padding(.leading, 20)
                            }else{
                                Text("\(Image(systemName:"star"))")
                                    .padding(10)
                                    .foregroundColor(.button)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray, lineWidth: 1.0)
                                    )
                                    .background(.white, in: RoundedRectangle(cornerRadius: 10))
                                    .onTapGesture {
                                        withAnimation {
                                            isImportant.toggle()
                                        }
                                    }
                                    .padding(.leading, 20)
                            }//星マーク終わり
                            
                            //タグ選択
                            Picker("タグ選択", selection: $selectedTag){
                                ForEach(tags, id: \.self){ tag in
                                    Text(tag)
                                }
                            }.accentColor(selectedTag == "未選択" ? .button : .white)
                                .padding(.vertical, 3)
                                .padding(.horizontal, 5)
                                .background(selectedTag == "未選択" ? .white : .gray, in: RoundedRectangle(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1.0)
                                )
                            Spacer()
                        }//HStack
                        DisplayRealmView(selected_Tag: $selectedTag, is_Important: $isImportant, year: year)
                    }
                }//VStack
            }//ZStack
            .navigationBarTitle("来年まで\(dateCalculation.date_ToNextYear())日", displayMode: .inline)
        }//NavigationStack
    }
}

//#Preview {
//    First_Tab_View()
//}
