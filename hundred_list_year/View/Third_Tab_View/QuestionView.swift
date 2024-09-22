//
//  QuestionView.swift
//  hundred_list_year
//
//  Created by 渡邊涼太 on 2024/07/07.
//

import SwiftUI

struct QuestionView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var tabFlag: Visibility = .hidden
    
    var body: some View {
        ZStack{
            Color.background
            ScrollView(showsIndicators: false){
                VStack{
                    VStack{
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(Color.orange)
                            .font(.system(size: 100))
                            .padding(.top)
                        Text("100個も作れない！という方へ")
                            .fontWeight(.bold)
                            .padding()
                    }
                    VStack(alignment:.leading){
                        Text("難しいですよね。ただ、本当に些細なことでも大丈夫！例えば、こんなことはどうでしょう。")
                            .foregroundColor(.button)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .padding([.horizontal],30)
                        
                        Text("◻︎ 1年で5冊本を読む")
                            .padding([.horizontal],30)
                            .foregroundColor(.button)
                            .padding(.top, 20)
                        Text("◻︎ りんごを10種類食べる")
                            .padding([.horizontal],30)
                            .foregroundColor(.button)
                        Text("◻︎ 高校の同級生に連絡する")
                            .padding([.horizontal],30)
                            .foregroundColor(.button)
                        Text("◻︎ 転職サイトに登録する")
                            .padding([.horizontal],30)
                            .foregroundColor(.button)
                        Text("◻︎ 推しのライブに行く")
                            .padding([.horizontal],30)
                            .foregroundColor(.button)
                        
                        
                        Text("些細なことだけど、「なんとなく生きてるだけでは踏み出せない、忘れてしまうコト」が良いと思います！")
                            .foregroundColor(.button)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .padding([.horizontal],30)
                            .padding(.top, 20)
                        
                        Text("楽しいこと、頑張りたいこと、気が進まないこと。小さなことから大きなことまで。")
                            .foregroundColor(.button)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .padding([.horizontal],30)
                            .padding(.top, 20)
                        
                        Text("当アプリは編集が可能なので、とりあえず100個考えてみてはいかがでしょうか！")
                            .foregroundColor(.button)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .padding([.horizontal],30)
                            .padding(.top, 20)
                        
                    }
                    
                }
            }
        }
        .navigationBarTitle("アドバイス", displayMode: .inline)
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
//    QuestionView()
//}
