//
//  DefaultImageView.swift
//  hundred_list_year
//
//  Created by 渡邊涼太 on 2024/07/05.
//

import SwiftUI

struct DefaultImageView: View {
    
    let Default_Image_List = ["imageEx1", "imageEx2", "imageEx3", "imageEx4", "imageEx5", "imageEx6"]
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count:3)
    
    var body: some View {
        
        
        VStack{
            LazyVGrid(columns:columns) {
                ForEach(Default_Image_List, id: \.self){ default_image in
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

//#Preview {
//    DefaultImageView()
//}
