//
//  Second_Tab_View.swift
//  hundred_list_year
//
//  Created by 渡邊涼太 on 2024/07/02.
//

import SwiftUI
import RealmSwift

struct SecondTabView: View {
    
    @State var yearList:[String]
    @State var selectedYear: String
    @State var achivement:String = "true"
    @State var showingPopup = false
    @State var showingDeleteAlert = false
    @State var showingEditView = false
    
    @ObservedResults(BucketList.self, sortDescriptor: SortDescriptor(keyPath: "achivement_date", ascending: true)) var bucketLists
    private let tags = ["旅行", "食事", "買い物", "仕事", "勉強・資格", "ヘルスケア", "人間関係", "趣味", "美容", "その他"]
    
    @State var bucketitem: BucketList?
    @State var Deleteitem: BucketList?
    
    //デザイン
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4);
    
    init(){
        let firstYear = UserDefaults.standard.integer(forKey: "firstYear")
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: Date())
        var tmpList = [String]()
        
        
        for appendYear in firstYear...year{
            tmpList.append(String(appendYear))
            //print(tmpList)
        }
        _yearList = State(initialValue: tmpList)
        _selectedYear = State(initialValue: String(year))
        
        
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.customOrange)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
    
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.background
                VStack(alignment:.center){
                    Picker("タグ選択", selection: $selectedYear){
                        ForEach(yearList, id: \.self){ year in
                            Text(year)
                        }
                    }.accentColor(.button)
                        .padding(.vertical, 3)
                        .padding(.horizontal, 5)
                        .background(.white, in: RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1.0)
                        )
                        .padding(.top)
                    
                    //達成率の計算
                    let achivedRealm = bucketLists.where({$0.achievement == true && $0.year == Int(selectedYear)!}).count
                    let totalRealm = bucketLists.where({$0.year == Int(selectedYear)!}).count
                    if !(totalRealm == 0){
                        let roundedRate = round(Double(((achivedRealm*1000) / totalRealm)))/10
                        let output_roundedRate = String(format: "%.1f", roundedRate)
                        Text("達成率\(output_roundedRate)％")
                            .foregroundColor(Color.button)
                    }else{
                        Text("達成率0％")
                            .foregroundColor(Color.button)
                    }
                    
                    Picker("", selection: $achivement){
                        Text("達成済み").tag("true")
                        Text("未達成").tag("false")
                    }.pickerStyle(.segmented)
                        .padding(.horizontal)
                    
                    if Bool(achivement)!{
                        
                        //達成済み一覧表示
                        
                        if !bucketLists.where({$0.year == Int(selectedYear)! && $0.achievement == true}).isEmpty {
                            ScrollView{
                                ForEach(tags, id: \.self){ tag in
                                    //1つのタグに対して表示する、タグにあうアイテムがあるか確認
                                    if !bucketLists.where({$0.tag == tag && $0.year == Int(selectedYear)! && $0.achievement == true}).isEmpty {
                                        //Emptyじゃないなら表示
                                        VStack(alignment: .leading, spacing: 0){
                                            Text(tag)
                                                .padding(.horizontal)
                                                //.background(.gray)
                                                .foregroundColor(.gray)
                                                .fontWeight(.bold)
                                                .cornerRadius(3)
                                                .padding([.leading, .bottom], 3)
                                                .padding(.top, 10)
                                            LazyVGrid(columns: columns){
                                                //                                                ForEach(bucketLists.where({$0.tag == tag && $0.year == Int(selectedYear)! && $0.achievement == true}), id:\.id) { item in
                                                
                                                ForEach(bucketLists ,id:\.id) { item in
                                                    if item.achievement == true{
                                                        if item.tag == tag{
                                                            if item.year == Int(selectedYear)!{
                                                                DisplayItemView(bucket_item: item)
                                                                    .onTapGesture {
                                                                        bucketitem = item
                                                                        withAnimation{
                                                                            showingPopup = true
                                                                        }
                                                                    }
                                                            }
                                                        }
                                                    }
                                                    
                                                }
                                            }
                                        }
                                    }
                                }//tagForEach
                            }//scroll
                        }else{
                            Text("記録がありません")
                                .foregroundColor(Color.button)
                            Spacer()
                        }
                    }else{
                        
                        //未達成一覧表示-----------
                        if !bucketLists.where({$0.year == Int(selectedYear)! && $0.achievement == false}).isEmpty {
                            List{
                                ForEach(bucketLists ,id:\.id) { item in
                                    if item.achievement == false{
                                        if item.year == Int(selectedYear)!{
                                            Text(item.name)
                                        }
                                    }
                                }
                            }//List
                            .listStyle(.inset)
                            .padding(.top)
                        }else{
                            Text("記録がありません")
                                .foregroundColor(Color.button)
                            Spacer()
                        }
                    }
                }
                if showingPopup{
                    if bucketitem != nil{
                        PopUpView(bucket_item: bucketitem!, showPop: $showingPopup, showDeleteAlert: $showingDeleteAlert, showingEditView : $showingEditView)
                    }
                }
            }//ZStack
            .navigationDestination(isPresented: $showingEditView){
                if bucketitem != nil {
                    EditAchievedView(bucket_item: bucketitem!)
                }
            }
            .navigationBarTitle("記録", displayMode: .inline)
            .alert("確認", isPresented: $showingDeleteAlert){
                Button("戻る", role: .cancel){
                }
                Button("削除する", role: .destructive){
                    //データ削除
                    showingPopup = false
                    Deleteitem = bucketitem
                    if Deleteitem != nil{
                        $bucketLists.remove(Deleteitem!)
                        print("delete")
                    }
                }
            }message: {
                Text("本当にデータを削除しますか？")
            }
        }//navigationStack
    }
}

//#Preview {
//    Second_Tab_View()
//}
