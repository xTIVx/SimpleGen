//
//  PurchasesViewController.swift
//  BestGen
//
//  Created by Igor Chernobai on 5/24/22.
//

import UIKit

class PurchasesViewController: UIViewController {

    private var store: Purchases?

    init() {
        super.init(nibName: nil, bundle: nil)
        self.store = Purchases(delegate: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors.mainWhite
        label.text = "Welcome Message"
        label.font = Constants.Fonts.letterTitle
        label.numberOfLines = 0

        return label
    }()

    private let removeAdsView: PurchaseView = {
        let view = PurchaseView(productTitle: "Remove ADS", price: 2.99)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.buttonTappedCompletion = {}

        return view
    }()

    private let cropsLimitView: PurchaseView = {
        let view = PurchaseView(productTitle: "Unlock Crops Cimit", price: 2.99)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.buttonTappedCompletion = {}

        return view
    }()

    private let fullVersionView: PurchaseView = {
        let view = PurchaseView(productTitle: "ADS + Crops limit", price: 4.99)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.buttonTappedCompletion = {}

        return view
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraints()
        setupPurchases()
    }

    @objc func buttonTapped() {
        dismiss(animated: true)
    }
}

extension PurchasesViewController {
    func setupPurchases() {
        cropsLimitView.buttonTappedCompletion? = {
            if let store = self.store  {
                store.startPayment(product: .crops)
            }
        }
        removeAdsView.buttonTappedCompletion? = {
            if let store = self.store  {
                store.startPayment(product: .ads)
            }
        }
        fullVersionView.buttonTappedCompletion? = {
            if let store = self.store  {
                store.startPayment(product: .full)
            }
        }

        store?.purchaseCompletion = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
    }

    func setupView() {
        view.backgroundColor = Constants.Colors.background

        view.addSubview(closeWindowButton)
        view.addSubview(separator)
        view.addSubview(welcomeLabel)
        view.addSubview(removeAdsView)
        view.addSubview(cropsLimitView)
        view.addSubview(fullVersionView)

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

                welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                welcomeLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 30),

                removeAdsView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 30),
                removeAdsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                removeAdsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

                cropsLimitView.topAnchor.constraint(equalTo: removeAdsView.bottomAnchor, constant: 20),
                cropsLimitView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                cropsLimitView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

                fullVersionView.topAnchor.constraint(equalTo: cropsLimitView.bottomAnchor, constant: 20),
                fullVersionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                fullVersionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            ]
        )
    }
}
