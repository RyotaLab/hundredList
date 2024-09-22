//
//  Third_Tab_View.swift
//  hundred_list_year
//
//  Created by 渡邊涼太 on 2024/07/02.
//

import SwiftUI
import StoreKit

enum ThirdPagePass {
    case lock1
    case lock2
}

struct ThirdTabView: View {
    
    //課金
    @EnvironmentObject private var purchaseManager: PurchaseManager
    
    //path
    @State private var navigatePath: [ThirdPagePass] = []
    
    //何もない時はfalse
    @State var toggle = UserDefaults.standard.bool(forKey: "SetPass")
    @State var evaluation_alart = false
    @State var evaluation_alart_next = false
    
    @Environment(\.openURL) var openURL
    
    var body: some View {
        NavigationStack(path: $navigatePath) {
            ZStack{
                Color.background
                List{
                    Section(header: Text("設定")){
                        //Lock画面へ
                        HStack{
                            Text("\(Image(systemName: "lock"))")
                                .foregroundColor(.orange).frame(width:30)
                            Toggle("パスコードの設定",isOn: $toggle)
                                .foregroundColor(Color.button)
                                .frame(height: 37)
                                .tint(toggle ? .orange: .gray)
                                .onAppear{
                                    toggle = UserDefaults.standard.bool(forKey: "SetPass")
                                }
                                .onChange(of: toggle) {
                                    if toggle {
                                        //パスワード設定画面へ
                                        navigatePath.append(.lock1)
                                    }else{
                                        //pass解除
                                        UserDefaults.standard.set(false, forKey: "SetPass")
                                        UserDefaults.standard.set(false, forKey: "UseFaceID")
                                    }
                                }
                            
                        }//HStack
                    }//Section
                    Section(header: Text("その他")){
                        
                        //アプリ評価---------------------------
                        Button{
                            //requestReview()
                            evaluation_alart = true
                        }label:{
                            HStack{
                                Text("\(Image(systemName: "star"))")
                                    .foregroundColor(.orange).frame(width:30)
                                Text("アプリを評価する")
                                    .foregroundColor(Color.button)
                                    .frame(height: 37)
                            }
                        }
                        
                        //プレミアムプランViewへ---------------------------
                        NavigationLink {
                            if purchaseManager.perchased{
                                //購入済み
                                PremiumPlanView(isPurchased: true)
                            }else{
                                PremiumPlanView(isPurchased: false)
                            }
                        } label: {
                            HStack{
                                Text("\(Image(systemName: "sparkles"))")
                                    .foregroundColor(.yellow).frame(width:30)
                                Text("プレミアムプラン")
                                    .foregroundColor(Color.button)
                                    .frame(height: 37)
                            }
                        }
                        
                        
                        //アイコン変更Viewへ---------------------------
                        NavigationLink{
                            if purchaseManager.perchased{
                                IconChangeView(isPurchased: true)
                            }else{
                                IconChangeView(isPurchased: false)
                            }
                        }label:{
                            HStack{
                                Text("\(Image(systemName: "wand.and.stars.inverse"))")
                                    .foregroundColor(.orange).frame(width:30)
                                Text("アイコン変更")
                                    .foregroundColor(Color.button)
                                    .frame(height: 37)
                            }
                        }
                        
                        
                        //寄付Viewへ---------------------------
                        NavigationLink(destination: DonationView()) {
                            HStack{
                                Text("\(Image(systemName: "takeoutbag.and.cup.and.straw"))")
                                    .foregroundColor(.orange).frame(width:30)
                                Text("開発者に奢る")
                                    .foregroundColor(Color.button)
                                    .frame(height: 37)
                            }
                        }
                    }
                    
                    Section(header:Text("管理")) {
                        
                        NavigationLink(destination: QuestionView()) {
                            HStack{
                                Text("\(Image(systemName: "questionmark.app"))")
                                    .foregroundColor(.orange).frame(width:30)
                                Text("100個も書けない方へ")
                                    .foregroundColor(Color.button)
                                    .frame(height: 37)
                            }
                        }
                        
                        Link(destination:URL(string: "https://forms.gle/UTQBe7bNW8y1v4RB7")!, label: {
                            HStack{
                                Text("\(Image(systemName: "link"))")
                                    .foregroundColor(.orange).frame(width:30)
                                Text("要望または不具合報告")
                                    .foregroundColor(Color.button)
                                    .frame(height: 37)
                            }
                            
                        })
                        
                    }
                }//List
                .scrollContentBackground(.hidden)
            }//ZStack
            .navigationDestination(for: ThirdPagePass.self){ value in
                switch value {
                    
                case .lock1:
                    SetLockView1(path: $navigatePath)
                case .lock2:
                    SetLockView2(path: $navigatePath)
                }
            }
            .navigationBarTitle("設定", displayMode: .inline)
            .alert("使い心地はいかがですか？", isPresented: $evaluation_alart){
                Button("満足", role: .cancel){
                    requestReview()
                }
                Button("不満", role: .destructive){
                    evaluation_alart_next = true
                }
            }message:{
            }
            
            .alert("ご満足いただけず申し訳ございません", isPresented: $evaluation_alart_next){
                Button("YES", role: .cancel){
                    openURL(URL(string: "https://forms.gle/UTQBe7bNW8y1v4RB7")!)
                }
                Button("NO", role: .destructive){
                    
                }
            }message:{
                Text("ご意見を頂けませんか？")
            }
        }//navigationstack
        
    }
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

//#Preview {
//    Third_Tab_View()
//}
