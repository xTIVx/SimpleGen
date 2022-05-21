//
//  PreferredPatternView.swift
//  BestGen
//
//  Created by Igor Chernobai on 5/14/22.
//

import UIKit

class PreferredPatternView: UIView {

    var preferredCombo: [LetterKey: Int] = [LetterKey: Int]() {
        didSet {
            gView.value = preferredCombo[.G]!
            yView.value = preferredCombo[.Y]!
            hView.value = preferredCombo[.H]!
            counter = preferredCombo.values.reduce(0) { $0 + $1 }
            if oldValue != preferredCombo {
                comboDidChange?(preferredCombo)
            }
            clearButton.isHidden = counter != 6
        }
    }
    var comboDidChange: (([LetterKey: Int]) -> ())?
    private var counter = 0

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 20

        return stackView
    }()

    private let gView: PreferredLetterButton = {
        let view = PreferredLetterButton(letter: .G)
        view.tag = 15

        return view
    }()

    private let yView: PreferredLetterButton = {
        let view = PreferredLetterButton(letter: .Y)
        view.tag = 16

        return view
    }()

    private let hView: PreferredLetterButton = {
        let view = PreferredLetterButton(letter: .H)
        view.tag = 17

        return view
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

        return button
    }()

    private let separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.Colors.mainGrey

        return view
    }()

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setCombo(combo: [LetterKey: Int]) {
        self.preferredCombo = combo
    }

}

extension PreferredPatternView {

    func setupView() {

        stackView.addArrangedSubview(gView)
        stackView.addArrangedSubview(yView)
        stackView.addArrangedSubview(hView)
        addSubview(clearButton)
        addSubview(separator)
        addSubview(stackView)

        lazy var gGesture = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        gView.addGestureRecognizer(gGesture)
        lazy var yGesture = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        yView.addGestureRecognizer(yGesture)
        lazy var hGesture = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        hView.addGestureRecognizer(hGesture)

        clearButton.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)

        backgroundColor = Constants.Colors.background
        isUserInteractionEnabled = true
        layer.borderColor = Constants.Colors.mainGrey.cgColor
        layer.borderWidth = 3
        layer.cornerRadius = 10
    }

    func setupConstraints() {

        NSLayoutConstraint.activate(
            [
                heightAnchor.constraint(equalToConstant: 180),

                clearButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
                clearButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
                clearButton.heightAnchor.constraint(equalToConstant: 20),

                separator.heightAnchor.constraint(equalToConstant: 1),
                separator.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.65),
                separator.leadingAnchor.constraint(equalTo: leadingAnchor),
                separator.topAnchor.constraint(equalTo: clearButton.bottomAnchor, constant: 5),

                stackView.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 15),
                stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),

                gView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25),

                yView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25),

                hView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25),

            ]
        )
    }

    @objc func clearTapped() {
        counter = 0
        preferredCombo = [.G: 0, .Y: 0, .H: 0]

    }

    @objc func buttonTapped(sender: UITapGestureRecognizer) {
        switch sender.view?.tag {
        case 15:
            if counter <= 5 {
                preferredCombo[.G]! += 1
            }
        case 16:
            if counter <= 5 {
                preferredCombo[.Y]! += 1
            }
        case 17:
            if counter <= 5 {
                preferredCombo[.H]! += 1
            }
        default:
            break
        }
    }
}
