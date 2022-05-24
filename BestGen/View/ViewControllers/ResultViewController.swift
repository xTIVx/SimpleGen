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

    private let parentsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none

        tableView.layer.cornerRadius = 10
        tableView.layer.borderColor = Constants.Colors.mainGrey.cgColor
        tableView.layer.borderWidth = 2

        return tableView
    }()

    private let linkTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isUserInteractionEnabled = true
        textView.delaysContentTouches = false
        textView.isScrollEnabled = false
        textView.isSelectable = true

        let attributedString = NSMutableAttributedString(string: "How to grow a crops?")
        attributedString.addAttribute(.link, value: "https://www.youtube.com/watch?v=WQ0ixceBZwA", range: NSRange(location: 0, length: 20))
        attributedString.addAttribute(.font, value: Constants.Fonts.letterTitle!.withSize(20), range: NSRange(location: 0, length: 20))
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: 20))
        textView.attributedText = attributedString

        return textView
    }()

    init(crop: Crop) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = ResultViewModel(crop: crop)

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
        parentsTableView.register(CropPresentTableViewCell.self, forCellReuseIdentifier: CropPresentTableViewCell.identifier)
        parentsTableView.delegate = self
        parentsTableView.dataSource = self
        linkTextView.delegate = self

        bestComboView.setupBestCombo(bestCombo: viewModel.getCrop())

        view.addSubview(closeWindowButton)
        view.addSubview(separator)
        view.addSubview(bestComboLabel)
        view.addSubview(bestComboView)
        view.addSubview(useNextCropsLabel)
        view.addSubview(parentsTableView)
        view.addSubview(linkTextView)
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

                bestComboView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                bestComboView.topAnchor.constraint(equalTo: bestComboLabel.bottomAnchor, constant: 30),
                bestComboView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

                useNextCropsLabel.topAnchor.constraint(equalTo: bestComboView.bottomAnchor, constant: 30),
                useNextCropsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),

                parentsTableView.topAnchor.constraint(equalTo: useNextCropsLabel.bottomAnchor, constant: 20),
                parentsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                parentsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                parentsTableView.heightAnchor.constraint(equalToConstant: view.bounds.height / 3),

                linkTextView.topAnchor.constraint(equalTo: parentsTableView.bottomAnchor, constant: 30),
                linkTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                linkTextView.heightAnchor.constraint(equalToConstant: 30)
            ]
        )
    }
}

extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getCrop().parents?.count ?? 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CropPresentTableViewCell.identifier, for: indexPath) as? CropPresentTableViewCell else { return UITableViewCell() }

        if let parents = viewModel.getCrop().parents {
            cell.setupCell(crop: parents[indexPath.row])
        } else {
            cell.setupCell(crop: viewModel.getCrop())

        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension ResultViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
}
