//
//  PremiumPlanView.swift
//  hundred_list_year
//
//  Created by 渡邊涼太 on 2024/07/07.
//

import SwiftUI
import StoreKit

struct PremiumPlanView: View {
    
    @EnvironmentObject private var purchaseManager: PurchaseManager
    
    @Environment(\.dismiss) var dismiss
    @State var tabFlag: Visibility = .hidden
    
    var isPurchased: Bool
    
    //購入されたらtrueになる
    @State var getStatus:Bool = false
    @State var flag :Bool = false
    
    @State var isRestorationTrue:Bool = false
    @State var isRestorationFalse:Bool = false
    
    var body: some View {
        ZStack{
            Color.background
            ScrollView(showsIndicators: false){
                Button{
                    Task {
                        do {
                            try await AppStore.sync()
                            let verificationResult = await Transaction.currentEntitlement(for: "com.tanabi.100list.premiumplan")
                            if case .verified = verificationResult {
                                // 復元が成功した場合の処理
                                isRestorationTrue = true
                            } else {
                                // 復元が失敗した場合の処理
                                isRestorationFalse = true
                            }
                        } catch {
                            // 復元が失敗した場合の処理
                            isRestorationFalse = true
                        }
                    }
                }label:{
                    Text("購入情報を復元")
                        .padding(.top, 40)
                        .foregroundColor(.blue)
                    
                }
                
                Image("premiumLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
                    .padding(.top)
                
                Text("980円")
                    .foregroundColor(Color.button)
                    .padding(.top)
                
                Text("（買い切り型）")
                    .foregroundColor(Color.button)
                
                Image("premium1")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(15)
                    .padding()
                    
                Image("premium2")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(15)
                    .padding()
                    .padding(.bottom, 120)
            
            }
            
            VStack{
                Spacer()
                if isPurchased{
                    Text("購入済み")
                        .bold()
                        .frame(width: 170, height: 60)
                        .background(Color.gray)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 5, x: 0, y: 3)
                        .padding(.bottom, 45)
                }else{
                    Button{
                        //プレミアムプランの購入処理
                        Task{
                            if purchaseManager.NonConsumableProducts.isEmpty{
                                print("中身がないerrorです")
                            }else{
                                await NonConsumablePurchase(product: purchaseManager.NonConsumableProducts[0])
                            }
                        }
                    }label:{
                        Text("購入する（980円）")
                            .bold()
                            .frame(width: 170, height: 60)
                            .background(getStatus ? Color.gray: Color.orange)
                            .foregroundColor(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .gray, radius: 5, x: 0, y: 3)
                            .padding(.bottom, 45)
                    }
                }
            }
        }//ZStack
        .navigationBarTitle("プレミアムプランを購入", displayMode: .inline)
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
        
        .alert("購入情報の復元に成功しました", isPresented: $isRestorationTrue){
            Button("OK", role: .cancel){
            }
        }message:{
        }
        
        .alert("購入情報の復元に失敗しました", isPresented: $isRestorationFalse){
            Button("OK", role: .cancel){
            }
        }message:{
            Text("過去に購入情報がありませんでした。")
        }
    }
    
    func NonConsumablePurchase(product: Product) async {
        do{
            //購入
            try await purchaseManager.purchase(product)
            getStatus = try await purchaseManager.isPurchased(product)
        }catch{
            print("非消費型の購入に失敗しました")
        }
    }
}

//#Preview {
//    PremiumPlanView()
//}
