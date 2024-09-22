//
//  LockView.swift
//  hundred_list_year
//
//  Created by 渡邊涼太 on 2024/07/07.
//

import SwiftUI

struct LockView: View {
    
    @State var passCheck: [String?] = [nil, nil, nil, nil]
    @State var isShow = false
    
    let answer = UserDefaults.standard.string(forKey: "password")
    
    let face:FaceAuth = FaceAuth()
    let useFaceID = UserDefaults.standard.bool(forKey: "UseFaceID")
    
    //課金
    @StateObject private var purchaseManager = PurchaseManager()
    
    var body: some View {
        ZStack{
            
            VStack{
                Spacer()
                Text("パスコードの入力")
                    .font(.title3)
                    .fontWeight(.bold)
                //ボタンやらもろもろ
                HStack{
                    //黒丸
                    ForEach(0..<4) { index in
                        if passCheck[index] == nil {
                            Image(systemName: "circle")
                                .padding()
                        }else {
                            Image(systemName: "circle.fill")
                                .padding()
                        }
                    }
                }
                    Spacer()
                //入力ボタン
                
                HStack{
                    ForEach(1..<4){ i in
                        Button{
                            inputText(number: String(i))
                        }label:{
                            Text("\(i)")
                                .font(.title)
                                .frame(width: 90, height: 45)
                                .foregroundColor(Color(.orange))
                                .cornerRadius(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color(.orange), lineWidth: 1.0)
                                )
                        }
                    }
                }
                HStack{
                    ForEach(4..<7){ i in
                        Button{
                            inputText(number: String(i))
                        }label:{
                            Text("\(i)")
                                .font(.title)
                                .frame(width: 90, height: 45)
                                .foregroundColor(Color(.orange))
                                .cornerRadius(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color(.orange), lineWidth: 1.0)
                                )
                        }
                    }
                }
                HStack{
                    ForEach(7..<10){ i in
                        Button{
                            inputText(number: String(i))
                        }label:{
                            Text("\(i)")
                                .font(.title)
                                .frame(width: 90, height: 45)
                                .foregroundColor(Color(.orange))
                                .cornerRadius(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color(.orange), lineWidth: 1.0)
                                )
                        }
                    }
                }
                Button{
                    inputText(number: "0")
                }label:{
                    Text("0")
                        .font(.title)
                        .frame(width: 90, height: 45)
                        .foregroundColor(Color(.orange))
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color(.orange), lineWidth: 1.0)
                        )
                }
                Spacer()
                //入力ボタン終
                .onAppear{
                    //faceidをするかどうか
                    if useFaceID {
                        exec()
                    }
                }
            }
            
            if isShow {
                ContentView()
                    .environmentObject(hundred_list_year.passcodeCheck())
                    .environmentObject(purchaseManager)
                    .environmentObject(hundred_list_year.AdmobInterstitialManager())
                    .transition(.opacity)
            }
        }
    }
    //入力関数
    private func inputText(number : String) {
        var checkAnswer = ""
        
        for (index, getText) in passCheck.enumerated() {
            //nilかチェック　→ 入力済みならスキップ
            //入力したらfor文を抜け出す
            if getText == nil {
                
                passCheck[index] = number
                if index == 3 {
                    for i in 0...3 {
                        
                        checkAnswer = checkAnswer + (passCheck[i] ?? "")
                    }
                    if checkAnswer == answer {
                        //一致
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                            withAnimation{
                                isShow.toggle()
                            }
                        }
                        
                    }else{
                        //初期化
                        passCheck = [nil, nil, nil, nil]
                    }
                }
                
                break
            }
        }
    }
    //顔認証の関数
    func exec() {
        face.auth{ result in
            if result == true {
                passCheck = ["a", "a", "a", "a"]
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                    withAnimation{
                        isShow.toggle()
                    }
                }
            }
        }
    }
}
//#Preview {
//    LockView()
//}
