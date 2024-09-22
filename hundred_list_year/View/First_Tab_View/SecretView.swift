//
//  SecretView.swift
//  hundred_list_year
//
//  Created by 渡邊涼太 on 2024/07/14.
//

import SwiftUI

struct SecretView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var tabFlag: Visibility = .hidden
    
    var body: some View {
        ZStack{
            Color.background
            VStack(spacing:20){
                //ヒューマンピクトグラム
                Image("pict")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 130)
                    .padding()
                Text("文字の後ろに隠れていたのに、なぜバレた！？")
                    .foregroundColor(.button)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal,15)
                Text("頼む！ここは見逃してくれ！")
                    .foregroundColor(.button)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal,15)
                Text("代わりといってもなんだが、以下の権利を授けよう。")
                    .foregroundColor(.button)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal,15)
                
                HStack(alignment:.center){
                    Image("AppIconImage1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.gray, lineWidth: 0.5)
                        )
                        .padding()
                    Button{
                        //
                        print("change")
                        if UIApplication.shared.supportsAlternateIcons {
                            UIApplication.shared.setAlternateIconName("AppIcon 1") {error in
                                if let error = error {
                                    print(error.localizedDescription)
                                    return
                                }
                            }
                        }else{
                            print("erorr")
                        }
                    }label:{
                        Text("左のアイコンに変更する")
                            .fontWeight(.bold)
                            .padding()
                            .foregroundColor(.orange)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.orange, lineWidth: 1.0)
                            )
                            .background(Color.white, in: RoundedRectangle(cornerRadius: 15))
                            //.padding(.bottom, 100)
                    }
                    
                }
                Text("通常アイコンはその他 -> アイコン変更にあります")
                    .font(.footnote)
                    .foregroundColor(.red)
            }
        }
        .navigationBarTitle("本の後ろ", displayMode: .inline)
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
//    SecretView()
//}
