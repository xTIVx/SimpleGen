//
//  CustomAlert.swift
//  BestGen
//
//  Created by Igor Chernobai on 5/25/22.
//

import Foundation
import UIKit

class CustomAlert {
    func showAlert(parent: UIViewController, alertType: AlertType) {
        var alert: UIAlertController!

        switch alertType {
        case .foundEmptyGene:
            alert = UIAlertController(title: "Found empty gene slot!",
                                      message: "Please fill in all genes or remove whole line.",
                                      preferredStyle: .alert)
        case .noGenes:
            alert = UIAlertController(title: "No crops!",
                                      message: "Please add at least 1 crop to continue.",
                                      preferredStyle: .alert)
        case .preferredCombo:
            alert = UIAlertController(title: "There are unallocated combination points!",
                                      message: "Please indicate all 6 genes in the desired combination.",
                                      preferredStyle: .alert)
        case .addMoreCrops:
            alert = UIAlertController(title: "Can't find any combos!",
                                      message: "Please add more crops",
                                      preferredStyle: .alert)
        case .cantPay:
            alert = UIAlertController(title: "Failed to make a payment!",
                                      message: "Sorry, but you are not allow to make a payment",
                                      preferredStyle: .alert)
        case .noCropsPayment:
            alert = UIAlertController(title: "Maximum crops achived!",
                                      message: "Sorry, in the free version you can use only 5 crops, plz support developer and buy \"Crops\" or \"Full\" package",
                                      preferredStyle: .alert)
        }
        

        alert.view.tintColor = UIColor.black
        alert.view.layer.cornerRadius = 15

        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        parent.present(alert, animated: true)
    }

    enum AlertType {
        case foundEmptyGene
        case noGenes
        case preferredCombo
        case addMoreCrops
        case cantPay
        case noCropsPayment
    }
}
