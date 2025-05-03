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
            Autobutt.isEnabled = true
            Autobutt.setImage(UIImage(systemName: "lock.open.fill"), for: .normal)
        }
        Clickcount.text = "Taps: \(playerDefaults.integer(forKey: "count"))"
        if playerDefaults.bool(forKey: "miniup") == true {
            self.minibutt.setTitle( "Purchased!", for: .normal)
            minigametier.isEnabled = true
            minigametier.setImage(UIImage(systemName: "lock.open.fill"), for: .normal)
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
            lbl.text = "Taps: \(playerDefaults.integer(forKey: "count"))"
        }
        // Just to see if price properly gets deducted after purchase in xcode debugger thing
        print("\(playerDefaults.integer(forKey: "count"))")
    }
    
    //Tier Upgrade button for passive income
    @IBOutlet var Autobutt: UIButton!
    // Passive Income upgrade
    @IBOutlet weak var auto: UIButton!
    @IBAction func purchauto(_ sender: Any) {
        if playerDefaults.bool(forKey: "autoclicker") == true {
            self.auto.setTitle("Already Purchased!", for: .normal)

        } else if playerDefaults.integer(forKey: "count") < 1500 {
            self.auto.setTitle("Not enough clicks!", for: .normal)
        }
            else {
            autoclicker = true
            playerDefaults.set(autoclicker, forKey: "autoclicker")
            print("purchased autoclicker! \(playerDefaults.bool(forKey: "autoclicker"))")
            self.auto.setTitle("Purchased!", for: .normal)
            playerDefaults.set(playerDefaults.integer(forKey: "count") - 1500, forKey: "count")
                // auto clicker call
                passinc()
                Clickcount.text = "Taps: \(playerDefaults.integer(forKey: "count"))"
                Autobutt.isEnabled = true
                Autobutt.setImage(UIImage(systemName: "lock.open.fill"), for: .normal)
                lbl.text = "Taps: \(playerDefaults.integer(forKey: "count"))"
        }
        // Just to see if price properly gets deducted after purchase in xcode debugger thing
        print("\(playerDefaults.integer(forKey: "count"))")
    }
    // Mini game upgrade tier button
    @IBOutlet var minigametier: UIButton!
    //minigame purchase button
    @IBOutlet var minibutt: UIButton!
    // minigame purchase
    @IBAction func purchmini(_ sender: Any) {
        if playerDefaults.bool(forKey: "miniup") == true {
            self.minibutt.setTitle("Already Purchased!", for: .normal)

        } else if playerDefaults.integer(forKey: "count") < 700 {
            self.minibutt.setTitle("Not enough clicks!", for: .normal)
        }
            else {
            playerDefaults.set(true, forKey: "miniup")
            print("purchased mini game upgrade! \(playerDefaults.bool(forKey: "miniup"))")
            self.minibutt.setTitle("Purchased!", for: .normal)
            playerDefaults.set(playerDefaults.integer(forKey: "count") - 700, forKey: "count")
            Clickcount.text = "Taps: \(playerDefaults.integer(forKey: "count"))"
                minigametier.isEnabled = true
                minigametier.setImage(UIImage(systemName: "lock.open.fill"), for: .normal)
                lbl.text = "Taps: \(playerDefaults.integer(forKey: "count"))"
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
