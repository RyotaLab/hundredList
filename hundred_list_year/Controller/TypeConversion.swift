//
//  TypeConversion.swift
//  hundred_list_year
//
//  Created by 渡邊涼太 on 2024/07/06.
//

import Foundation
import SwiftUI

class TypeConversion {
    
    func UIImageToData(uiimage:UIImage) -> Data{
        let data = uiimage.pngData()
        return data!
    }
    
    func DataToUIImage(data: Data) -> UIImage{
        let uiimage = UIImage(data:data)
        return uiimage!
    }
    
}
