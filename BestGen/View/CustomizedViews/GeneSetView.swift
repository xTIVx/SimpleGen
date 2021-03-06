//
//  GeneSetView.swift
//  BestGen
//
//  Created by Igor Chernobai on 5/16/22.
//

import UIKit

class GeneSetView: UIView {

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10

        return stackView
    }()

    init() {
        super.init(frame: CGRect.zero)
        setupView()

        NSLayoutConstraint.activate(
            [
                stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
                stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            ]
        )
    }

    func setupBestCombo(bestCombo: Crop) {

        bestCombo.letters.forEach {
            if $0.comparedGens == nil {
                let letterView = CircledGenLetterView()
                letterView.setupView(letter: $0.key, height: 40)
                self.stackView.addArrangedSubview(letterView)
            } else {
                let doubleletterView = CircledDoubleGenView()
                doubleletterView.setupView(topLetter: $0.key, bottomLetter: $0.comparedGens![0], height: 40)
                self.stackView.addArrangedSubview(doubleletterView)
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(stackView)

        layer.cornerRadius = 10
        layer.borderColor = Constants.Colors.mainGrey.cgColor
        layer.borderWidth = 2
    }
}
