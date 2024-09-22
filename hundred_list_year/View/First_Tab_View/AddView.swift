//
//  AddView.swift
//  hundred_list_year
//
//  Created by 渡邊涼太 on 2024/07/08.
//

import SwiftUI
import PhotosUI

struct AddView: View {
    
    @State var tabFlag: Visibility = .hidden
    @Environment(\.dismiss) var dismiss
    @FocusState private var focusedField: Field?
    
    //登録or編集で使用する変数
    @State var name_field:String = ""
    @State var selectedTag:String = "その他"
    @State var isImportant:Bool = false
    
    @State var cautionText: String = ""
    
    //タグリスト
    private let tags = ["旅行", "食事", "買い物", "仕事", "勉強・資格", "ヘルスケア", "人間関係", "趣味", "美容", "その他"]
    
    //Realm
    let realmController = RealmController()
    
    var body: some View {
        ZStack{
            Color.background
            ScrollView(showsIndicators: false) {
                ZStack{
                    Color.background
                        .onTapGesture {
                            focusedField = nil
                        }
                    
                    VStack(spacing:30){
                        Text("名称")
                            .foregroundColor(Color.button)
                            .fontWeight(.bold)
                            .padding(.top, 30)
                            .overlay(
                                Rectangle()
                                    .fill(Color.orange)
                                    .frame(width: 65, height: 1)
                                , alignment: .bottom
                            )
                        TextField("名前を入力してください", text: $name_field)
                            .focused($focusedField, equals: .add_name)
                            .overlay(
                                RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                                    .stroke(Color.gray, lineWidth: 1.5)
                                    .padding(-8.0)
                            )
                            .padding(8.0)
                            .background(Color.white, in: RoundedRectangle(cornerRadius: 8))
                            .padding(.horizontal, 40)
                        
                        
                        Text("タグ")
                            .foregroundColor(Color.button)
                            .fontWeight(.bold)
                            .padding(.top, 30)
                            .overlay(
                                Rectangle()
                                    .fill(Color.orange)
                                    .frame(width: 65, height: 1)
                                , alignment: .bottom
                            )
                        FlowLayout(alignment: .center, spacing: 7) {
                            ForEach(tags, id:\.self) { tag in
                                Text(tag)
                                    .foregroundColor(selectedTag == tag ? .white: .orange)
                                    .padding(.vertical, 5)
                                    .padding(.horizontal, 12)
                                    .background(selectedTag == tag ? .orange: .white, in: RoundedRectangle(cornerRadius: 10))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.orange, lineWidth: 1.0)
                                    )
                                    .onTapGesture {
                                        selectedTag = tag
                                    }
                            }
                        }.padding(.horizontal)//FlowLayout
                        Text("優先度")
                            .foregroundColor(Color.button)
                            .fontWeight(.bold)
                            .padding(.top, 30)
                            .overlay(
                                Rectangle()
                                    .fill(Color.orange)
                                    .frame(width: 65, height: 1)
                                , alignment: .bottom
                            )
                        HStack{
                            Text(isImportant ? "高い" : "普通")
                                .frame(width: 70, height: 50, alignment: .leading)
                                .foregroundColor(isImportant ? .green : .button)
                                .fontWeight(isImportant ? .bold : .regular)
                            Toggle(isOn: $isImportant) {}.padding()
                                .labelsHidden()
                                .tint(isImportant ? .green: .gray)
                        }
                        
                        Text(cautionText)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.pink)
                        
                        Button{
                            if name_field == ""{
                                cautionText = "名前を入力してください"
                            }else{
                                //登録処理
                                realmController.MakeList(bucket_name: name_field, bucket_tag: selectedTag, bucket_important: isImportant)
                                
                                //dismiss
                                tabFlag = .visible
                                selectedTag = "その他"
                                dismiss()
                            }
                        }label:{
                            Text("登録する")
                                .fontWeight(.bold)
                                .frame(width: 100, height: 50, alignment: .center)
                                .foregroundColor(.orange)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.orange, lineWidth: 1.0)
                                )
                                .background(Color.white, in: RoundedRectangle(cornerRadius: 15))
                                .padding(.bottom, 100)
                        }
                        
                        //realmController.MakeList(bucket_name: name_field, bucket_image: selectedImage, bucket_category: selectedCategory)
                    }//VStack
                }//ZStack
            }//scroll
            
        }//ZStack
        .navigationBarTitle("登録する", displayMode: .inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading){
                Button{
                    //戻るボタン
                    dismiss()
                    tabFlag = .visible
                    
                }label:{
                    Image(systemName: "arrowshape.turn.up.backward.fill")
                        .foregroundColor(Color.button)
                    
                }
            }
        }
        .toolbar(tabFlag, for: .tabBar)
    }
}

//#Preview {
//    AddView()
//}
