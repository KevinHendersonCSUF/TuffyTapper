//
//  ViewController.swift
//  Another app
//
//  Created by Kevin Henderson on 3/7/25.
// Print statements are for testing
// TODO:
// * ADD FUNCTIONALITY TO AUTO CLICKER USING MULTITHREADING - DONE, NOW NEED UPGRADES
//      - * BUG: WHEN SWAPPING BACK FROM SHOP AFTER PURCHASING, AUTOCLICKING DOESNT WORK BECAUSE lbl == nil SO IT NEVER GETS CALLED, WORKS WHEN RESTARTING APP, FIND HOW TO FIX
//      - * ADD AUTOCLICKER UPGRADES (HOW FAST IT GENERATES MONEY ETC.)
// * ADD DIFFERENT MINIGAMES
// * ADD MORE UPGRADES
// * ADD A PROPER MENU

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {
    
    //For player save
    let playerDefaults = UserDefaults.standard
    
    @IBOutlet var lbl: UILabel!
    var cnt = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Loads click count into label on launch, and checks if nil when changing view controller
        if lbl != nil {
            self.lbl.text = "Taps: \(playerDefaults.integer(forKey: "count"))"
            
//             Call Autoclicker function
            passinc()
        }
    }
    // Function for autoclicker/passive income functionality
    func passinc(){
        print("Auto clicker bool first: \(self.playerDefaults.bool(forKey: "autoclicker"))")
        if playerDefaults.bool(forKey: "autoclicker") == true {
            // Adding an operation queue for background thread
            let backgroundqueue = OperationQueue()
            backgroundqueue.addOperation {
                while self.playerDefaults.bool(forKey: "autoclicker") == true {
                    self.cnt = self.playerDefaults.integer(forKey: "count")
                    self.cnt += 1
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
        }
    }
    
    //new game button
    @IBAction func newgame(_ sender: Any) {
        playerDefaults.set(0, forKey: "count")
        self.lbl.text = "Taps: \(playerDefaults.integer(forKey: "count"))"
        playerDefaults.set(false, forKey: "4x")
        playerDefaults.set(false, forKey: "autoclicker")
        //add rest of upgrades when added
    }
    
    //Tuffy Button
    @IBOutlet weak var tuffy: UIButton!
    
    // shop upgrade variables
    var autoclicker = false
    var fourtime = false
    
    //main Tuffy button functionality
    @IBAction func btn(_ sender: Any) {
        cnt = playerDefaults.integer(forKey: "count")
        //Makes Tuffy Bounce when pressed
        UIView.animate(withDuration: 0.07) {
            self.tuffy.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }
        
        //check if 4x money is purchased
        if playerDefaults.bool(forKey: "4x") == true {
            print("\(playerDefaults.bool(forKey: "4x"))")
            cnt += 4
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

