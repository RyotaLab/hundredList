//
//  PerchaseManager.swift
//  hundred_list_year
//
//  Created by 渡邊涼太 on 2024/07/14.
//

import Foundation
import StoreKit

@MainActor
class PurchaseManager: ObservableObject{
    
    
    //productIdの列挙
    let ConsumableProductIds = ["com.tanabi.100list.ramen", "com.tanabi.100list.gyoza" , "com.tanabi.100list.juice"]
    let NonConsumableProductIds = ["com.tanabi.100list.premiumplan"]
    
    //変更なし
    @Published private(set) var ConsumableProducts: [Product] = []
    @Published private(set) var NonConsumableProducts: [Product] = []
    @Published private(set) var perchased: Bool = false
    
    @Published var donation:Bool = false
    private var productsLoaded = false
    
    init() {
        Task{
            do {
                try await loadProducts()
            }catch{
                print(error)
            }
            await refreshPurchasedProducts()
        }
        
        updates = newTransactionListenerTask()
        //テスト
        print("ロード完了")
    }
    deinit {
        updates?.cancel()
    }
    
    
    //既にid取得済みならスルー、無しなら取得
    func loadProducts() async throws {
        guard !self.productsLoaded else {return}
        self.NonConsumableProducts = try await Product.products(for: NonConsumableProductIds)
        self.ConsumableProducts = try await Product.products(for: ConsumableProductIds)
        self.productsLoaded = true
    }
    
    //商品購入関数
    func purchase(_ product: Product) async throws{
        let result = try await product.purchase()
        
        switch result {
            //購入成功
        case let .success(verificationResult):
            switch verificationResult {
            case let .verified(transaction):
                
                //購入情報の更新
                await refreshPurchasedProducts()
                
                if case .consumable = transaction.productType{
                    //購入が成功したときの処理はこちら
                    print("寄付の処理が行われます")
                    donation = true
                }
                
                if case .nonConsumable = transaction.productType{
                    perchased = true
                    print("perchasedがtrueになりました")
                }
                
                // transaction を終了させる必要がある
                await transaction.finish()
                
            //脱獄端末
            case let .unverified(_, verificationError):
                throw verificationError
            }
            
        //購入に認証が必要なとき（親の端末で子供が購入）
        case .pending:
            break
            
        //ユーザーがキャンセル
        case .userCancelled:
            break
            
        @unknown default:
            break
        }
    }
    
    //タスクの保持
    private var updates: Task<Void, Never>? = nil
    
    private func newTransactionListenerTask() -> Task<Void, Never> {
        Task(priority: .background) {
            for await verificationResult in Transaction.updates {
                guard case.verified(let transaction) = verificationResult,
                      transaction.revocationDate == nil
                else{
                    return
                }
                //購入情報の更新
                await refreshPurchasedProducts()
                
                await transaction.finish()
            }
        }
    }
    
    //最新の購入情報を取得できる
    func refreshPurchasedProducts() async {
        //var purchasedNonConsumables: [Product] = []
        
        for await verificationResult in Transaction.currentEntitlements {
            guard case .verified(let transaction) = verificationResult else {return}
            
            switch transaction.productType {
                
            case .consumable:
                let amount = UserDefaults.standard.integer(forKey: transaction.productID)
                UserDefaults.standard.set(amount+1, forKey: transaction.productID)
                
            case .nonConsumable:
//                guard let product = NonConsumableProducts.first(where: { $0.id == transaction.productID}) else {return}
                
                if NonConsumableProducts.first(where: { $0.id == transaction.productID }) == nil {
                    return
                }
                
                perchased = true
                print(perchased)
                //purchasedNonConsumables.append(product)
            default:
                break
            }
        }
        //purchasedNonConsumableProductList = purchasedNonConsumables
    }
    
    func isPurchased(_ product: Product) async throws -> Bool {
        switch product.type{
        case .nonConsumable:
            return perchased
        default:
            return false
        }
    }
    
}
