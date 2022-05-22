//
//  ViewController.swift
//  BestGen
//
//  Created by Igor Chernobai on 5/21/22.
//

import UIKit

class ChooseOptionsViewController: UIViewController {

    private let viewModel: MainViewModel = MainViewModel()

    private let firstActionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors.mainWhite
        label.text = "You have an options! Choose better for you:"
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

        return view
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraints()
    }
   
}


private extension ChooseOptionsViewController {

    func setupView() {
        view.backgroundColor = Constants.Colors.background

        listOfCropsTableView.delegate = self
        listOfCropsTableView.dataSource = self
        listOfCropsTableView.register(CropPresentTableViewCell.self, forCellReuseIdentifier: "cropPresentCell")

        view.addSubview(firstActionLabel)
        view.addSubview(listView)
        listView.addSubview(listOfCropsTableView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                firstActionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                firstActionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),

                listView.topAnchor.constraint(equalTo: firstActionLabel.bottomAnchor, constant: 5),
                listView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                listView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                listView.heightAnchor.constraint(equalToConstant: view.bounds.height / 3),

                listOfCropsTableView.topAnchor.constraint(equalTo: listView.topAnchor, constant: 15),
                listOfCropsTableView.leadingAnchor.constraint(equalTo: listView.leadingAnchor, constant: 5),
                listOfCropsTableView.trailingAnchor.constraint(equalTo: listView.trailingAnchor, constant: -5),
                listOfCropsTableView.bottomAnchor.constraint(equalTo: listView.bottomAnchor, constant: -15),
            ]
        )
    }
}

extension ChooseOptionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getSamplesCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CropPresentTableViewCell else { return UITableViewCell() }

        cell.setupCell(crop: self.viewModel.getCrop(at: indexPath.row))

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
