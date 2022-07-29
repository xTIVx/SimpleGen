//
//  PurchasesViewController.swift
//  BestGen
//
//  Created by Igor Chernobai on 5/24/22.
//

import UIKit
import Combine

class PurchasesViewController: UIViewController {

    private var store: Purchases?
    private var cancellable: Set<AnyCancellable> = []


    init() {
        super.init(nibName: nil, bundle: nil)
        self.store = Purchases(delegate: self)

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.$purchaseStatus
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] newStatus in
                    self?.currentStatusLabel.text = "Current status: \(Product(rawValue: newStatus.rawValue)!)"
                })
                .store(in: &cancellable)
        }
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
        button.tag = 17

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
        label.text = "We appreciate your support!"
        label.font = Constants.Fonts.letterTitle?.withSize(23)
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
        let view = PurchaseView(productTitle: "Unlock Crops Limit", price: 2.99)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.buttonTappedCompletion = {}

        return view
    }()

    private let fullVersionView: PurchaseView = {
        let view = PurchaseView(productTitle: "Full (ADS + Crops limit)", price: 4.99)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.buttonTappedCompletion = {}

        return view
    }()

    private let currentStatusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors.mainWhite
        label.font = Constants.Fonts.letterTitle?.withSize(20)
        label.numberOfLines = 0

        return label
    }()

    private let restorePaymentButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        var config = UIButton.Configuration.gray()
        config.baseBackgroundColor = Constants.Colors.mainGreen
        config.buttonSize = .medium
        button.configuration = config
        let attributedString = NSAttributedString(string: "Restore payment", attributes:
                                                    [
                                                        NSAttributedString.Key.foregroundColor: UIColor.white,
                                                        NSAttributedString.Key.font: Constants.Fonts.subTitle?.withSize(15) ?? UIFont(),

                                                    ]
        )
        button.setAttributedTitle(attributedString, for: .normal)
        button.tag = 18
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        return button
    }()

    


    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraints()
        setupPurchases()
    }

    @objc func buttonTapped(sender: UIButton) {
        if sender.tag == 17 {
            dismiss(animated: true)
        } else if sender.tag == 18 {
            if let store = self.store {
                store.restorePayment()
            }
        }
    }
}

extension PurchasesViewController {
    func setupPurchases() {
        cropsLimitView.buttonTappedCompletion? = {
            if let store = self.store  {
                store.startPayment(product: .Crops)
            }
        }
        removeAdsView.buttonTappedCompletion? = {
            if let store = self.store  {
                store.startPayment(product: .Ads)
            }
        }
        fullVersionView.buttonTappedCompletion? = {
            if let store = self.store  {
                store.startPayment(product: .Full)
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
        view.addSubview(currentStatusLabel)
        view.addSubview(restorePaymentButton)

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

                currentStatusLabel.topAnchor.constraint(equalTo: fullVersionView.bottomAnchor, constant: 30),
                currentStatusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

                restorePaymentButton.topAnchor.constraint(equalTo: currentStatusLabel.bottomAnchor, constant: 20),
                restorePaymentButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ]
        )
    }
}

