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
// * ADD A PROPER MENU

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {
    
    //For player save
    let playerDefaults = UserDefaults.standard

    @IBOutlet var lbl: UILabel!
    var cnt = 0
    
    // will allow for only one passinc() call per app launch
    var autocheck = false
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
                self.cnt += 1 // this line will be changed to a bunch of if else statements for 2x taps sync upgrades
                self.playerDefaults.set(self.cnt, forKey: "count")
                
                print(self.cnt)
                
                //Performing label text update on main thread using Grand Central Dispatch
                DispatchQueue.main.async{
                        self.lbl.text = "Taps: \(self.playerDefaults.integer(forKey: "count"))"
                }
                print("Auto clicker bool: \(self.playerDefaults.bool(forKey: "autoclicker"))")
                //ADD IF STATEMENTS TO SET VARIOUS UPGRADES THAT CAN REDUCE THIS TIMER
                sleep(2)
            }
        }
        if self.playerDefaults.bool(forKey: "autoclicker") == true {
            // NEED TO ADD SOME OTHER CONIDTIONAL TO MAKE SURE THIS ONLY GETS ADDED ONCE BECAUSE OF VIEWDIDLOAD
            // Adding an operation queue for background thread
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
        //upgrade tier reset
        playerDefaults.set(1, forKey: "times")
        playerDefaults.set(false, forKey: "t1")
        playerDefaults.set(false, forKey: "t2")
        playerDefaults.set(false, forKey: "t3")
        playerDefaults.set(false, forKey: "t4")
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
        if playerDefaults.bool(forKey: "4x") == true {
            print("\(playerDefaults.bool(forKey: "4x"))")
            print("\(playerDefaults.integer(forKey: "times"))")
            cnt += playerDefaults.integer(forKey: "times")
        } else{
            cnt += 1
        }
        //update click count
        playerDefaults.set(cnt, forKey: "count")
        //update label to match internal click count
        self.lbl.text = "Taps: \(playerDefaults.integer(forKey: "count"))"
       
        print("\(playerDefaults.integer(forKey: "count"))")
        
        //Set Tuffy back to his original size
        tuffy.transform = CGAffineTransform(scaleX: 1, y: 1)
    }
    //
}

