//
//  SlotMachineViewController.swift
//  Tuffy Tapper
//
//  Created by Keelan Dimmitt on 5/1/25.
//

import UIKit

class SlotMachineViewController: MainViewController {
    
    private let reel1 = UILabel()
    private let reel2 = UILabel()
    private let reel3 = UILabel()
    private var reelTimer: Timer?
    private var spinDuration = 2.0 // seconds
    
    
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
    
    func setupReels() {
        let reels = [reel1, reel2, reel3]
        let spacing: CGFloat = 20
        let reelWidth: CGFloat = 60
        let reelHeight: CGFloat = 60
        
        for (i, reel) in reels.enumerated() {
            reel.font = UIFont.systemFont(ofSize: 48)
            reel.textAlignment = .center
            reel.translatesAutoresizingMaskIntoConstraints = false
            reel.text = "🍒"
            reel.backgroundColor = .white
            reel.layer.cornerRadius = 10
            reel.layer.masksToBounds = true
            view.addSubview(reel)
            
            NSLayoutConstraint.activate([
                reel.centerYAnchor.constraint(equalTo: resultLabel.topAnchor, constant: -100),
                reel.widthAnchor.constraint(equalToConstant: reelWidth),
                reel.heightAnchor.constraint(equalToConstant: reelHeight),
                reel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: CGFloat(i - 1) * (reelWidth + spacing))
            ])
        }
    }
    
    let slotEmojis = ["🍒", "🍋", "🍉", "⭐️", "🔔", "7️⃣", "🍇"]
    
    func startSpinningReels(completion: @escaping () -> Void) {
        var elapsedTime: Double = 0
        var finalEmoji = slotEmojis.randomElement() ?? "🍒"

        reelTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            // Spin with random emojis
            self.reel1.text = self.slotEmojis.randomElement()
            self.reel2.text = self.slotEmojis.randomElement()
            self.reel3.text = self.slotEmojis.randomElement()
            elapsedTime += 0.1

            if elapsedTime >= self.spinDuration {
                timer.invalidate()

                // Finish with all reels showing the same final emoji
                self.reel1.text = finalEmoji
                self.reel2.text = finalEmoji
                self.reel3.text = finalEmoji

                completion()
            }
        }
    }

    
    
    
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
        
        setupReels()
        
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
        resultLabel.text = "Spinning..."
        
        startSpinningReels {
            let multipliers = [2, 4, 10]
            let upmulti = [4, 8, 20]
            let chosen = self.playerDefaults.bool(forKey: "mt2") ? upmulti.randomElement()! : multipliers.randomElement()!
            let newCount = self.currentCount * chosen
            self.resultLabel.text = "🎉 Points multiplied by \(chosen)x!"
            self.onWin?(newCount)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.dismiss(animated: true)
            }
        }
    }
}
