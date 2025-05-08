import UIKit

class TapTheCoinsViewController: UIViewController {

    var onComplete: ((Int) -> Void)?
    private var totalScore = 0
    private var coinSpawnTimer: Timer?
    private var coinLifespan: TimeInterval = 1.5
    private let coinSpawnRate: TimeInterval = 0.3
    
    let startButton = UIButton()
    let countdownLabel = UILabel()
    let instructionLabel = UILabel()



    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.green.withAlphaComponent(0.85)
        setupStartButton()
    }
    
    func setupStartButton() {
        startButton.setTitle("Start!", for: .normal)
        startButton.titleLabel?.font = .boldSystemFont(ofSize: 28)
        startButton.setTitleColor(.white, for: .normal)
        startButton.backgroundColor = .systemGreen
        startButton.layer.cornerRadius = 10
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(startCountdown), for: .touchUpInside)

        view.addSubview(startButton)
        
        instructionLabel.text = "Tap as many coins as you can!"
        instructionLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        instructionLabel.textColor = .white
        instructionLabel.textAlignment = .center
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(instructionLabel)

        NSLayoutConstraint.activate([
            instructionLabel.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -16),
            instructionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 150),
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func startCountdown() {
        instructionLabel.removeFromSuperview()
        startButton.removeFromSuperview()

        countdownLabel.font = .boldSystemFont(ofSize: 72)
        countdownLabel.textColor = .white
        countdownLabel.textAlignment = .center
        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(countdownLabel)

        NSLayoutConstraint.activate([
            countdownLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            countdownLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        var count = 3
        countdownLabel.text = "\(count)"

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            count -= 1
            if count == 0 {
                timer.invalidate()
                self.countdownLabel.removeFromSuperview()
                self.startGame()
            } else {
                self.countdownLabel.text = "\(count)"
            }
        }
    }



    func startGame() {
        // Spawn coins regularly
        coinSpawnTimer = Timer.scheduledTimer(withTimeInterval: coinSpawnRate, repeats: true) { _ in
            self.spawnCoin()
        }

        // End game after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.endGame()
        }
    }

    func spawnCoin() {
        // Random size and value
        let sizes: [(CGFloat, Int)] = [(40, 100), (30, 200), (20, 400)]
        guard let (size, value) = sizes.randomElement() else { return }

        let x = CGFloat.random(in: 20...(view.bounds.width - size - 20))
        let y = CGFloat.random(in: 100...(view.bounds.height - size - 100))

        let coin = UIButton(frame: CGRect(x: x, y: y, width: size, height: size))
        coin.setTitle("🪙", for: .normal)
        coin.titleLabel?.font = .systemFont(ofSize: size * 0.8)
        coin.tag = value // store point value
        coin.layer.cornerRadius = size / 2
        coin.backgroundColor = UIColor.clear
        coin.addTarget(self, action: #selector(coinTapped(_:)), for: .touchUpInside)

        view.addSubview(coin)

        // Auto-remove after a short lifespan
        DispatchQueue.main.asyncAfter(deadline: .now() + coinLifespan) {
            if coin.superview != nil {
                coin.removeFromSuperview()
            }
        }
    }

    @objc func coinTapped(_ sender: UIButton) {
        let reward = sender.tag
        totalScore += reward
        showFloatingText("+\(reward)", at: sender.center)
        sender.removeFromSuperview()
    }

    func showFloatingText(_ text: String, at point: CGPoint) {
        let label = UILabel(frame: CGRect(x: point.x - 30, y: point.y - 20, width: 60, height: 30))
        label.text = text
        label.textColor = .yellow
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        view.addSubview(label)

        UIView.animate(withDuration: 1.0, animations: {
            label.alpha = 0
            label.center.y -= 30
        }) { _ in
            label.removeFromSuperview()
        }
    }

    func endGame() {
        coinSpawnTimer?.invalidate()
        view.subviews.forEach { if $0 is UIButton { $0.removeFromSuperview() } }

        let resultLabel = UILabel()
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.text = "🎉 You earned \(totalScore) taps!"
        resultLabel.font = .boldSystemFont(ofSize: 24)
        resultLabel.textColor = .white
        resultLabel.textAlignment = .center
        view.addSubview(resultLabel)

        NSLayoutConstraint.activate([
            resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        onComplete?(totalScore)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.dismiss(animated: true)
        }
    }
}
