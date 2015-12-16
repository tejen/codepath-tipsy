//
//  ViewController.swift
//  Tipsy
//
//  Created by Tejen Hasmukh Patel on 12/15/15.
//  Copyright © 2015 tejen. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager();
    var localeResolution = NSLocale.currentLocale(); // Default currency = iOS user's region/language settings.
    var localeResolved = false;
    var billFieldLifted = false;
    var tipPercent: Int = 20;
    var splitWays = 2;

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!;
    @IBOutlet weak var totalLabel: UILabel!;
    @IBOutlet weak var Total2xLabel: UILabel!
    @IBOutlet weak var tipPercentLabel: UILabel!
    @IBOutlet weak var tipSlider: UISlider!

    @IBOutlet weak var Splitter: UIStepper!
    @IBOutlet weak var SplitHead: UIImageView!
    @IBOutlet weak var SplitWaysLabel: UILabel!
    
    @IBOutlet weak var billFieldCenterY: NSLayoutConstraint!
    
    @IBOutlet weak var resultViewBottomConstraint: NSLayoutConstraint!
    
    var billFieldCenterConstraint: NSLayoutConstraint!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        billField.becomeFirstResponder();
        billField.placeholder = getCurrencySymbol();
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getBillSubtotal() -> Double {
        let subtotal = Double(billField.text!) ?? 0;
        return subtotal;
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        let billSubtotal = getBillSubtotal();
        if(!billFieldLifted && billSubtotal > 0) {
            animateLiftTextfield();
        } else if(billSubtotal <= 0) {
            animateDropTextfield();
        }
        updateTipLabels(billSubtotal);
    }
    
    func getCurrencySymbol() -> String {
        return localeResolution.objectForKey(NSLocaleCurrencySymbol) as! String;
    }
    
    func animateLiftTextfield() {
        billFieldLifted = true;
        print("open field");

        billFieldCenterConstraint = billFieldCenterY; // backup
        
        UIView.animateWithDuration(0.4, animations: {
            self.view.removeConstraint(self.billFieldCenterY);
            self.resultViewBottomConstraint.priority = 100;
            self.view.layoutIfNeeded();
        });
    }
    
    func animateDropTextfield() {
        billFieldLifted = false;
        print("close field");
        
        billFieldCenterY = billFieldCenterConstraint; // restore backup
        
        UIView.animateWithDuration(0.4, animations: {
            self.view.addConstraint(self.billFieldCenterY);
            self.resultViewBottomConstraint.priority = 800;
            self.view.layoutIfNeeded();
        });
    }
    
    func updateTipLabels(billSubtotal : Double) {
        if(billSubtotal <= 0) {
            return;
        }
        
        let formatter = NSNumberFormatter();
        formatter.numberStyle = .CurrencyStyle;
        formatter.locale = localeResolution;
        
        let tipAmount = billSubtotal * (Double(tipPercent) / 100);
        let total = billSubtotal + tipAmount;

        tipLabel.text = formatter.stringFromNumber(tipAmount);
        totalLabel.text = formatter.stringFromNumber(total);
        Total2xLabel.text = formatter.stringFromNumber(total/Double(splitWays));
    }
    
    func changeTipPercent(newPercent: Int) {
        tipPercent = newPercent;
        tipPercentLabel.text = String(tipPercent) + "%";
    }
    
    
    @IBAction func onTipSliderValueChange(sender: AnyObject) {
        changeTipPercent(Int(tipSlider.value));
        updateTipLabels(getBillSubtotal());
    }
    
    @IBAction func splitHeads(sender: AnyObject) {
        splitWays = Int(Splitter.value);
        SplitWaysLabel.text = "x " + String(splitWays);
        updateTipLabels(getBillSubtotal());
    }

}

