//
//  CropPresentTableViewCell.swift
//  BestGen
//
//  Created by Igor Chernobai on 5/21/22.
//

import UIKit

class CropPresentTableViewCell: UITableViewCell {

    private let cropView: GeneSetView = {
        let view = GeneSetView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    func setupView() {
        backgroundColor = .clear

        NSLayoutConstraint.activate(
            [
                cropView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                cropView.topAnchor.constraint(equalTo: contentView.topAnchor),
                cropView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                cropView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),

                heightAnchor.constraint(equalToConstant: 60)
            ]
        )
    }

    func setupCell(crop: Crop) {
        cropView.setupBestCombo(bestCombo: crop)
        setupView()
    }

}
