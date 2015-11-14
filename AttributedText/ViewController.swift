//
//  ViewController.swift
//  AttributedText
//
//  Created by Moment Inc. on 11/11/15.
//  Copyright © 2015 fatihyildizhan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let cityList:[String] = ["Bodrum", "Yalıkavak", "Fethiye", "İzmir", "İstanbul", "Kahramanmaraş"]
    let plateList:[String] = ["48", "48", "48", "35", "34", "46"]
    let capacityList:[String] = ["200K", "50K", "208K", "5M", "16M", "2B"]
    
    let attrValueCity:String = "city"
    let attrName:String = "Click"
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        myTableView.delegate = self
        myTableView.dataSource = self
        self.title = "Cities"
    }
}

extension ViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return cityList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let nib: NSArray = NSBundle.mainBundle().loadNibNamed("CityTableViewCell", owner: tableView, options: nil)
        let cell = nib.objectAtIndex(0) as! CityTableViewCell
        
        let foreColorFrom = [NSForegroundColorAttributeName: UIColor.blackColor()]
        let visit:NSMutableAttributedString = NSMutableAttributedString(string: "you should visit ", attributes: foreColorFrom)
        
        // follow
        let cityName:String = cityList[indexPath.row]
        let foreColorCityName = [NSForegroundColorAttributeName: UIColor.redColor()]
        let city:NSMutableAttributedString = NSMutableAttributedString(string: cityName, attributes: foreColorCityName)
        let r1 = NSRange(location: 0, length: city.length)
        city.addAttributes([self.attrName: self.attrValueCity], range: r1)
        city.addAttribute("plate", value: plateList[indexPath.row], range: r1)
        city.addAttribute("capacity", value: capacityList[indexPath.row], range: r1)
        
        // add cityname to static string named visit
        visit.appendAttributedString(city)
    
        // add whole attributed string to labels
        cell.textView.attributedText = visit
        
        // add click handler
        let tap = UITapGestureRecognizer(target: self, action: Selector("TapHandler:"))
        tap.delegate = self
        cell.textView.addGestureRecognizer(tap)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        print("selected:\(indexPath)")
    }
}

extension ViewController:UIGestureRecognizerDelegate {
    func TapHandler(sender: UITapGestureRecognizer) {
        
        let myTextView = sender.view as! UITextView
        let layoutManager = myTextView.layoutManager
        
        var location = sender.locationInView(myTextView)
        location.x -= myTextView.textContainerInset.left;
        location.y -= myTextView.textContainerInset.top;
        
        let characterIndex = layoutManager.characterIndexForPoint(location, inTextContainer: myTextView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        if characterIndex < myTextView.textStorage.length {
            let attributeValue = myTextView.textStorage.attribute(attrName, atIndex: characterIndex, effectiveRange: nil) as? String
            if let value = attributeValue {
                if value == attrValueCity {
                    
                    let plate = myTextView.textStorage.attribute("plate", atIndex: characterIndex, effectiveRange: nil)
                    print("plate:\(plate)")
                    
                    let capacity = myTextView.textStorage.attribute("capacity", atIndex: characterIndex, effectiveRange: nil)
                    print("plate:\(capacity)")
                }
            }
        }
    }
}