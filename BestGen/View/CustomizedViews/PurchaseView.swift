//
//  PurchaseView.swift
//  BestGen
//
//  Created by Igor Chernobai on 5/24/22.
//

import UIKit

class PurchaseView: UIView {

    var buttonTappedCompletion: (() -> ())?

    private let productTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors.mainWhite
        label.font = Constants.Fonts.subTitle

        return label
    }()

    private let payButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        var config = UIButton.Configuration.gray()
        config.baseBackgroundColor = Constants.Colors.mainGreen
        config.buttonSize = .medium
        button.configuration = config
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        return button
    }()

    private let separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.Colors.mainGrey

        return view
    }()

    init(productTitle: String, price: Float) {
        self.productTitleLabel.text = productTitle
        let attributedString = NSAttributedString(string: "$\(price)", attributes:
                                                    [
                                                        NSAttributedString.Key.foregroundColor: UIColor.white,
                                                        NSAttributedString.Key.font: Constants.Fonts.subTitle?.withSize(15) ?? UIFont(),

                                                    ]
        )
        payButton.setAttributedTitle(attributedString, for: .normal)

        super.init(frame: CGRect.zero)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        backgroundColor = .clear
        isUserInteractionEnabled = true
        
        addSubview(separator)
        addSubview(productTitleLabel)
        addSubview(payButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                separator.heightAnchor.constraint(equalToConstant: 1),
                separator.leadingAnchor.constraint(equalTo: leadingAnchor),
                separator.trailingAnchor.constraint(equalTo: trailingAnchor),
                separator.bottomAnchor.constraint(equalTo: bottomAnchor),

                productTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                productTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

                payButton.centerYAnchor.constraint(equalTo: centerYAnchor),
                payButton.trailingAnchor.constraint(equalTo: trailingAnchor),

                heightAnchor.constraint(equalToConstant: 50)

            ]
        )
    }

    @objc func buttonTapped() {
        buttonTappedCompletion?()
    }
}
