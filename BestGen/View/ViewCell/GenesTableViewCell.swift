//
//  GenesTableViewCell.swift
//  BestGen
//
//  Created by Igor Chernobai on 5/11/22.
//

import UIKit



class GenesTableViewCell: UITableViewCell {

    private var row: Int!
    var removeButtonTapped: (() -> ())?
    var genButtonTapped: ((Int) -> ())?
    private var crop: [Letter]? {
        didSet {
            crop?.enumerated().forEach {
                switch $0.offset {
                case 0:
                    $0.element.key != .empty ?
                    firstButton.updateButtonToLetter(letter: $0.element.key) :
                    firstButton.updateButtonToEmpty()
                case 1:
                    $0.element.key != .empty ?
                    secondButton.updateButtonToLetter(letter: $0.element.key) :
                    secondButton.updateButtonToEmpty()
                case 2:
                    $0.element.key != .empty ?
                    thirdButton.updateButtonToLetter(letter: $0.element.key) :
                    thirdButton.updateButtonToEmpty()
                case 3:
                    $0.element.key != .empty ?
                    fourthButton.updateButtonToLetter(letter: $0.element.key) :
                    fourthButton.updateButtonToEmpty()
                case 4:
                    $0.element.key != .empty ?
                    fifthButton.updateButtonToLetter(letter: $0.element.key) :
                    fifthButton.updateButtonToEmpty()
                case 5:
                    $0.element.key != .empty ?
                    sixthButton.updateButtonToLetter(letter: $0.element.key) :
                    sixthButton.updateButtonToEmpty()
                default:
                    break
                }
            }
        }
    }

    var firstButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.tag = 0

        return button
    }()

    var secondButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.tag = 1

        return button
    }()

    var thirdButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.tag = 2

        return button
    }()

    var fourthButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.tag = 3

        return button
    }()

    var fifthButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.tag = 4

        return button
    }()

    var sixthButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.tag = 5

        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            firstButton,
            secondButton,
            thirdButton,
            fourthButton,
            fifthButton,
            sixthButton,
            removeGenButton
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.contentMode = .scaleAspectFit
        stackView.distribution = .fill
        stackView.spacing = 10

        return stackView
    }()

    private lazy var removeGenButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold, scale: .large)
        button.setImage(UIImage(systemName: "xmark",withConfiguration: config), for: .normal)
        button.tintColor = Constants.Colors.mainRed
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.tag = 6

        return button
    }()

    func setupCell(crop: [Letter]) {
        self.crop = crop
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        contentView.isUserInteractionEnabled = true
        addSubview(stackView)

        NSLayoutConstraint.activate(
            [
                stackView.heightAnchor.constraint(equalToConstant: 40),
                stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),

                heightAnchor.constraint(equalToConstant: 60)
            ]
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func buttonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 6:
            removeButtonTapped?()
        case 0:
            genButtonTapped?(firstButton.tag)
        case 1:
            genButtonTapped?(secondButton.tag)
        case 2:
            genButtonTapped?(thirdButton.tag)
        case 3:
            genButtonTapped?(fourthButton.tag)
        case 4:
            genButtonTapped?(fifthButton.tag)
        case 5:
            genButtonTapped?(sixthButton.tag)
        default:
            print("Button tapped")
        }
    }

    func resetSell() {
        firstButton.setTitle(nil, for: .normal)
        secondButton.setTitle(nil, for: .normal)
        thirdButton.setTitle(nil, for: .normal)
        fourthButton.setTitle(nil, for: .normal)
        fifthButton.setTitle(nil, for: .normal)
        sixthButton.setTitle(nil, for: .normal)
    }
}
