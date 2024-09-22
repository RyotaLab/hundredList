//
//  AdmobManager.swift
//  hundred_list_year
//
//  Created by 渡邊涼太 on 2024/07/02.
//

import SwiftUI
import UIKit
import GoogleMobileAds

class AdmobInterstitialManager: NSObject, ObservableObject, GADFullScreenContentDelegate {
    // インタースティシャル広告を読み込んだかどうか
    @Published  var interstitialLoaded: Bool = false
    //3回に一回広告が出るように（notificationに記載）
    @Published var AdsOpenCount: Int = 2
    // インタースティシャル広告が格納される
    @Published var interstitialAd: GADInterstitialAd?

    override init() {
        super.init()
    }

    
    // リワード広告の読み込み
    func loadInterstitial() {
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-8712548779253226/1252641682", request: GADRequest()) { (ad, error) in
            if let _ = error {
                print("読み込み失敗")
                self.interstitialLoaded = false
                return
            }
            print("読み込み成功")
            self.interstitialLoaded = true
            self.interstitialAd = ad
            self.interstitialAd?.fullScreenContentDelegate = self
        }
    }

    // インタースティシャル広告の表示
    func presentInterstitial() {
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let root = windowScene?.windows.first!.rootViewController
        
        if let ad = interstitialAd {
            ad.present(fromRootViewController: root!)
            self.interstitialLoaded = false
        } else {
            print("広告の準備ができていません")
            self.interstitialLoaded = false
            self.loadInterstitial()
        }
    }
    // 失敗
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("表示失敗")
        self.loadInterstitial()
    }

    // 成功
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("表示成功")
    }

    // 閉じられた
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("広告が閉じられた")
    }
}
