//
//  ViewController.swift
//  BestGen
//
//  Created by Igor Chernobai on 5/7/22.
//

import UIKit
import Foundation
import GoogleMobileAds

class MainViewController: UIViewController {

    private let viewModel: MainViewModel = MainViewModel()
    private var ads: Ads?

    private var mainRewardedAd: GADRewardedAd?
    private var bottomBannerAd: GADBannerView?

    private let removeAds: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedString = NSAttributedString(string: "Remove ADS", attributes:
                                                    [
                                                        NSAttributedString.Key.font: Constants.Fonts.subTitle ?? UIFont(),
                                                        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                                                    ]
        )
        button.setAttributedTitle(attributedString, for: .normal)
        button.setTitleColor(Constants.Colors.mainGreen, for: .normal)
        button.tag = 200

        return button
    }()

    private let firstActionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors.mainWhite
        label.text = "1. Add all your crop genes:"
        label.font = Constants.Fonts.subTitle

        return label
    }()

    private let secondActionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors.mainWhite
        label.text = "2. Choose desired combination:"
        label.font = Constants.Fonts.subTitle

        return label
    }()

    private let listView: UIView = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.layer.borderColor = Constants.Colors.mainGrey.cgColor
        view.layer.borderWidth = 3
        view.layer.cornerRadius = 10

        let separator = UIView(frame: CGRect(x: 0, y: 20, width: view.bounds.size.width / 2, height: 1))
        separator.backgroundColor = Constants.Colors.mainGrey
        view.addSubview(separator)
        return view
    }()

    private let separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.Colors.mainGrey

        return view
    }()

    private let addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .large)
        let largeBoldDoc = UIImage(systemName: "plus.square", withConfiguration: largeConfig)
        button.setImage(largeBoldDoc, for: .normal)
        button.tintColor = Constants.Colors.mainWhite
        button.blinkTintColor()
        button.tag = 100

        return button
    }()

    private let clearButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedString = NSAttributedString(string: "Clear", attributes:
                                                    [
                                                        NSAttributedString.Key.foregroundColor: Constants.Colors.mainRed,
                                                        NSAttributedString.Key.font: Constants.Fonts.subTitle ?? UIFont(),
                                                    ]
        )
        button.setAttributedTitle(attributedString, for: .normal)
        button.tintColor = Constants.Colors.mainWhite
        button.isHidden = true
        button.tag = 99

        return button
    }()

    private let listOfCropsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none

        return tableView
    }()

    private let popup: ChooseGenPopup = {
        let pop = ChooseGenPopup()
        pop.translatesAutoresizingMaskIntoConstraints = false
        pop.isHidden = true

        return pop
    }()

    private let preferredPatternView: PreferredPatternView = {
        let view = PreferredPatternView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let calculateButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedString = NSAttributedString(string: "Calculate", attributes:
                                                    [
                                                        NSAttributedString.Key.foregroundColor: UIColor.white,
                                                        NSAttributedString.Key.font: Constants.Fonts.subTitle?.withSize(25) ?? UIFont(),

                                                    ]
        )
        button.setAttributedTitle(attributedString, for: .normal)
        var config = UIButton.Configuration.gray()
        config.baseBackgroundColor = Constants.Colors.mainGreen
        config.buttonSize = .large
        button.configuration = config
        button.tag = 101


        return button
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        if Purchases.purchaseStatus == .free || Purchases.purchaseStatus == .crops {

            ads = Ads(delegate: self)
            mainRewardedAd = ads?.createRewardedAd()
            bottomBannerAd = ads?.createSmallBanner(adUnitID: "ca-app-pub-3940256099942544/2934735716") //Constants.AdIdentifiers.bottomAd
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        preferredPatternView.preferredCombo = viewModel.getPreferredCombo()
        preferredPatternView.comboDidChange = { newValue in
            self.viewModel.updatePreferredCombo(combo: newValue)
        }
        if let ads = self.ads {
            ads.loadRewardedAd(withAdUnitID: "ca-app-pub-3940256099942544/1712485313") { [weak self] ad in
                guard let self = self, let ad = ad else { return }
                self.mainRewardedAd = ad
                self.mainRewardedAd!.fullScreenContentDelegate = self
            }
        }
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 99:
            viewModel.removeAllCrops()
            clearButton.isHidden = true
            listOfCropsTableView.reloadData()
        case 100:
            if Purchases.purchaseStatus == .crops || Purchases.purchaseStatus == .full {
                viewModel.addCropRow()
                clearButton.isHidden = false
                listOfCropsTableView.reloadData()
            } else {
                if viewModel.getSamplesCount() >= 5 {
                    CustomAlert().showAlert(parent: self, alertType: .noCropsPayment) {
                        self.present(PurchasesViewController(), animated: true)
                    }
                } else {
                    viewModel.addCropRow()
                    clearButton.isHidden = false
                    listOfCropsTableView.reloadData()
                }
            }
        case 101:
            let alert = CustomAlert()
            if viewModel.getSamplesCount() == 0 {
                alert.showAlert(parent: self, alertType: .noGenes)
            } else if viewModel.getPreferredCombo().values.reduce(0, { $0 + $1 }) != 6 {
                alert.showAlert(parent: self, alertType: .preferredCombo)
            } else if viewModel.isAllLettersAreSet() {
                if Purchases.purchaseStatus == .free || Purchases.purchaseStatus == .crops {
                    if let rewardedAd = self.mainRewardedAd {
                        ads?.showRewardedAd(rewardedAd: rewardedAd)
                    }
                } else {
                    if let crop = viewModel.getTopCrop() {
                        present(ResultViewController(crop: crop), animated: true)
                    } else {
                        CustomAlert().showAlert(parent: self, alertType: .addMoreCrops)
                    }
                }
            } else {
                alert.showAlert(parent: self, alertType: .foundEmptyGene)
            }
        case 200:
            present(PurchasesViewController(), animated: true)
        default:
            break
        }
    }

    private func removeRow(at indexPath: IndexPath) {
        listOfCropsTableView.beginUpdates()
        viewModel.removeCrop(at: indexPath.row)
        listOfCropsTableView.deleteRows(at: [indexPath], with: .automatic)
        listOfCropsTableView.reloadData()
        listOfCropsTableView.endUpdates()
    }
}

