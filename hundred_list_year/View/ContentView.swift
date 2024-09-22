//
//  ContentView.swift
//  hundred_list_year
//
//  Created by 渡邊涼太 on 2024/07/01.
//

import SwiftUI

struct ContentView: View {
    
    @State var selection_tab = 1
    @ObservedObject  var interstitial = AdmobInterstitialManager()
    
    var body: some View {
        TabView(selection: $selection_tab){
            FirstTabView()
                .tabItem {
                    Label("リスト", systemImage: "person.fill")
                }
                .tag(1)
            
            SecondTabView()
                .tabItem {
                    Label("記録", systemImage: "chart.bar.doc.horizontal.fill")
                }
                .tag(2)
            
            ThirdTabView()
                .tabItem {
                    Label("その他", systemImage: "gear")
                }
                .tag(3)
        }.accentColor(Color.orange)
    }
}

//#Preview {
//    ContentView()
//}
