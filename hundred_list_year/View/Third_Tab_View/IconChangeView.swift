//
//  IconChangeView.swift
//  hundred_list_year
//
//  Created by 渡邊涼太 on 2024/07/07.
//

import SwiftUI

struct IconChangeView: View {
    
    @EnvironmentObject private var purchaseManager: PurchaseManager
    
    @Environment(\.dismiss) var dismiss
    @State var tabFlag: Visibility = .hidden
    
    var isPurchased: Bool
    
    let ImageNameList = ["AppIconImage2","AppIconImage3","AppIconImage4","AppIconImage5","AppIconImage6"]
    
    let IconNameList = ["AppIcon 2","AppIcon 3","AppIcon 4","AppIcon 5","AppIcon 6"]
    
    let IconTextList = ["青紫グラデーション", "緑黄色グラデーション", "赤ピンクグラデーション", "ブルークローバー", "ダブルツリー"]
    
    
    var body: some View {
        ZStack{
            Color.background
            VStack(spacing:20){
                
                Text("プレミアムプランの方のみ使用いただけます")
                    .padding(.top, 20)
                Text("是非使ってみてね！")
                Text("クリックすればそのアイコンに変わります")
                List{
                    //初期アイコン
                    HStack{
                        Image("AppIconImage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 55)
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.gray, lineWidth: 0.5)
                            )
                        Button{
                            UIApplication.shared.setAlternateIconName(nil)
                        }label:{
                            Text("初期アイコン")
                                .foregroundColor(Color.button)
                        }
                        Spacer()
                    }
                    
                    //カスタムアイコン
                    
                    ForEach(Array(ImageNameList.enumerated()), id: \.element) { i, icon in
                        if isPurchased {//購入ずみ
                            HStack{
                                Image(ImageNameList[i])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 55)
                                    .cornerRadius(15)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.gray, lineWidth: 0.5)
                                    )
                                Button{
                                    UIApplication.shared.setAlternateIconName(IconNameList[i])
                                }label:{
                                    Text(IconTextList[i])
                                        .foregroundColor(Color.button)
                                }
                                Spacer()
                            }
                        }else{//購入してない
                            HStack{
                                Image(ImageNameList[i])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 55)
                                    .cornerRadius(15)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.gray, lineWidth: 0.5)
                                    )
                                Text(IconTextList[i])
                                    .foregroundColor(Color.button)
                                Spacer()
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.orange)
                                    .font(.system(size: 20))
                            }
                        }
                    }
                    
                    
                }//List
            }//Vstack
            
            
            
            
            
            
            
        }//ZStack
        .navigationBarTitle("icon変更", displayMode: .inline)
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
//    IconChangeView()
//}
