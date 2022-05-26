//
//  Purchases.swift
//  BestGen
//
//  Created by Igor Chernobai on 5/25/22.
//

import Foundation
import StoreKit

class Purchases: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    static var purchaseStatus: Product {
        get {
            if let rawValue = UserDefaults.standard.string(forKey: "ProductStatus"),
            let productStatus = Product(rawValue: rawValue) {
                return productStatus
            } else {
                return .free
            }
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "ProductStatus")
        }
    }

    var delegate: UIViewController

    init(delegate: UIViewController) {
        self.delegate = delegate
    }

    func purchase(product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)

    }

    func startPayment(product: Product) {
        if SKPaymentQueue.canMakePayments() {
            let set: Set<String> = [product.rawValue]
            let productRequest = SKProductsRequest(productIdentifiers: set)
            productRequest.delegate = self
            productRequest.start()
        } else {
            lazy var alert = CustomAlert()
            alert.showAlert(parent: self.delegate, alertType: .cantPay)
        }
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let product = response.products.first {
            print("Product is available")
            self.purchase(product: product)
        } else {
            print("Product is not available")
        }
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { transaction in

            switch transaction.transactionState {
            case .purchasing:
                print("Purchasing")
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                print("Purchased")
                UserDefaults.standard.set(transaction.payment.productIdentifier, forKey: "ProductStatus")
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                print("Failed")
            case .restored:
                print("Restored")
            case .deferred:
                print("Deferred")
            default:
                break
            }
        }
    }
}
