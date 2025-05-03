//
//  MiniupViewController.swift
//  Tuffy Tapper
//
//  Created by Kevin Henderson on 5/2/25.
//

import UIKit

class MiniupViewController: MainViewController {
    @IBOutlet var progbar: UIProgressView!
    @IBOutlet var mt1: UIButton!
    @IBOutlet var mt2: UIButton!
    @IBOutlet var cntlbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        cntlbl.text = "Taps: \(playerDefaults.integer(forKey: "count"))"
        // Do any additional setup after loading the view.
        if playerDefaults.bool(forKey: "mt1") == true {
            mt1.isEnabled = false
            print("mt1 unlocked")
            progbar.setProgress(0.5, animated: true)
            if playerDefaults.bool(forKey: "mt2") == false {
                mt2.isEnabled = true
            }
        }
        if playerDefaults.bool(forKey: "mt2") == true {
            mt2.isEnabled = false
            print("t2 unlocked")
            progbar.setProgress(1, animated: true)
        }
    }
    
    @IBAction func purchmt1(_ sender: Any) {
        if playerDefaults.integer(forKey: "count") < 1000 {
            mt1.setTitle( "Not enough taps!", for: .normal)
        }
        else if playerDefaults.integer(forKey: "count") >= 1000 {
            playerDefaults.set(true, forKey: "mt1")
            playerDefaults.set(playerDefaults.integer(forKey: "count") - 1000, forKey: "count")
            mt1.isEnabled = false
            mt2.isEnabled = true
            progbar.setProgress(0.5, animated: true)
            cntlbl.text = "Taps: \(playerDefaults.integer(forKey: "count"))"
        }
    }
    @IBAction func purchmt2(_ sender: Any) {
        if playerDefaults.integer(forKey: "count") < 7500 {
            mt1.setTitle( "Not enough taps!", for: .normal)
        }
        else if playerDefaults.integer(forKey: "count") >= 7500 {
            playerDefaults.set(true, forKey: "mt2")
            playerDefaults.set(playerDefaults.integer(forKey: "count") - 7500, forKey: "count")
            mt2.isEnabled = false
            progbar.setProgress(1, animated: true)
            cntlbl.text = "Taps: \(playerDefaults.integer(forKey: "count"))"
        }
    }
    
}
