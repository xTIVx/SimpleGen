//
//  ViewController.swift
//  BestGen
//
//  Created by Igor Chernobai on 5/7/22.
//

import Combine
import Foundation
import GoogleMobileAds
import UIKit

class MainViewController: UIViewController {

    private let viewModel: MainViewModel = MainViewModel()
    private var ads: Ads?
    private var cancellable: Set<AnyCancellable> = []

    private var mainRewardedAd: GADRewardedAd?
    private var bottomBannerAd: GADBannerView?

    private let parentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let spaceFillerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let removeAds: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedString = NSAttributedString(
            string: "Remove ADS",
            attributes:
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
        view.layer.borderWidth = 2
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

    private let photoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .large)
        let largeBoldDoc = UIImage(systemName: "camera", withConfiguration: largeConfig)
        button.setImage(largeBoldDoc, for: .normal)
        button.tintColor = Constants.Colors.mainWhite
        button.blinkTintColor()
        button.tag = 115

        return button
    }()

    private let clearButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedString = NSAttributedString(
            string: "Clear",
            attributes:
                [
                    NSAttributedString.Key.foregroundColor: Constants.Colors.mainRed,
                    NSAttributedString.Key.font: Constants.Fonts.subTitle ?? UIFont(),
                ]
        )
        button.setAttributedTitle(attributedString, for: .normal)
        button.tintColor = Constants.Colors.mainWhite
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
        let attributedString = NSAttributedString(
            string: "Calculate",
            attributes:
                [
                    NSAttributedString.Key.foregroundColor: UIColor.white,
                    NSAttributedString.Key.font: Constants.Fonts.subTitle?.withSize(20) ?? UIFont(),
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
        setupBindings()
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

    }

    @objc private func buttonTapped(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        switch sender.tag {
        case 99:
            viewModel.removeAllCrops()
            clearButton.isHidden = true
            listOfCropsTableView.reloadData()
        case 100:
            if appDelegate.purchaseStatus == .Crops || appDelegate.purchaseStatus == .Full {
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
                if appDelegate.purchaseStatus == .Free || appDelegate.purchaseStatus == .Crops {
                    if let rewardedAd = self.mainRewardedAd {
                        ads?.showRewardedAd(rewardedAd: rewardedAd)
                    } else {
                        if let crop = viewModel.getTopCrop() {
                            present(ResultViewController(crop: crop), animated: true)
                        } else {
                            CustomAlert().showAlert(parent: self, alertType: .addMoreCrops)
                        }
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

    func setupBindings() {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let rawValue = UserDefaults.standard.string(forKey: "ProductStatus"),
           let productStatus = Product(rawValue: rawValue) {
            appDelegate.purchaseStatus = productStatus
        }

        appDelegate.$purchaseStatus.sink { [weak self] product in
            guard let self = self else { return }
            if product == .Free || product == .Crops {
                self.ads = Ads(delegate: self)
                if let ads = self.ads {
                    ads.loadRewardedAd(withAdUnitID: "ca-app-pub-4130550926106659/4712378772") { [weak self] ad in
                        guard let self = self, let ad = ad else { return }
                        self.mainRewardedAd = ad
                        self.mainRewardedAd!.fullScreenContentDelegate = self
                        self.mainRewardedAd = self.ads?.createRewardedAd()
                        self.bottomBannerAd = self.ads?.createSmallBanner(adUnitID: "ca-app-pub-4130550926106659/4900366445")
                    }
                }
                //Constants.AdIdentifiers.bottomAd
            }
            else {
                if self.mainRewardedAd != nil { self.mainRewardedAd = nil }
                if self.bottomBannerAd != nil { self.bottomBannerAd?.isHidden = true }
                if self.ads != nil { self.ads = nil }
                self.removeAds.isHidden = true
            }
        }.store(in: &cancellable)

        viewModel.$crops
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.listOfCropsTableView.reloadData()
            }
            .store(in: &cancellable)
    }

    func setupView() {
        clearButton.isHidden = viewModel.getSamplesCount() == 0
        view.backgroundColor = Constants.Colors.background
        addButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        calculateButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        removeAds.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        listOfCropsTableView.delegate = self
        listOfCropsTableView.dataSource = self
        listOfCropsTableView.register(GenesTableViewCell.self, forCellReuseIdentifier: GenesTableViewCell.identifier)

        view.addSubview(parentView)

        parentView.addSubview(removeAds)
        parentView.addSubview(firstActionLabel)
        parentView.addSubview(listView)
        parentView.addSubview(secondActionLabel)
        parentView.addSubview(preferredPatternView)
        parentView.addSubview(spaceFillerView)
        spaceFillerView.addSubview(calculateButton)
        listView.addSubview(separator)
        listView.addSubview(clearButton)
        listView.addSubview(addButton)
        listView.addSubview(listOfCropsTableView)
        parentView.addSubview(popup)

        if let bottomAd = bottomBannerAd {
            parentView.addSubview(bottomAd)
        }
    }

    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                parentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                parentView.widthAnchor.constraint(equalToConstant: Constants.ScreenSizeConfig.isIPad ? view.bounds.size.width / 2 : view.bounds.size.width - 20),
                parentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                parentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

                popup.topAnchor.constraint(equalTo: view.topAnchor),
                popup.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                popup.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                popup.bottomAnchor.constraint(equalTo: view.bottomAnchor),

                removeAds.bottomAnchor.constraint(equalTo: listView.topAnchor),
                removeAds.trailingAnchor.constraint(equalTo: listView.trailingAnchor),

                firstActionLabel.topAnchor.constraint(equalTo: parentView.topAnchor),
                firstActionLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 10),

                listView.topAnchor.constraint(equalTo: firstActionLabel.bottomAnchor, constant: 5),
                listView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
                listView.widthAnchor.constraint(equalTo: parentView.widthAnchor),
                listView.heightAnchor.constraint(equalToConstant: view.bounds.height / 3),

                separator.heightAnchor.constraint(equalToConstant: 1),
                separator.widthAnchor.constraint(equalTo: listView.widthAnchor, multiplier: 0.65),
                separator.leadingAnchor.constraint(equalTo: listView.leadingAnchor),
                separator.topAnchor.constraint(equalTo: addButton.bottomAnchor),

                clearButton.leadingAnchor.constraint(equalTo: listView.leadingAnchor, constant: 15),
                clearButton.centerYAnchor.constraint(equalTo: addButton.centerYAnchor),

                addButton.topAnchor.constraint(equalTo: listView.topAnchor, constant: 5),
                addButton.trailingAnchor.constraint(equalTo: listView.trailingAnchor, constant: -5),
                addButton.widthAnchor.constraint(equalToConstant: Constants.ScreenSizeConfig.isSmallDevice ? 30 : 50),
                addButton.heightAnchor.constraint(equalToConstant: Constants.ScreenSizeConfig.isSmallDevice ? 30 : 50),

                listOfCropsTableView.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 5),
                listOfCropsTableView.leadingAnchor.constraint(equalTo: listView.leadingAnchor, constant: 5),
                listOfCropsTableView.trailingAnchor.constraint(equalTo: listView.trailingAnchor, constant: -5),
                listOfCropsTableView.bottomAnchor.constraint(equalTo: listView.bottomAnchor, constant: -15),

                secondActionLabel.topAnchor.constraint(
                    equalTo: listView.bottomAnchor,
                    constant: Constants.ScreenSizeConfig.isSmallDevice ? 10 : 30
                ),
                secondActionLabel.leadingAnchor.constraint(equalTo: preferredPatternView.leadingAnchor),

                preferredPatternView.topAnchor.constraint(equalTo: secondActionLabel.bottomAnchor, constant: 5),
                preferredPatternView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
                preferredPatternView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),

                spaceFillerView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
                spaceFillerView.topAnchor.constraint(equalTo: preferredPatternView.bottomAnchor),
                spaceFillerView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
                spaceFillerView.bottomAnchor.constraint(equalTo: bottomBannerAd != nil ? bottomBannerAd!.topAnchor : view.bottomAnchor),

                calculateButton.centerXAnchor.constraint(equalTo: spaceFillerView.centerXAnchor),
                calculateButton.centerYAnchor.constraint(equalTo: spaceFillerView.centerYAnchor),
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

        cell.resetCell()

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
                self.viewModel.updateCrop(cropIndex: indexPath.row, letterIndex: tag, newKey: letter) { isSuccess in
                    if !isSuccess {
                        CustomAlert().showAlert(parent: self, alertType: .foundDuplicate)
                    }
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
