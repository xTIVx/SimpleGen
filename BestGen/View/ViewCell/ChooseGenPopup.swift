//
//  ChooseGenPopup.swift
//  BestGen
//
//  Created by Igor Chernobai on 5/12/22.
//

import UIKit

class ChooseGenPopup: UIView {

    var genChoosed: ((LetterKey) -> ())?

    private let popupView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let yButton: UIButton = {
        let button = UIButton()
        button.updateButtonToLetter(letter: .Y)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.tag = 11

        return button
    }()

    private let gButton: UIButton = {
        let button = UIButton()
        button.updateButtonToLetter(letter: .G)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.tag = 12

        return button
    }()

    private let xButton: UIButton = {
        let button = UIButton()
        button.updateButtonToLetter(letter: .X)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.tag = 13

        return button
    }()

    private let wButton: UIButton = {
        let button = UIButton()
        button.updateButtonToLetter(letter: .W)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.tag = 14

        return button
    }()

    private let hButton: UIButton = {
        let button = UIButton()
        button.updateButtonToLetter(letter: .H)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.tag = 15

        return button
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.contentMode = .scaleAspectFit
        stackView.distribution = .fill
        stackView.spacing = 10

        return stackView
    }()

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func buttonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 11:
            genChoosed?(.Y)
        case 12:
            genChoosed?(.G)
        case 13:
            genChoosed?(.X)
        case 14:
            genChoosed?(.W)
        case 15:
            genChoosed?(.H)
        default:
            break
        }
        moveOut()
    }


    func setupView() {
        backgroundColor = .black.withAlphaComponent(0.5)

        addSubview(popupView)
        popupView.addSubview(stackView)
        stackView.addArrangedSubview(gButton)
        stackView.addArrangedSubview(yButton)
        stackView.addArrangedSubview(hButton)
        stackView.addArrangedSubview(wButton)
        stackView.addArrangedSubview(xButton)

        popupView.layer.borderWidth = 3
        popupView.layer.borderColor = Constants.Colors.mainGrey.cgColor
        popupView.layer.cornerRadius = 10
        popupView.backgroundColor = Constants.Colors.background
        NSLayoutConstraint.activate(
            [
                popupView.centerXAnchor.constraint(equalTo: centerXAnchor),
                popupView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -180),
                popupView.widthAnchor.constraint(equalToConstant: 270),
                popupView.heightAnchor.constraint(equalToConstant: 80),

                stackView.centerXAnchor.constraint(equalTo: popupView.centerXAnchor),
                stackView.centerYAnchor.constraint(equalTo: popupView.centerYAnchor)
            ]
        )
    }

    func moveIn() {
        self.isHidden = false
        popupView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        let originalTransform = popupView.transform
        let scaledTransform = originalTransform.scaledBy(x: 9, y: 9)
        let scaledAndTranslatedTransform = scaledTransform.translatedBy(x: 0.0, y: 100)
        UIView.animate(withDuration: 0.1, animations: {
            self.popupView.transform = scaledAndTranslatedTransform
        })
    }
    
    func moveOut() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .beginFromCurrentState) {
            self.popupView.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
        } completion: { _ in
            self.isHidden = true
        }
    }
}
