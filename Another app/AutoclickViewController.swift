//
//  AutoclickViewController.swift
//  Tuffy Tapper
//
//  Created by Kevin Henderson on 3/29/25.
//
// TODO: //      - * ADD AUTOCLICKER UPGRADES (HOW FAST IT GENERATES MONEY ETC.)
//      - ^ to do this will need to alter passinc() and play around with resetting operation queue
//      - once you set conditions in passinc() to check for upgrades, it should be good
//      - PLANNED UPGRADES TO AUTOCLICKER (NOW CALLED PASSIVE INCOME)
//          - First upgrade will increase how fast taps are generated (alters the sleep() timer)
//          - Second upgrade will sync amount of taps generated per second with the 2x taps upgrade
//              - Example: if 8x taps is unlocked then passive income will generate 8 taps each call instead of 1
//          - THINK OF MORE UPGRADES LATER

import UIKit

class AutoclickViewController: MainViewController {

    @IBOutlet var progbar: UIProgressView!
    @IBOutlet var cntlbl: UILabel!
    @IBOutlet var at1: UIButton!
    @IBOutlet var at2: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        cntlbl.text = "Taps: \(playerDefaults.integer(forKey: "count"))"
        // Do any additional setup after loading the view.
        if playerDefaults.bool(forKey: "at1") == true {
            at1.isEnabled = false
            print("at1 unlocked")
            progbar.setProgress(0.5, animated: true)
            if playerDefaults.bool(forKey: "at2") == false {
                at2.isEnabled = true
            }
        }
        if playerDefaults.bool(forKey: "at2") == true {
            at2.isEnabled = false
            print("t2 unlocked")
            progbar.setProgress(1, animated: true)
        }
    }
    // CHANGE PRICE BACK TO 2500 AFTER TESTING
    @IBAction func purchT1(_ sender: Any) {
        if playerDefaults.integer(forKey: "count") < 2500 {
            at1.setTitle( "Not enough taps!", for: .normal)
        }
        else if playerDefaults.integer(forKey: "count") >= 2500 {
            playerDefaults.set(true, forKey: "at1")
            playerDefaults.set(playerDefaults.integer(forKey: "count") - 2500, forKey: "count")
            // update the sleep value used in passinc()
            playerDefaults.set(1, forKey: "sleep")
            at1.isEnabled = false
            at2.isEnabled = true
            progbar.setProgress(0.5, animated: true)
            cntlbl.text = "Taps: \(playerDefaults.integer(forKey: "count"))"
        }
        
        
    }
    // CHANGE PRICE BACK TO 5000 AFTER TESTING
    @IBAction func purchT2(_ sender: Any) {
        if playerDefaults.integer(forKey: "count") < 5000 {
            at2.setTitle( "Not enough taps!", for: .normal)
        }
        else if playerDefaults.integer(forKey: "count") >= 5000 && playerDefaults.bool(forKey: "t4") == true {
            playerDefaults.set(true, forKey: "at2")
            playerDefaults.set(playerDefaults.integer(forKey: "count") - 5000, forKey: "count")

            at2.isEnabled = false
            progbar.setProgress(1, animated: true)
            cntlbl.text = "Taps: \(playerDefaults.integer(forKey: "count"))"
        } else{
            at2.setTitle( "Tier IV of 2x Taps required!", for: .normal)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
