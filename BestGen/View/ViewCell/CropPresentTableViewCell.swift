//
//  CropPresentTableViewCell.swift
//  BestGen
//
//  Created by Igor Chernobai on 5/21/22.
//

import UIKit

class CropPresentTableViewCell: UITableViewCell {

    static let identifier = "cropPresentCell"

    private let cropView: GeneSetView = {
        let view = GeneSetView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = .none
        view.layer.borderWidth = 0

        return view
    }()

    func setupView() {
        backgroundColor = .clear
        contentView.addSubview(cropView)

        NSLayoutConstraint.activate(
            [
                cropView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
                cropView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
                cropView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                cropView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            ]
        )
    }

    func setupCell(crop: Crop) {
        cropView.setupBestCombo(bestCombo: crop)
        setupView()
    }
}
