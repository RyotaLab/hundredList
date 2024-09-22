//
//  DefaultImageView.swift
//  hundred_list_year
//
//  Created by 渡邊涼太 on 2024/07/05.
//

import SwiftUI

struct DefaultImageView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var image_name:String
    @Binding var UIImage_frag:Bool
    
    @Binding var Default_image_flag:Bool
    @Binding var Achievement_Edit_flag:Bool
    
    let Default_Image_List = ["imageEx1", "imageEx2", "imageEx3", "imageEx4", "imageEx5", "imageEx6", "imageEx7", "imageEx8", "imageEx9", "imageEx10", "imageEx11"]
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count:3)
    
    var body: some View {
        
        
        VStack{
            LazyVGrid(columns:columns) {
                ForEach(Default_Image_List, id: \.self){ default_image in
                    Button{
                        //Sheetを閉じる
                        if Achievement_Edit_flag{
                            Default_image_flag = false
                        }
                        //選択された画像を変数に代入する
                        image_name = default_image
                        UIImage_frag = false
                        dismiss()
                    }label:{
                        Image("\(default_image)")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(
                                width:UIScreen.main.bounds.size.width / 3 - 10,
                                height:UIScreen.main.bounds.size.width / 3 - 10
                            )
                            .clipped()
                    }
                }
            }
        }
    }
}

//#Preview {
//    DefaultImageView()
//}
