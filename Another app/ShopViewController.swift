//
//  ShopViewController.swift
//  Another app
//
//  Created by Kevin Henderson on 3/7/25.
//TODO:
// * ADD LABEL TO SHOW CLICKS
// * ADD IF STATEMENT OUTSIDE BUTTON PRESS TO KEEP BUTTON TEXT AS "PURCHASED" WHEN ITEM WAS PURCHASED
// MAKE SURE COUNTER LBL IN MAINVIEWCONTROLLER IS UPDATE AFTER PURCHASE WITHOUT PRESSING TUFFY TO UPDATE (MAY NEED MULTITHREADING FOR THIS)

import UIKit

class ShopViewController: MainViewController {
    
    @IBOutlet var Clickcount: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if playerDefaults.bool(forKey: "4x") == true {
            self.fourpurch.setTitle("Purchased!", for: .normal)
            twotimeupgrade.isEnabled = true
            twotimeupgrade.setImage(UIImage(systemName: "lock.open.fill"), for: .normal)
        }
        if playerDefaults.bool(forKey: "autoclicker") == true {
            self.auto.setTitle("Purchased!", for: .normal)
            // add tier upgrade button lock/unlock logic
        }
        Clickcount.text = "Taps: \(playerDefaults.integer(forKey: "count"))"
        if playerDefaults.bool(forKey: "autoclicker") == true {
            Autobutt.isEnabled = true
            Autobutt.setImage(UIImage(systemName: "lock.open.fill"), for: .normal)
        }
    }
    
    // 2x Taps Upgrade tier Button
    @IBOutlet var twotimeupgrade: UIButton!
    //2x upgrade purchase
    @IBOutlet weak var fourpurch: UIButton!
    @IBAction func purchquad(_ sender: Any) {
        if playerDefaults.bool(forKey: "4x") == true {
            self.fourpurch.setTitle("Already Purchased!", for: .normal)

        }
         else if playerDefaults.integer(forKey: "count") < 200 {
            self.fourpurch.setTitle("Not enough clicks!", for: .normal)
        }
        else {
            fourtime = true
            playerDefaults.set(fourtime, forKey: "4x")
            print("purchased 2x money! \(playerDefaults.bool(forKey: "4x"))")
            self.fourpurch.setTitle("Purchased!", for: .normal)
            playerDefaults.set(playerDefaults.integer(forKey: "count") - 200, forKey: "count")
            Clickcount.text = "Taps: \(playerDefaults.integer(forKey: "count"))"
            playerDefaults.set(2, forKey: "times")
            twotimeupgrade.isEnabled = true
            Clickcount.text = "Taps: \(playerDefaults.integer(forKey: "count"))"
            twotimeupgrade.setImage(UIImage(systemName: "lock.open.fill"), for: .normal)
        }
        // Just to see if price properly gets deducted after purchase in xcode debugger thing
        print("\(playerDefaults.integer(forKey: "count"))")
    }
    
    // CHANGE PRICE BACK TO 1500 AFTER TESTING
    //Tier Upgrade button for passive income
    @IBOutlet var Autobutt: UIButton!
    // Passive Income upgrade
    @IBOutlet weak var auto: UIButton!
    @IBAction func purchauto(_ sender: Any) {
        //change price to 1000 or more after testing
        if playerDefaults.bool(forKey: "autoclicker") == true {
            self.auto.setTitle("Already Purchased!", for: .normal)

        } else if playerDefaults.integer(forKey: "count") < 1 {
            self.auto.setTitle("Not enough clicks!", for: .normal)
        }
            else {
            autoclicker = true
            playerDefaults.set(autoclicker, forKey: "autoclicker")
            print("purchased autoclicker! \(playerDefaults.bool(forKey: "autoclicker"))")
            self.auto.setTitle("Purchased!", for: .normal)
            playerDefaults.set(playerDefaults.integer(forKey: "count") - 1, forKey: "count")
                // auto clicker call
                passinc()
                Clickcount.text = "Taps: \(playerDefaults.integer(forKey: "count"))"
                Autobutt.isEnabled = true
                Autobutt.setImage(UIImage(systemName: "lock.open.fill"), for: .normal)
        }
        // Just to see if price properly gets deducted after purchase in xcode debugger thing
        print("\(playerDefaults.integer(forKey: "count"))")
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
