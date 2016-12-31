//
//  TimeTableCallout.swift
//  TreBus
//
//  Created by Mikko Riihimäki on 30.12.2016.
//  Copyright © 2016 Mikko Riihimäki. All rights reserved.
//

import Foundation
import UIKit

class TimeTableCallout: UIView, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = timeTable.dequeueReusableCell(withIdentifier: "timetable")
        if(cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "timetable")
        }
        cell?.textLabel?.text = "Number: \(indexPath.row)"
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