private extension MainViewController {

    func setupView() {
        view.backgroundColor = Constants.Colors.background
        addButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        calculateButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        removeAds.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        listOfCropsTableView.delegate = self
        listOfCropsTableView.dataSource = self
        listOfCropsTableView.register(GenesTableViewCell.self, forCellReuseIdentifier: GenesTableViewCell.identifier)

        view.addSubview(removeAds)
        view.addSubview(firstActionLabel)
        view.addSubview(listView)
        view.addSubview(secondActionLabel)
        view.addSubview(preferredPatternView)
        view.addSubview(calculateButton)
        listView.addSubview(separator)
        listView.addSubview(clearButton)
        listView.addSubview(addButton)
        listView.addSubview(listOfCropsTableView)
        view.addSubview(popup)
        if let bottomAd = bottomBannerAd {
            view.addSubview(bottomAd)
        }
    }

    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                popup.topAnchor.constraint(equalTo: view.topAnchor),
                popup.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                popup.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                popup.bottomAnchor.constraint(equalTo: view.bottomAnchor),

                removeAds.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                removeAds.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),

                firstActionLabel.topAnchor.constraint(equalTo: removeAds.bottomAnchor, constant: 10),
                firstActionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),

                listView.topAnchor.constraint(equalTo: firstActionLabel.bottomAnchor, constant: 5),
                listView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                listView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                listView.heightAnchor.constraint(equalToConstant: view.bounds.height / 3),

                separator.heightAnchor.constraint(equalToConstant: 1),
                separator.widthAnchor.constraint(equalTo: listView.widthAnchor, multiplier: 0.65),
                separator.leadingAnchor.constraint(equalTo: listView.leadingAnchor),
                separator.topAnchor.constraint(equalTo: addButton.bottomAnchor),

                clearButton.leadingAnchor.constraint(equalTo: listView.leadingAnchor, constant: 15),
                clearButton.topAnchor.constraint(equalTo: listView.topAnchor, constant: 5),
                clearButton.widthAnchor.constraint(equalToConstant: 50),
                clearButton.heightAnchor.constraint(equalToConstant: 50),

                addButton.topAnchor.constraint(equalTo: listView.topAnchor, constant: 5),
                addButton.trailingAnchor.constraint(equalTo: listView.trailingAnchor, constant: -5),
                addButton.widthAnchor.constraint(equalToConstant: 50),
                addButton.heightAnchor.constraint(equalToConstant: 50),

                listOfCropsTableView.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 5),
                listOfCropsTableView.leadingAnchor.constraint(equalTo: listView.leadingAnchor, constant: 5),
                listOfCropsTableView.trailingAnchor.constraint(equalTo: listView.trailingAnchor, constant: -5),
                listOfCropsTableView.bottomAnchor.constraint(equalTo: listView.bottomAnchor, constant: -15),

                secondActionLabel.topAnchor.constraint(equalTo: listView.bottomAnchor, constant: 20),
                secondActionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),

                preferredPatternView.topAnchor.constraint(equalTo: secondActionLabel.bottomAnchor, constant: 5),
                preferredPatternView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                preferredPatternView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),

                calculateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                calculateButton.topAnchor.constraint(greaterThanOrEqualTo: preferredPatternView.bottomAnchor, constant: 10),
                calculateButton.bottomAnchor.constraint(
                    equalTo: bottomBannerAd != nil ? bottomBannerAd!.topAnchor : view.bottomAnchor,
                    constant: bottomBannerAd != nil ? -20 : -60),
            ]
        )
        guard let bottomAd = bottomBannerAd else { return }
        NSLayoutConstraint.activate(
            [
                bottomAd.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                bottomAd.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                bottomAd.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                bottomAd.heightAnchor.constraint(equalToConstant: 50),
            ]
        )
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getSamplesCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GenesTableViewCell.identifier, for: indexPath) as? GenesTableViewCell else { return UITableViewCell() }

        cell.resetSell()

        cell.setupCell(crop: self.viewModel.getCrop(at: indexPath.row))

        cell.removeButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.removeRow(at: indexPath)
            self.clearButton.isHidden = self.viewModel.getSamplesCount() == 0
            tableView.reloadData()
        }

        cell.genButtonTapped = { [weak self] tag in
            guard let self = self else { return }
            self.popup.moveIn()
            self.popup.genChoosed = { letter in
                self.viewModel.updateCrop(crop: indexPath.row, letter: tag, newKey: letter) {
                    tableView.beginUpdates()
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                    tableView.endUpdates()
                }
                self.popup.moveOut()
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension MainViewController: ADS {
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        if let crop = viewModel.getTopCrop() {
            present(ResultViewController(crop: crop), animated: true)
        } else {
            CustomAlert().showAlert(parent: self, alertType: .addMoreCrops)
        }                              // Constants.AdIdentifiers.rewardedAd
        ads?.loadRewardedAd(withAdUnitID: "ca-app-pub-3940256099942544/1712485313") { [weak self] ad in
            guard let self = self, let ad = ad else { return }
            self.mainRewardedAd = ad
            self.mainRewardedAd!.fullScreenContentDelegate = self
        }
    }
}
