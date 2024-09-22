//
//  DisplayItemView.swift
//  hundred_list_year
//
//  Created by 渡邊涼太 on 2024/07/11.
//

import SwiftUI
import RealmSwift

struct DisplayItemView: View {
    
    //Realm
    @ObservedRealmObject var bucket_item: BucketList
    
    let dateCalculation = DateCalculation()
    
    var body: some View {
        VStack(alignment: .center, spacing: 2){
            
            Text(dateCalculation.MonthAndDay(date: bucket_item.achivement_date))
                .font(.footnote)
                .foregroundColor(.gray)
            Image(uiImage: UIImage(data: bucket_item.imagedata) ?? UIImage(named: "imageEx1")!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(
                    width: UIScreen.main.bounds.size.width / 4 - 11,
                    height: UIScreen.main.bounds.size.width / 4 - 11
                )
                .clipped()
            Text(bucket_item.name)
                .font(.footnote)
                .frame(
                    width: UIScreen.main.bounds.size.width / 4 - 11,
                    height: calculateHeight(for: .body, lineCount: 2)
                )
                .lineLimit(2)
                .truncationMode(.tail)
                .foregroundColor(.buttonSecond)
                .fontWeight(.bold)
        }
        .padding(.horizontal,4)
        .background(Color.white)
            .cornerRadius(5)
    }
    
    
    func calculateHeight(for font: Font, lineCount: Int) -> CGFloat {
        // フォントのポイントサイズを取得
        let uiFont = UIFont.preferredFont(forTextStyle: .body)
        let lineHeight = uiFont.lineHeight
        
        // 行数に基づく高さを計算
        return lineHeight * CGFloat(lineCount)
    }
}

//#Preview {
//    DisplayItemView()
//}
