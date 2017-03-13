//
//  DateManager.swift
//  Calendar
//
//  Created by Justin Huang on 2017/2/11.
//  Copyright © 2017年 Justin Huang. All rights reserved.
//

import Foundation
class DateManager{
    //輸入日期轉成Component再回傳現在月份
    static func nowMonth(date:Date) -> Int{
        let calendar = Calendar.current
        let component = calendar.dateComponents([.year,.month,.day,.weekday,.weekOfMonth,.weekOfYear], from: date)
        return component.month!
    }
    //輸入日期轉成Component再回傳現在年
    static func nowYear(date:Date) -> Int{
        let calendar = Calendar.current
        let component = calendar.dateComponents([.year,.month,.day,.weekday,.weekOfMonth,.weekOfYear], from: date)
        return component.year!
    }
    //輸入日期轉成Component再回傳現在星期幾
    static func nowWeekDay(date:Date) -> Int{
        let calendar = Calendar.current
        let component = calendar.dateComponents([.year,.month,.day,.weekday,.weekOfMonth,.weekOfYear], from: date)
        return component.weekday!
    }
    //輸入日期轉成Component再回傳現在幾時
    static func nowHour(date:Date) -> Int{
        let calendar = Calendar.current
        let component = calendar.dateComponents([.year,.month,.day,.hour,.weekday,.weekOfMonth,.weekOfYear], from: date)
        return component.hour!
    }
}
