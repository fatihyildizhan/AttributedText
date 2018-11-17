//
//  ViewController.swift
//  AttributedText
//
//  Created by Moment Inc. on 11/11/15.
//  Copyright © 2015 fatihyildizhan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let cityList:[String] = ["Bodrum", "Yalıkavak", "Fethiye", "İzmir", "İstanbul", "Kahramanmaraş", "Antalya"]
    let plateList:[String] = ["48", "48", "48", "35", "34", "46", "07"]
    let capacityList:[String] = ["200K", "50K", "208K", "5M", "16M", "2B", "174K"]
    
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

// MARK:- add tableview functions
extension ViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return cityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nib: NSArray = Bundle.main.loadNibNamed("CityTableViewCell", owner: tableView, options: nil)! as NSArray
        let cell = nib.object(at: 0) as! CityTableViewCell
        
        let foreColorFrom = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let visit:NSMutableAttributedString = NSMutableAttributedString(string: "you should visit ", attributes: foreColorFrom)
        
        // follow
        let cityName:String = cityList[indexPath.row]
        let foreColorCityName = [NSAttributedString.Key.foregroundColor: UIColor.red]
        let city:NSMutableAttributedString = NSMutableAttributedString(string: cityName, attributes: foreColorCityName)
        let r1 = NSRange(location: 0, length: city.length)
        city.addAttributes([NSAttributedString.Key(rawValue: self.attrName): self.attrValueCity], range: r1)
        city.addAttribute(NSAttributedString.Key(rawValue: "plate"), value: plateList[indexPath.row], range: r1)
        city.addAttribute(NSAttributedString.Key(rawValue: "capacity"), value: capacityList[indexPath.row], range: r1)
        
        // add cityname to static string named visit
        visit.append(city)
    
        // add whole attributed string to labels
        cell.textView.attributedText = visit
        
        // add click handler
        let tap = UITapGestureRecognizer(target: self, action: Selector(("TapHandler:")))
        tap.delegate = self
        cell.textView.addGestureRecognizer(tap)
        
        return cell
    }
    
    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        print("selected:\(indexPath)")
    }
}

// MARK:- add UIGestureRecognizerDelegate's functions
extension ViewController:UIGestureRecognizerDelegate {
    func TapHandler(sender: UITapGestureRecognizer) {
        
        let myTextView = sender.view as! UITextView
        let layoutManager = myTextView.layoutManager
        
        var location = sender.location(in: myTextView)
        location.x -= myTextView.textContainerInset.left;
        location.y -= myTextView.textContainerInset.top;
        
        let characterIndex = layoutManager.characterIndex(for: location, in: myTextView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        if characterIndex < myTextView.textStorage.length {
            let attributeValue = myTextView.textStorage.attribute(NSAttributedString.Key(rawValue: attrName), at: characterIndex, effectiveRange: nil) as? String
            if let value = attributeValue {
                if value == attrValueCity {
                    
                    let plate = myTextView.textStorage.attribute(NSAttributedString.Key(rawValue: "plate"), at: characterIndex, effectiveRange: nil)
                    print("plate:\(String(describing: plate))")
                    
                    let capacity = myTextView.textStorage.attribute(NSAttributedString.Key(rawValue: "capacity"), at: characterIndex, effectiveRange: nil)
                    print("plate:\(String(describing: capacity))")
                }
            }
        }
    }
}
