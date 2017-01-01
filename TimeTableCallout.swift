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
    
    var busStopAnnotation: BusStopAnnotation?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (busStopAnnotation?.timeTable.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = timeTable.dequeueReusableCell(withIdentifier: "timetable")
        if(cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "timetable")
        }
        cell?.textLabel?.text = busStopAnnotation?.timeTable[indexPath.row]
        return cell!
    }
}
