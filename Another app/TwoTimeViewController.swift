//
//  TwoTimeViewController.swift
//  Tuffy Tapper
//
//  Created by Kevin Henderson on 3/28/25.
//

import UIKit

class TwoTimeViewController: MainViewController{

    @IBOutlet var cntlbl: UILabel!
    @IBOutlet var progbar: UIProgressView!
    @IBOutlet var t1: UIButton!
    @IBOutlet var t2: UIButton!
    @IBOutlet var t3: UIButton!
    @IBOutlet var t4: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cntlbl.text = "Taps: \(playerDefaults.integer(forKey: "count"))"
        if playerDefaults.bool(forKey: "t1") == true {
            t1.isEnabled = false
            print("t1 unlocked")
            progbar.setProgress(0.25, animated: true)
            if playerDefaults.bool(forKey: "t2") == false {
                t2.isEnabled = true
            }
        }
        if playerDefaults.bool(forKey: "t2") == true {
            t2.isEnabled = false
            print("t2 unlocked")
            progbar.setProgress(0.50, animated: true)
            if playerDefaults.bool(forKey: "t3") == false {
                t3.isEnabled = true
            }
        }
        if playerDefaults.bool(forKey: "t3") == true {
            t3.isEnabled = false
            print("t3 unlocked")
            progbar.setProgress(0.75, animated: true)
            if playerDefaults.bool(forKey: "t4") == false {
                t4.isEnabled = true
            }
        }
        if playerDefaults.bool(forKey: "t4") == true {
            t4.isEnabled = false
            print("t4 unlocked")
            progbar.setProgress(1.00, animated: true)
        }
    }
    @IBAction func t1purch(_ sender: Any) {
        if playerDefaults.integer(forKey: "count") < 400{
            t1.setTitle( "Not enough taps!", for: .normal)
        }
        else if playerDefaults.integer(forKey: "count") >= 400{
            playerDefaults.set(true, forKey: "t1")
            playerDefaults.set(playerDefaults.integer(forKey: "count") - 400, forKey: "count")
            // update the times value
            playerDefaults.set(playerDefaults.integer(forKey: "times") + 2, forKey: "times")
            t1.isEnabled = false
            t2.isEnabled = true
            progbar.setProgress(0.25, animated: true)
            cntlbl.text = "Taps: \(playerDefaults.integer(forKey: "count"))"
        }
    }
    @IBAction func t2purch(_ sender: Any) {
        if playerDefaults.integer(forKey: "count") < 1600{
            t2.setTitle( "Not enough taps!", for: .normal)
        }
        else if playerDefaults.integer(forKey: "count") >= 1600{
            playerDefaults.set(true, forKey: "t2")
            playerDefaults.set(playerDefaults.integer(forKey: "count") - 1600, forKey: "count")
            // update the times value
            playerDefaults.set(playerDefaults.integer(forKey: "times") + 4, forKey: "times")
            t2.isEnabled = false
            t3.isEnabled = true
            progbar.setProgress(0.50, animated: true)
            cntlbl.text = "Taps: \(playerDefaults.integer(forKey: "count"))"
        }

    }
    
    @IBAction func t3purch(_ sender: Any) {
        if playerDefaults.integer(forKey: "count") < 2400{
            t3.setTitle( "Not enough taps!", for: .normal)
        }
        else if playerDefaults.integer(forKey: "count") >= 2400{
            playerDefaults.set(true, forKey: "t3")
            playerDefaults.set(playerDefaults.integer(forKey: "count") - 2400, forKey: "count")
            // update the times value
            playerDefaults.set(playerDefaults.integer(forKey: "times") + 4, forKey: "times")
            t3.isEnabled = false
            t4.isEnabled = true
            progbar.setProgress(0.75, animated: true)
            cntlbl.text = "Taps: \(playerDefaults.integer(forKey: "count"))"
        }
    }
    @IBAction func t4purch(_ sender: Any) {
        if playerDefaults.integer(forKey: "count") < 3200{
            t4.setTitle( "Not enough taps!", for: .normal)
        }
        else if playerDefaults.integer(forKey: "count") >= 3200{
            playerDefaults.set(true, forKey: "t4")
            playerDefaults.set(playerDefaults.integer(forKey: "count") - 3200, forKey: "count")
            // update the times value
            playerDefaults.set(playerDefaults.integer(forKey: "times") + 4, forKey: "times")
            t4.isEnabled = false
            progbar.setProgress(1, animated: true)
            cntlbl.text = "Taps: \(playerDefaults.integer(forKey: "count"))"
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
