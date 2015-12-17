//
//  SettingsViewController.swift
//  Tipsy
//
//  Created by Tejen Hasmukh Patel on 12/16/15.
//  Copyright © 2015 tejen. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let defaults = NSUserDefaults.standardUserDefaults();
    
    @IBOutlet weak var SwitchCurrencyByLocation: UISwitch!
    @IBOutlet weak var SwitchCurrencyBySystem: UISwitch!
    @IBOutlet weak var SwitchCurrencyBySystemLabel: UILabel!
    
    @IBOutlet weak var SettingsCurrencyLocationDescription: UITextView!
    @IBOutlet weak var SettingsCurrencySystemDescription: UITextView!
    @IBOutlet weak var SettingsCurrencyDefaultDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Do any additional setup after loading the view.

        switch formattingAlgorithm() {
        case "default":
            SwitchCurrencyByLocation.setOn(false, animated: false);
            SwitchCurrencyBySystem.setOn(false, animated: false);
            SwitchCurrencyBySystem.enabled = true;
            SwitchCurrencyBySystemLabel.enabled = true;
            currencyMatchFallback(0);
            break;
        case "system":
            SwitchCurrencyByLocation.setOn(false, animated: false);
            SwitchCurrencyBySystem.setOn(true, animated: false);
            SwitchCurrencyBySystem.enabled = true;
            SwitchCurrencyBySystemLabel.enabled = true;
            currencyMatchSystem(0);
            break;
        default:
            SwitchCurrencyByLocation.setOn(true, animated: false);
            SwitchCurrencyBySystem.setOn(true, animated: false);
            SwitchCurrencyBySystem.enabled = false;
            SwitchCurrencyBySystemLabel.enabled = false;
            currencyMatchLocation(0);
            break;
        };
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func formattingAlgorithm() -> String! {
        var algorithm = "location"; // by default, use location for currency
        if(defaults.objectForKey("formattingAlgorithm") != nil) {
            algorithm = String(defaults.objectForKey("formattingAlgorithm")!);
        }
        return algorithm;
    }
    
    func currencyMatchLocation(animateDuration: Double = 0.4) {
        UIView.animateWithDuration(animateDuration, animations: {
            self.SettingsCurrencyLocationDescription.alpha = 1;
            self.SettingsCurrencySystemDescription.alpha = 0;
            self.SettingsCurrencyDefaultDescription.alpha = 0;
        });
    }
    
    func currencyMatchSystem(animateDuration: Double = 0.4) {
        UIView.animateWithDuration(animateDuration, animations: {
            self.SettingsCurrencyLocationDescription.alpha = 0;
            self.SettingsCurrencySystemDescription.alpha = 1;
            self.SettingsCurrencyDefaultDescription.alpha = 0;
        });
    }
    
    func currencyMatchFallback(animateDuration: Double = 0.4){
        UIView.animateWithDuration(animateDuration, animations: {
            self.SettingsCurrencyLocationDescription.alpha = 0;
            self.SettingsCurrencySystemDescription.alpha = 0;
            self.SettingsCurrencyDefaultDescription.alpha = 1;
        });
    }
    
    @IBAction func onSwitchCurrencyByLocationChange(sender: AnyObject) {
        if(SwitchCurrencyByLocation.on) {
            defaults.setObject("location", forKey: "formattingAlgorithm");
            SwitchCurrencyBySystem.enabled = false;
            SwitchCurrencyBySystemLabel.enabled = false;
            SwitchCurrencyBySystem.setOn(true, animated: true);
            currencyMatchLocation();
        } else {
            defaults.setObject("system", forKey: "formattingAlgorithm");
            SwitchCurrencyBySystem.enabled = true;
            SwitchCurrencyBySystemLabel.enabled = true;
            currencyMatchSystem();
        }
    }
    
    @IBAction func onSwitchCurrencyBySystemChange(sender: AnyObject) {
        if(SwitchCurrencyBySystem.on) {
            defaults.setObject("system", forKey: "formattingAlgorithm");
            currencyMatchSystem();
        } else {
            defaults.setObject("default", forKey: "formattingAlgorithm");
            currencyMatchFallback();
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
