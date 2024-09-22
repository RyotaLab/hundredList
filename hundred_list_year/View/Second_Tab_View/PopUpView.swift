//
//  PopUpView.swift
//  hundred_list_year
//
//  Created by 渡邊涼太 on 2024/07/11.
//

import SwiftUI
import RealmSwift

struct PopUpView: View {
    
    //Realm
    @ObservedRealmObject var bucket_item: BucketList
    
    //Binding
    @Binding var showPop:Bool
    @Binding var showDeleteAlert:Bool
    @Binding var showingEditView:Bool
    
    var body: some View {
        
        ZStack{
            Color.black
                .opacity(0.3)
                .onTapGesture {
                    showPop = false
                }
                //arrowshape.turn.up.backward.fill
                VStack{
                    HStack(spacing:15){
                        Button{
                            showPop = false
                        }label:{
                            Text("\(Image(systemName: "arrowshape.turn.up.backward.fill"))戻る")
                                .frame(width: 80, height: 30, alignment: .center)
                                .foregroundColor(Color.gray)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 7)
                                        .stroke(Color.gray, lineWidth: 1.0)
                                )
                                .background(Color.white, in: RoundedRectangle(cornerRadius: 7))
                        }
                        Button{
                            //画面遷移のための何か
                            showPop = false
                            showingEditView = true
                        }label:{
                            Text("\(Image(systemName: "pencil"))編集")
                                .frame(width: 80, height: 30, alignment: .center)
                                .foregroundColor(Color.blue)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 7)
                                        .stroke(Color.blue, lineWidth: 1.0)
                                )
                                .background(Color.white, in: RoundedRectangle(cornerRadius: 7))
                        }
                        Button{
                            //alart表示
                            showDeleteAlert = true
                        }label:{
                            Text("\(Image(systemName: "multiply"))削除")
                                .frame(width: 80, height: 30, alignment: .center)
                                .foregroundColor(Color.red)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 7)
                                        .stroke(Color.red, lineWidth: 1.0)
                                )
                                .background(Color.white, in: RoundedRectangle(cornerRadius: 7))
                        }
                    }
                    //image
                    Image(uiImage: UIImage(data: bucket_item.imagedata) ?? UIImage(named: "imageEx1")!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:220, height: 220)
                    
                    Text(bucket_item.name)
                        .fontWeight(.bold)
                        .foregroundColor(.button)
                    ScrollView{
                        Text(bucket_item.memo)
                            .foregroundColor(.button)
                    } .frame(width:300, height: 120)
                }
                .padding(.vertical)
                .background(Color.white)
                .cornerRadius(10)
        }
    }
}

//if bucketitem != nil{
//    AchievementView(bucket_item: bucketitem!)
//}

//#Preview {
//    PopUpView()
//}
