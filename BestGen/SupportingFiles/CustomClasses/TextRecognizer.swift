//
//  TextRecognizer.swift
//  BestGen
//
//  Created by Igor Chernobai on 6/13/22.
//

import Foundation
import Vision
import UIKit

class TextRecognizer {

    var completion: (([LetterKey]) -> ())?

    func textRecognize(image: UIImage, completion:@escaping (([String])->())) {
        guard let image = image.cgImage else { return }

        // Handler
        let handler = VNImageRequestHandler(cgImage: image)

        // Request
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else { return }
            print("=====================")
            completion(observations.compactMap { $0.topCandidates(1).first?.string }) // recognized text here
        }

        // Process request
        do {
            try handler.perform([request])
        } catch  {
            print(error)
        }
    }
}
