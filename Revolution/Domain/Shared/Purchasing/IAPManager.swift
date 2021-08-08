//
//  IAPManager.swift
//  Revolution
//
//  Created by Hoang Hai on 19/07/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import Foundation
import StoreKit
import RxSwift

let premiumProductID = "com.photo.yummy_photo.premium"

typealias BuyProductHandler = ((Result<Bool, Error>) -> Void)
typealias OnReceivedProductsHandler = ((Result<[SKProduct], RevolutionError>) -> Void)
typealias OnProductRestoreHandler = ((Int) -> Void)

class IAPManager: NSObject {
    
    static let shared = IAPManager()
    
    var onReceiveProductsHandler: OnReceivedProductsHandler?
    
    var onBuyProductHandler: BuyProductHandler?
    
    var onProductRestoreHandler: OnProductRestoreHandler?
    
    var totalRestoredPurchases = 0
    
    var premiumProducts: [SKProduct] = []
    
    private override init() {
        super.init()
    }
    
    private func getProductIDs() -> [String] {
        return [premiumProductID]
    }
    
    func getProducts(withHandler productsReceiveHandler: @escaping (_ result: Result<[SKProduct], RevolutionError>) -> Void) {
        onReceiveProductsHandler = productsReceiveHandler
        let productIDs = getProductIDs()
        guard !productIDs.isEmpty else {
            productsReceiveHandler(.failure(.noProductIDsFound))
            return
        }
     
        let request = SKProductsRequest(productIdentifiers: Set(productIDs))
     
        request.delegate = self
     
        request.start()
    }
    
    func startObserving() {
        SKPaymentQueue.default().add(self)
    }
    
    func stopObserving() {
        SKPaymentQueue.default().remove(self)
    }
    
    func buy(product: SKProduct, withHandler handler: @escaping ((_ result: Result<Bool, Error>) -> Void)) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
     
        onBuyProductHandler = handler
    }
    
    func restorePurchases(withHandler handler: @escaping OnProductRestoreHandler) {
        onProductRestoreHandler = handler
        totalRestoredPurchases = 0
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func verifyReceipt() {
        guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
              FileManager.default.fileExists(atPath: appStoreReceiptURL.path) else {
            return
        }
        let userDefault = UserDefaults.standard
        do {
            let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
            let receiptString = receiptData.base64EncodedData(options: [])
            userDefault.setValue(!receiptString.isEmpty, forKey: "isPurchased")
            YummyPhotoApplication.shared.isPurchased = !receiptString.isEmpty
        } catch {
            print("Could not read receipt data with error!!!!: " + error.localizedDescription)
            userDefault.setValue(false, forKey: "isPurchased")
            YummyPhotoApplication.shared.isPurchased = false
        }
    }
    
}

extension IAPManager: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        if products.count > 0 {
            premiumProducts = products
            onReceiveProductsHandler?(.success(products))
        } else {
            onReceiveProductsHandler?(.failure(.noProductsFound))
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        onReceiveProductsHandler?(.failure(.productRequestFailed))
    }
    
    func requestDidFinish(_ request: SKRequest) {
        print("Request did finish!")
    }
    
    func canMakePayment() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
}

extension IAPManager: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { transaction in
            switch transaction.transactionState {
            case .purchased:
                onBuyProductHandler?(.success(true))
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                totalRestoredPurchases += 1
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                if let error = transaction.error as? SKError {
                    if error.code != .paymentCancelled {
                        onBuyProductHandler?(.failure(error))
                    } else {
                        onBuyProductHandler?(.failure(RevolutionError.paymentWasCancelled))
                    }
                    print("IAP Error:", error.localizedDescription)
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            case .deferred, .purchasing: break
            @unknown default: break
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        onProductRestoreHandler?(totalRestoredPurchases)
    }
    
}
