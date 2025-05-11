//
//  TuffyNeedsController.swift
//  Tuffy Tapper
//
//  Created by Kevin Henderson on 3/27/25.
//

import UIKit

class CosmeticsController: MainViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        cntlbl.text = "Taps: \(playerDefaults.integer(forKey: "count"))"
        if playerDefaults.bool(forKey: "fancy") == true && tuffy.image(for: .normal) != UIImage(named:"fancy") {
            fancybutt.setTitle( "Equip", for: .normal)
        }
        if playerDefaults.bool(forKey: "fancy") == true && tuffy.image(for: .normal) == UIImage(named:"fancy") {
            fancybutt.setTitle( "Equipped", for: .normal)
        }
        if playerDefaults.bool(forKey: "cyborg") == true && tuffy.image(for: .normal) != UIImage(named:"cyborg") {
            cyborgbutt.setTitle( "Equip", for: .normal)
        }
        if playerDefaults.bool(forKey: "cyborg") == true && tuffy.image(for: .normal) == UIImage(named:"cyborg") {
            cyborgbutt.setTitle( "Equipped", for: .normal)
        }
    }
    @IBOutlet var fancybutt: UIButton!
    @IBOutlet var cntlbl: UILabel!
    @IBOutlet var cyborgbutt: UIButton!
    
    @IBAction func purchfancy(_ sender: Any) {
        if playerDefaults.integer(forKey: "count") < 300{
            fancybutt.setTitle( "Not enough taps!", for: .normal)
        }
        // if player has enough, subtract money, unlock cosmetic, apply cosmetic, then change text of buttons based on if other cosmetic is unlocked
        else if playerDefaults.integer(forKey: "count") >= 300{
            playerDefaults.set(true, forKey: "fancy")
            playerDefaults.set(playerDefaults.integer(forKey: "count") - 300, forKey: "count")
            cntlbl.text = "Taps: \(playerDefaults.integer(forKey: "count"))"
            tuffy.setImage(UIImage(named: "fancy"), for: .normal)
            tuffy.setImage(UIImage(named: "fancy1"), for: .highlighted)
            playerDefaults.set(true, forKey: "fancyon")
            playerDefaults.set(false, forKey: "cyborgon")
            fancybutt.setTitle( "Equipped", for: .normal)
            if playerDefaults.bool(forKey: "cyborg") == true{
                cyborgbutt.setTitle( "Equip", for: .normal)
            }
        }
        if playerDefaults.bool(forKey: "fancy") == true && tuffy.image(for: .normal) != UIImage(named:"fancy") {
            tuffy.setImage(UIImage(named: "fancy"), for: .normal)
            tuffy.setImage(UIImage(named: "fancy1"), for: .highlighted)
            fancybutt.setTitle( "Equipped", for: .normal)
            cyborgbutt.setTitle( "Equip", for: .normal)
            playerDefaults.set(true, forKey: "fancyon")
            playerDefaults.set(false, forKey: "cyborgon")
        }
    }
    
    @IBAction func purchcyborg(_ sender: Any) {
        if playerDefaults.integer(forKey: "count") < 2000{
            cyborgbutt.setTitle( "Not enough taps!", for: .normal)
        }
        // if player has enough, subtract money, unlock cosmetic, apply cosmetic, then change text of buttons based on if other cosmetic is unlocked
        else if playerDefaults.integer(forKey: "count") >= 2000{
            playerDefaults.set(true, forKey: "cyborg")
            playerDefaults.set(playerDefaults.integer(forKey: "count") - 2000, forKey: "count")
            cntlbl.text = "Taps: \(playerDefaults.integer(forKey: "count"))"
            tuffy.setImage(UIImage(named: "cyborg"), for: .normal)
            tuffy.setImage(UIImage(named: "cyborg1"), for: .highlighted)
            cyborgbutt.setTitle( "Equipped", for: .normal)
            playerDefaults.set(false, forKey: "fancyon")
            playerDefaults.set(true, forKey: "cyborgon")
            if playerDefaults.bool(forKey: "fancy") == true{
                fancybutt.setTitle( "Equip", for: .normal)
            }
        }
        if playerDefaults.bool(forKey: "cyborg") == true && tuffy.image(for: .normal) != UIImage(named:"cyborg") {
            tuffy.setImage(UIImage(named: "cyborg"), for: .normal)
            tuffy.setImage(UIImage(named: "cyborg"), for: .highlighted)
            cyborgbutt.setTitle( "Equipped", for: .normal)
            fancybutt.setTitle( "Equip", for: .normal)
            playerDefaults.set(false, forKey: "fancyon")
            playerDefaults.set(true, forKey: "cyborgon")
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
