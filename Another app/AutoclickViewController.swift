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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
