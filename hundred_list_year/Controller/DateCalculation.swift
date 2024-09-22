//
//  DateCalculation.swift
//  hundred_list_year
//
//  Created by 渡邊涼太 on 2024/07/08.
//

import Foundation

//
class DateCalculation {
    
    func date_ToNextYear() -> String {
        let calendar = Calendar.current
        let now = Date()
        let endOfYear = calendar.date(from: DateComponents(year: calendar.component(.year, from: Date()), month: 12, day: 31))!
        
        let rest = calendar.dateComponents([.day], from: now, to:  endOfYear)
        
        //計算上-1される　＆　12/31までの計算のため-1
        return "\(((rest.day ?? 0) + 2))日"
    }
    
    func MonthAndDay(date:Date) -> String {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        
        return "\(month)/\(day)"
    }
}
