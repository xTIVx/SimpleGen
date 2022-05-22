//
//  ResultViewController.swift
//  BestGen
//
//  Created by Igor Chernobai on 5/16/22.
//

import UIKit

class ResultViewController: UIViewController {

    var viewModel: ResultViewModel!

    private lazy var closeWindowButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold, scale: .large)
        button.setImage(UIImage(systemName: "xmark",withConfiguration: config), for: .normal)
        button.tintColor = Constants.Colors.mainRed
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        return button
    }()

    private let separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.Colors.mainGrey

        return view
    }()

    private let bestComboLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors.mainWhite
        label.text = "Your best combo is:"
        label.font = Constants.Fonts.subTitle

        return label
    }()

    private let bestComboView: GeneSetView = {
        let view = GeneSetView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let useNextCropsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors.mainWhite
        label.text = "Use next crops:"
        label.font = Constants.Fonts.subTitle

        return label
    }()

    init(allCrops: [Crop], preferredCombo: [LetterKey: Int] ) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = ResultViewModel(allCrops: allCrops, preferredCombo: preferredCombo)

        let match = self.viewModel.compareBestCrops()
        if match.count == 1 {
            bestComboLabel.text = "We found perfect match for you!"
            bestComboView.setupBestCombo(bestCombo: match.first!)
        } else if match.count > 1 {
            bestComboLabel.text = "Here all possible good combinations:"
            bestComboView.setupBestCombo(bestCombo: match.last!)
        } else {
            bestComboLabel.text = "We don't have any good combinations for you, add more crops!"
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }

    @objc func buttonTapped() {
        dismiss(animated: true)
    }

}

extension ResultViewController {
    func setupView() {
        view.backgroundColor = Constants.Colors.background

        view.addSubview(closeWindowButton)
        view.addSubview(separator)
        view.addSubview(bestComboLabel)
        view.addSubview(bestComboView)
        view.addSubview(useNextCropsLabel)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                closeWindowButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
                closeWindowButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),

                separator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                separator.topAnchor.constraint(equalTo: closeWindowButton.topAnchor, constant: 40),
                separator.heightAnchor.constraint(equalToConstant: 1),
                separator.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.65),

                bestComboLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 20),
                bestComboLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),

                bestComboView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                bestComboView.topAnchor.constraint(equalTo: bestComboLabel.bottomAnchor, constant: 20),
                bestComboView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

                useNextCropsLabel.topAnchor.constraint(equalTo: bestComboView.bottomAnchor, constant: 20),
                useNextCropsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            ]
        )
    }
}
