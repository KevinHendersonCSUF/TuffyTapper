//
// ViewController.swift
// Another app
//
// Created by Kevin Henderson on 3/7/25.
// Print statements are for testing

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {
    
    // minigame button timer
    var minigameButtonTimer: Timer?
    
    //For player save
    let playerDefaults = UserDefaults.standard
    
    @IBOutlet var lbl: UILabel!
    var cnt = 0
    
    // will allow for only one passinc() call per app launch
    var autocheck = false
    
    // Alternating mini game flag
    var nextMinigameIsSlot = true
    
    
    // Button styling, alter later to include other colors and stuff
    func styleButton(_ button: UIButton, titleSize: CGFloat = 18) {
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: titleSize)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
    }
    
    func animateLabelBounce(_ label: UILabel) {
        UIView.animate(withDuration: 0.1, animations: {
            label.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                label.transform = .identity
            }
        }
    }
    
    
    // Increment animation
    func showFloatingText(value: Int, at position: CGPoint) {
        let randomXOffset = CGFloat.random(in: -30...30)
        let randomYOffset = CGFloat.random(in: -20...20)
        let randomColor = [UIColor.green, UIColor.cyan, UIColor.systemYellow, UIColor.white].randomElement() ?? .green
        let randomScale = CGFloat.random(in: 0.8...1.2)
        
        let floatingLabel = UILabel(frame: CGRect(x: position.x + randomXOffset, y: position.y + randomYOffset, width: 80, height: 30))
        floatingLabel.text = "+\(value)"
        floatingLabel.textColor = randomColor
        floatingLabel.font = UIFont.boldSystemFont(ofSize: 18 * randomScale)
        floatingLabel.textAlignment = .center
        floatingLabel.alpha = 1.0
        
        self.view.addSubview(floatingLabel)
        
        UIView.animate(withDuration: 1.0, animations: {
            floatingLabel.alpha = 0.0
            floatingLabel.transform = CGAffineTransform(translationX: 0, y: -60).scaledBy(x: 1.1, y: 1.1)
        }) { _ in
            floatingLabel.removeFromSuperview()
        }
    }
    
    
    
    // Used for Segue transition to avoid unexpectedly unwrapping nil error by passing variables to destination viewcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "navigationSegue"{
            let shopview = segue.destination as! ShopViewController
            //Carries lbl variable over to shopviewcontroller so that it doesnt return nil when activating segue
            shopview.lbl = lbl
            shopview.autocheck = autocheck
            shopview.tuffy = tuffy
        }
        if segue.identifier == "tuffyshopsegue"{
            let tufshop = segue.destination as! CosmeticsController
            tufshop.lbl = lbl
            tufshop.autocheck = autocheck
            tufshop.tuffy = tuffy
        }
        if segue.identifier == "two"{
            let tiertime = segue.destination as! TwoTimeViewController
            tiertime.lbl = lbl
            tiertime.autocheck = autocheck
            tiertime.tuffy = tuffy
        }
        if segue.identifier == "autotier"{
            let tierauto = segue.destination as! AutoclickViewController
            tierauto.lbl = lbl
            tierauto.autocheck = autocheck
            tierauto.tuffy = tuffy
        }
        if segue.identifier == "mini"{
            let min = segue.destination as! MiniupViewController
            min.lbl = lbl
            min.autocheck = autocheck
            min.tuffy = tuffy
        }
    }
    
    @objc func launchSlotMachine() {
        // Cancel auto-dismiss timer if player taps it
        minigameButtonTimer?.invalidate()
        minigameButton.removeFromSuperview()
        
        // Show slot machine overlay
        let slotVC = SlotMachineViewController()
        slotVC.modalPresentationStyle = .overFullScreen
        slotVC.currentCount = playerDefaults.integer(forKey: "count")
        slotVC.lbl = self.lbl
        slotVC.autocheck = self.autocheck
        slotVC.tuffy = self.tuffy
        slotVC.onWin = { newCount in
            self.playerDefaults.set(newCount, forKey: "count")
            self.lbl.text = "Taps: \(newCount)"
        }
        
        self.present(slotVC, animated: true)
    }
    
    
    // Falling coins game
    func launchFallingCoinsGame() {
        let coinsVC = TapTheCoinsViewController()
        coinsVC.modalPresentationStyle = .overFullScreen
        coinsVC.onComplete = { earned in
            let newCount = self.playerDefaults.integer(forKey: "count") + earned
            self.playerDefaults.set(newCount, forKey: "count")
            self.lbl.text = "Taps: \(newCount)"
        }
        self.present(coinsVC, animated: true)
    }
    
    
    
    // Minigame button
    lazy var minigameButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 120, y: 670, width: 150, height: 50))
        button.backgroundColor = .systemPurple
        button.setTitle("PLAY", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(launchRandomMinigame), for: .touchUpInside)
        return button
    }()
    
    func showMinigameButton() {
        DispatchQueue.main.async {
            // Invalidate any existing timer
            self.minigameButtonTimer?.invalidate()
            
            // Always remove and re-add the button
            self.minigameButton.removeFromSuperview()
            self.view.addSubview(self.minigameButton)
            
            // Set new timer
            self.minigameButtonTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false) { _ in
                self.minigameButton.removeFromSuperview()
                self.minigameButtonTimer = nil
            }
            
            print("Minigame button added (passive or dev)")
        }
    }
    
    
    @objc func launchRandomMinigame() {
        minigameButtonTimer?.invalidate()
        minigameButton.removeFromSuperview()
        
        if nextMinigameIsSlot {
            launchSlotMachine()
        } else {
            launchFallingCoinsGame()
        }
        
        // Flip for next round
        nextMinigameIsSlot.toggle()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // apply button styling
        for subview in view.subviews {
            if let button = subview as? UIButton {
                styleButton(button)
            }
        }
        
        //Loads click count into label on launch
        self.lbl.text = "Taps: \(playerDefaults.integer(forKey: "count"))"
        if autocheck == false {
            passinc()
            autocheck = true
        }
        //loads purchased cosmetics
        if playerDefaults.bool(forKey: "fancy") == true && playerDefaults.bool(forKey: "fancyon") == true{
            tuffy.setImage(UIImage(named: "fancy"), for: .normal)
            tuffy.setImage(UIImage(named: "fancy1"), for: .highlighted)
        }
        if playerDefaults.bool(forKey: "cyborg") == true && playerDefaults.bool(forKey: "cyborgon") == true{
            tuffy.setImage(UIImage(named: "cyborg"), for: .normal)
            tuffy.setImage(UIImage(named: "cyborg1"), for: .highlighted)
        }
    }
    
    // background queue for background tasks like passive income upgrade, and other timer based effects
    let backgroundqueue = OperationQueue()
    
    // Function for autoclicker/passive income functionality
    func passinc(){
        print("Auto clicker bool first: \(self.playerDefaults.bool(forKey: "autoclicker"))")
        let autoclickop = BlockOperation {
            while self.playerDefaults.bool(forKey: "autoclicker") == true {
                self.cnt = self.playerDefaults.integer(forKey: "count")
                //Check if Tier 2 is unlocked
                if self.playerDefaults.bool(forKey: "at2") == true {
                    print("TIER 2 UNLOCKED")
                    self.cnt += self.playerDefaults.integer(forKey: "times")
                    DispatchQueue.main.async{
                        self.showFloatingText(value: self.playerDefaults.integer(forKey: "times"), at: CGPoint(x: self.lbl.center.x, y: self.lbl.frame.minY))
                    }
                } else {
                    self.cnt += 1
                    DispatchQueue.main.async{
                        self.showFloatingText(value: 1, at: CGPoint(x: self.lbl.center.x, y: self.lbl.frame.minY))
                    }
                }
                self.playerDefaults.set(self.cnt, forKey: "count")
                print(self.cnt)
                
                //Performing label text update on main thread using Grand Central Dispatch
                DispatchQueue.main.async{
                    self.lbl.text = "Taps: \(self.playerDefaults.integer(forKey: "count"))"
                }
                
                // Minigame trigger check
                var chance : Int
                //check if mini game upgrade is purchased
                if self.playerDefaults.bool(forKey: "miniup") == true {
                    chance = Int.random(in: 1...15)
                    //add another if statement to check if the tier 1 upgrade is unlocked
                    if self.playerDefaults.bool(forKey: "mt1") == true {
                        chance = Int.random(in: 1...10)
                    }
                } else {
                    chance = Int.random(in: 1...25)
                }
                print("miniup: \(self.playerDefaults.bool(forKey: "miniup"))")
                if chance == 1 {
                    print("Chance hit")
                    self.showMinigameButton()
                } else {
                    print("Chance fail")
                }
                
                print("Auto clicker bool: \(self.playerDefaults.bool(forKey: "autoclicker"))")
                
                //Check if Tier 1 is unlocked
                if self.playerDefaults.bool(forKey: "at1") == true{
                    print("SLEEP = 1")
                    sleep(UInt32(self.playerDefaults.integer(forKey: "sleep")))
                } else {
                    print("SLEEP = 2")
                    sleep(2)
                }
                
            }
        }
        if self.playerDefaults.bool(forKey: "autoclicker") == true {
            // Adding to operation queue as a background thread
            print("Adding autoclick operation to queue")
            backgroundqueue.addOperation(autoclickop)
            
        }
    }
    
    //new game button
    @IBAction func newgame(_ sender: Any) {
        print("Creating New Game!")
        playerDefaults.set(0, forKey: "count")
        self.lbl.text = "Taps: \(playerDefaults.integer(forKey: "count"))"
        //upgrades reset
        playerDefaults.set(false, forKey: "4x")
        playerDefaults.set(false, forKey: "autoclicker")
        //upgrade tier reset for 2x upgrade
        playerDefaults.set(1, forKey: "times")
        playerDefaults.set(false, forKey: "t1")
        playerDefaults.set(false, forKey: "t2")
        playerDefaults.set(false, forKey: "t3")
        playerDefaults.set(false, forKey: "t4")
        //upgrade tier reset for passinc()
        playerDefaults.set(false, forKey: "at1")
        playerDefaults.set(false, forKey: "at2")
        //MiniGame upgrade
        playerDefaults.set(false, forKey: "miniup")
        //upgrade tier reset for minigame tier upgrade
        playerDefaults.set(false, forKey: "mt1")
        playerDefaults.set(false, forKey: "mt2")
        //cosmetics
        playerDefaults.set(false, forKey: "fancy")
        playerDefaults.set(false, forKey: "cyborg")
        playerDefaults.set(false, forKey: "fancyon")
        playerDefaults.set(false, forKey: "cyborgon")
        tuffy.setImage(UIImage(named: "Tuffy1"), for: .normal)
        tuffy.setImage(UIImage(named: "Tuffy3"), for: .highlighted)
    }
    
    //Tuffy Button
    @IBOutlet weak var tuffy: UIButton!
    
    // shop upgrade variables (MIGHT NOT BE NEEDED ANYMORE)
    var autoclicker = false
    var fourtime = false
    
    //main Tuffy button functionality
    @IBAction func btn(_ sender: Any) {
        cnt = playerDefaults.integer(forKey: "count")
        
        //Makes Tuffy Bounce when pressed
        UIView.animate(withDuration: 0.07) {
            self.tuffy.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }
        
        //check if 2x money is purchased
        let gain: Int
        if playerDefaults.bool(forKey: "4x") == true {
            gain = playerDefaults.integer(forKey: "times")
        } else {
            gain = 1
        }
        
        cnt += gain
        playerDefaults.set(cnt, forKey: "count")
        
        // Update the top label and animate it
        lbl.text = "Taps: \(cnt)"
        animateLabelBounce(lbl)
        showFloatingText(value: gain, at: CGPoint(x: lbl.center.x, y: lbl.frame.minY))
        
        // Reset Tuffy to original size
        tuffy.transform = CGAffineTransform.identity
    }
    
    //
    //Dev Mode for testing
    @IBOutlet var devinp: UITextField!
    @IBAction func Keychecker(_ sender: Any) {
        if devinp.text == "dev" {
            playerDefaults.set(99999, forKey: "count")
            self.lbl.text = "Taps: \(playerDefaults.integer(forKey: "count"))"
        }
        print("return pressed")
        if devinp.text == "slot" {
            self.showMinigameButton()
            print("slot pressed")
        }
    }
}
