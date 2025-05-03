//
//  SlotMachineViewController.swift
//  Tuffy Tapper
//
//  Created by Keelan Dimmitt on 5/1/25.
//

import UIKit

class SlotMachineViewController: MainViewController {

    var currentCount: Int = 0
    var onWin: ((Int) -> Void)?

    private let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "Press SPIN to play!"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let spinButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SPIN", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.backgroundColor = .systemPurple
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.orange.withAlphaComponent(0.85)

        view.addSubview(resultLabel)
        view.addSubview(spinButton)

        spinButton.addTarget(self, action: #selector(spinTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            spinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinButton.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 30),
            spinButton.widthAnchor.constraint(equalToConstant: 160),
            spinButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc func spinTapped() {
        spinButton.isHidden = true
        spinButton.isEnabled = false
        let multipliers = [2, 4, 10]
        let upmulti = [4, 8, 20]
        var chosen : Int
        if playerDefaults.bool(forKey: "mt2") == true {
            chosen = upmulti.randomElement()!
        }
        else {
            chosen = multipliers.randomElement()!

        }
        let newCount = currentCount * chosen
        resultLabel.text = "🎉 Points multiplied by \(chosen)x!"
        onWin?(newCount)

        // Dismiss after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.dismiss(animated: true)
        }
    }
}
