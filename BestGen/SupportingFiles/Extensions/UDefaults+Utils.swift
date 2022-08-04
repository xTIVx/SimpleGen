//
//  UDefaults+Utils.swift
//  BestGen
//
//  Created by Igor Chernobai on 8/3/22.
//

import Foundation

extension UserDefaults {
    var getAllCrops: [Crop]? {
          if let crops = UserDefaults.standard.value(forKey: "all_crops") as? Data {
             let decoder = JSONDecoder()
             if let cropsDecoded = try? decoder.decode(Array.self, from: crops) as [Crop] {
                return cropsDecoded
             } else {
                return nil
             }
          } else {
             return nil
          }
       }

    func saveAllCrops(allCrops: [Crop]) {
        UserDefaults.standard.removeObject(forKey: "all_crops")
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(allCrops){
            UserDefaults.standard.set(encoded, forKey: "all_crops")
        }
    }

}
