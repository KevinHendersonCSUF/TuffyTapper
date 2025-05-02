//
//  ViewController.swift
//  Another app
//
//  Created by Kevin Henderson on 3/7/25.
// Print statements are for testing
// TODO:
// * ADD FUNCTIONALITY TO AUTO CLICKER USING MULTITHREADING - DONE, NOW NEED UPGRADES
//      - * ADD AUTOCLICKER UPGRADES (HOW FAST IT GENERATES MONEY ETC.)
//      - ^ to do this will need to alter passinc() and play around with resetting operation queue
//      - once you set conditions in passinc() to check for upgrades, it should be good
//      - PLANNED UPGRADES TO AUTOCLICKER (NOW CALLED PASSIVE INCOME)
//          - First upgrade will increase how fast taps are generated (alters the sleep() timer)
//          - Second upgrade will sync amount of taps generated per second with the 2x taps upgrade
//              - Example: if 8x taps is unlocked then passive income will generate 8 taps each call instead of 1
//          - THINK OF MORE UPGRADES LATER
// * ADD DIFFERENT MINIGAMES
// * ADD MORE UPGRADES
//      - For example, an upgrade to decrease rate of decay for hunger and an upgrade to decrease rate of decay for thirst
// * ADD A PROPER MENU

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
        let floatingLabel = UILabel(frame: CGRect(x: position.x - 30, y: position.y, width: 60, height: 30))
        floatingLabel.text = "+\(value)"
        floatingLabel.textColor = .green
        floatingLabel.font = UIFont.boldSystemFont(ofSize: 16)
        floatingLabel.textAlignment = .center
        floatingLabel.alpha = 1.0
        self.view.addSubview(floatingLabel)

        UIView.animate(withDuration: 1.0, animations: {
            floatingLabel.alpha = 0.0
            floatingLabel.frame.origin.y -= 30
        }) { _ in
            floatingLabel.removeFromSuperview()
        }
    }

    
    // Used for Segue transition to avoid unexpectedly unwrapping nil error
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "navigationSegue"{
        let shopview = segue.destination as! ShopViewController
        //Carries lbl variable over to shopviewcontroller so that it doesnt return nil when activating segue
        shopview.lbl = lbl
        shopview.autocheck = autocheck
    }
        if segue.identifier == "tuffyshopsegue"{
            let tufshop = segue.destination as! TuffyNeedsController
            tufshop.lbl = lbl
            tufshop.autocheck = autocheck
    }
        if segue.identifier == "two"{
            let tiertime = segue.destination as! TwoTimeViewController
            tiertime.lbl = lbl
            tiertime.autocheck = autocheck
    }
        if segue.identifier == "autotier"{
            let tierauto = segue.destination as! AutoclickViewController
            tierauto.lbl = lbl
            tierauto.autocheck = autocheck
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
        slotVC.onWin = { newCount in
            self.playerDefaults.set(newCount, forKey: "count")
            self.lbl.text = "Taps: \(newCount)"
        }

        self.present(slotVC, animated: true)
    }


    // Minigame button
    lazy var minigameButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 120, y: 670, width: 150, height: 50))
        button.backgroundColor = .systemPurple
        button.setTitle("🎰 SPIN", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(launchSlotMachine), for: .touchUpInside)
        return button
    }()
    
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
                } else {
                    self.cnt += 1
                }
                self.playerDefaults.set(self.cnt, forKey: "count")
                
                print(self.cnt)
                
                //Performing label text update on main thread using Grand Central Dispatch
                DispatchQueue.main.async{
                        self.lbl.text = "Taps: \(self.playerDefaults.integer(forKey: "count"))"
                }
                
                // Minigame trigger check
                let chance = Int.random(in: 1...25)
                if chance == 1 {
                    print("Chance hit")
                    DispatchQueue.main.async {
                        if !self.minigameButton.isDescendant(of: self.view) {
                            self.view.addSubview(self.minigameButton)

                            // Cancel any existing timer
                            self.minigameButtonTimer?.invalidate()

                            // Set a timer to remove the button after 10 seconds
                            self.minigameButtonTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false) { _ in
                                self.minigameButton.removeFromSuperview()
                            }
                        }
                    }
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
            playerDefaults.set(999999999, forKey: "count")
            self.lbl.text = "Taps: \(playerDefaults.integer(forKey: "count"))"
        }
        print("return pressed")
        if devinp.text == "slot" {
            DispatchQueue.main.async {
                if !self.minigameButton.isDescendant(of: self.view) {
                    self.view.addSubview(self.minigameButton)
                    
                    // Cancel any existing timer
                    self.minigameButtonTimer?.invalidate()
                    
                    // Set a timer to remove the button after 10 seconds
                    self.minigameButtonTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false) { _ in
                        self.minigameButton.removeFromSuperview()
                    }
                }
            }
        }
        print("slot pressed")
        }
    }
    

