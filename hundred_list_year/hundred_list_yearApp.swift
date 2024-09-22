//
//  hundred_list_yearApp.swift
//  hundred_list_year
//
//  Created by 渡邊涼太 on 2024/07/01.
//

import SwiftUI
import GoogleMobileAds
import UIKit

@main
struct hundred_list_yearApp: App {
    
    @StateObject private var purchaseManager = PurchaseManager()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let SetPass = UserDefaults.standard.bool(forKey: "SetPass")
    
    var body: some Scene {
        WindowGroup {
            
            if SetPass{
                LockView()
            }else{
                ContentView()
                    .environmentObject(passcodeCheck())
                    .environmentObject(purchaseManager)
                    .environmentObject(AdmobInterstitialManager())
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        
        let notFirstLaunch = UserDefaults.standard.bool(forKey: "notfirstLaunch")
        if !notFirstLaunch {
            let calendar = Calendar.current
            let year = calendar.component(.year, from: Date())
            
            UserDefaults.standard.set(year, forKey: "firstYear")
            UserDefaults.standard.set(true, forKey: "notfirstLaunch")
        }
        //Google広告の初期化
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        return true
    }
    
}
