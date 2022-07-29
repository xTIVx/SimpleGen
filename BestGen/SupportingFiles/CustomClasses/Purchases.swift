//
//  Purchases.swift
//  BestGen
//
//  Created by Igor Chernobai on 5/25/22.
//

import Combine
import Foundation
import StoreKit

final class Purchases: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    var delegate: UIViewController
    var purchaseCompletion: (() -> ())?

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
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                   let product = Product(rawValue: transaction.payment.productIdentifier) {
                    UserDefaults.standard.set(transaction.payment.productIdentifier, forKey: "ProductStatus")
                    appDelegate.purchaseStatus = product
                    print("Purchased")
                    purchaseCompletion?()
                }
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                print("Failed")
            case .restored:
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                   let product = Product(rawValue: transaction.payment.productIdentifier) {
                    UserDefaults.standard.set(transaction.payment.productIdentifier, forKey: "ProductStatus")
                    appDelegate.purchaseStatus = product
                }
            case .deferred:
                print("Deferred")
            default:
                break
            }
        }
    }

    func restorePayment() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}
