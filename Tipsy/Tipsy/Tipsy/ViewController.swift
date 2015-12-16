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
    
    let defaults = NSUserDefaults.standardUserDefaults();
    let locationManager = CLLocationManager();
    var localeResolution = NSLocale.currentLocale(); // Default currency = iOS user's region/language settings.
    var localeResolved = false;
    var billFieldLifted = false;
    var tipPercent: Int = 20;
    var splitWays: Int = 2;

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
        
        /* initializing instance of CLLocationManager */
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
            // Keeping accuracy low for speed and to conserve power/resources.
            // Acceptable; just need to determine country (locale), that too, optionally.
        locationManager.requestWhenInUseAuthorization();
            // ensure permissions are available
        locationManager.startUpdatingLocation();
            // bombs away!
        
        // restore last session
        let lastSessionTime = defaults.integerForKey("lastCalculationTime") ?? 0;
        let currentTimestamp = Int(NSDate().timeIntervalSince1970);
        if(currentTimestamp - lastSessionTime < 300) {
        let billSubtotal = defaults.doubleForKey("subtotal") ?? 0;
            if(billSubtotal >= 0.0) {
                print("billSubtotal:");
                print(billSubtotal);
                tipPercent = defaults.integerForKey("tipPercent") ?? tipPercent;
                splitWays = defaults.integerForKey("splitWays") ?? splitWays;
                print("tipPercent:");
                print(tipPercent);
                print("splitWays:");
                print(splitWays);
                billField.text = String(billSubtotal);
                animateLiftTextfield();
                updateTipLabels(billSubtotal);
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation(); // All done! Conserve power.
        var placemark: CLPlacemark!;
        var countryCode: String = "";
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            if error == nil && placemarks!.count > 0 {
                print("Current location: \(manager.location)"); // debug
                placemark = placemarks![0] as CLPlacemark;
                countryCode = placemark!.ISOcountryCode! ?? "";
                if(countryCode != "") {
                    let components = NSDictionary(object: countryCode, forKey: NSLocaleCountryCode);
                    var localeIdent = NSLocale.localeIdentifierFromComponents(components as! [String : String]);
                    if(countryCode == "US") { // Exception for US$: hide country name from UI.
                        localeIdent = NSLocale(localeIdentifier: "en_US").localeIdentifier;
                    }
                    self.localeResolution = NSLocale(localeIdentifier: localeIdent);
                    self.localeResolved = true;
                }
            }
        });
        billField.placeholder = getCurrencySymbol();
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

        billFieldCenterConstraint = billFieldCenterY; // backup
        
        UIView.animateWithDuration(0.4, animations: {
            self.view.removeConstraint(self.billFieldCenterY);
            self.resultViewBottomConstraint.priority = 100;
            self.view.layoutIfNeeded();
        });
    }
    
    func animateDropTextfield() {
        billFieldLifted = false;
        
        billFieldCenterY = billFieldCenterConstraint; // restore backup
        
        UIView.animateWithDuration(0.4, animations: {
            self.view.addConstraint(self.billFieldCenterY);
            self.resultViewBottomConstraint.priority = 800;
            self.view.layoutIfNeeded();
        });
    }
    
    func updateTipLabels(billSubtotal : Double) {
        let currentTimestamp = Int(NSDate().timeIntervalSince1970);
        defaults.setDouble(billSubtotal, forKey: "subtotal");
        defaults.setInteger(tipPercent, forKey: "tipPercent");
        defaults.setInteger(splitWays, forKey: "splitWays");
        defaults.setInteger(currentTimestamp, forKey: "lastCalculationTime");
        
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
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if(motion == .MotionShake) {
            tipPercent = (10 + Int(arc4random_uniform(UInt32(30 - 10 + 1))));
            changeTipPercent(tipPercent);
            updateTipLabels(getBillSubtotal());
        }
    }

}

