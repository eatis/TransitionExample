//
//  OptionsViewController.swift
//  TransitionExample
//
//  Created by 谷田　裕樹 on 2016/01/27.
//  Copyright © 2016年 谷田　裕樹. All rights reserved.
//

import UIKit

enum LeftMenuType{
    case Switch(name:String, on:Bool, onChange:(on:Bool)->Void)
    case Slider(name:String, value:Float, onChange:(value:Float)->Void)
    case Segment(name:String, values:[Any], selected:Int, onChange:(value:Any)->Void)
}

class SwitchCell:UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var control: UISwitch!
    
    var onChange:((on:Bool)->Void)?
    @IBAction func switchChanged(sender: UISwitch) {
        onChange?(on: sender.on)
    }
    
}

class SliderCell:UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    var onChange:((value:Float)->Void)?
    
    @IBOutlet weak var sliderChanged: UISlider!
}

class SegmentCell:UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var segment: UISegmentedControl!
    
    var values:[Any] = []
    var onChange:((value:Any)->Void)?
    
    @IBOutlet weak var segmentChanged: UISegmentedControl!
    
}

class OptionsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var contentLength:CGFloat = 0
    var dismissByBackgroundTouch = true
    var dismissByBackgroundDrag = true
    var dismissByForegroundDrag = true
    
    var menu:[LeftMenuType] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menu = []
        menu.append(.Switch(name: "Sticky", on:true, onChange: {on in
            true
        }))
        menu.append(.Switch(name: "Shadow", on:true, onChange: {on in
            true
        }))
        menu.append(LeftMenuType.Segment(name: "Transform Type", values:[1.0,1.0,1.0], selected:1, onChange: {value in
            true
        }))
        menu.append(.Slider(name: "Damping", value:1.0, onChange: {value in
            true
        }))
        menu.append(.Slider(name: "Radius Factor", value:1.0, onChange: {value in
            true
        }))
        menu.append(.Slider(name: "Pan Theashold", value:1.0, onChange: {value in
            true
        }))
        
        for i in 0..<menu.count{
            contentLength += self.tableView(self.tableView, heightForRowAtIndexPath: NSIndexPath(forRow:i, inSection:0))
        }
        tableView.reloadData()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

extension OptionsViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell
        switch menu[indexPath.item]{
        case .Switch(let name, let on, let onChange):
            let switchCell = tableView.dequeueReusableCellWithIdentifier("switch", forIndexPath: indexPath) as! SwitchCell
            switchCell.onChange = onChange
            switchCell.nameLabel.text = name
            switchCell.control.on = on
            cell = switchCell
        case .Segment(let name, let values, let selected, let onChange):
            let segmentCell  = tableView.dequeueReusableCellWithIdentifier("segment", forIndexPath: indexPath) as! SegmentCell
            segmentCell.onChange = onChange
            segmentCell.nameLabel.text = name
            segmentCell.segment.removeAllSegments()
            segmentCell.values = values
            for v in values.reverse(){
                segmentCell.segment.insertSegmentWithTitle("\(v)", atIndex: 0, animated: false)
            }
            segmentCell.segment.selectedSegmentIndex = selected
            cell = segmentCell
        case .Slider(let name, let value, let onChange):
            let sliderCell  = tableView.dequeueReusableCellWithIdentifier("slider", forIndexPath: indexPath) as! SliderCell
            sliderCell.onChange = onChange
            sliderCell.nameLabel.text = name
            sliderCell.slider.maximumValue = 1.0
            sliderCell.slider.minimumValue = 0
            sliderCell.slider.value = value
            cell = sliderCell
        }
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch menu[indexPath.item]{
        case .Switch:
            return 54
        case .Slider:
            return 62
        default:
            return 72
        }
    }
}