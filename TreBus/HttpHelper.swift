//
//  HttpHelper.swift
//  TreBus
//
//  Created by Mikko Riihimäki on 30.8.2016.
//  Copyright © 2016 Mikko Riihimäki. All rights reserved.
//

import Foundation

class HttpHelper: NSObject {
    
    func JSONParseArray(jsonString:String) -> [Dictionary<String, AnyObject>] {
        if let data: NSData = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                if let jsonObj = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)) as? NSArray {
                    if let jsonDict = jsonObj as? [Dictionary<String, AnyObject>] {
                        return jsonDict
                    }
                }
            }
            catch {
                print("Error")
            }
        }
        return [[String: AnyObject]()]
    }
    
    func JSONParseDict(jsonString:String) -> Dictionary<String, AnyObject> {
        if let data: NSData = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                if let jsonObj = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)) as? Dictionary<String, AnyObject> {
                    return jsonObj
                }
            }
            catch {
                print("Error")
            }
        }
        return [String: AnyObject]()
    }
    
    func HTTPSendRequest(request: NSMutableURLRequest, callback: (String, String?) -> Void) {
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {
            data, response, error in
            if error != nil {
                callback("", (error!.localizedDescription) as String)
            } else {
                callback(NSString(data: data!, encoding: NSUTF8StringEncoding) as! String, nil)
            }
        })
        task.resume()
    }
    
    func HTTPGetJSON(url: String, callback: (Dictionary<String, AnyObject>, String?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        HTTPSendRequest(request) {
            (data: String, error: String?) -> Void in
            if error != nil {
                callback(Dictionary<String, AnyObject>(), error)
            } else {
                //                print(data)
                let jsonObj = self.JSONParseDict(data)
                callback(jsonObj, nil)
            }
        }
    }
    
    func HTTPGetJSONArray(url: String, callback: ([Dictionary<String, AnyObject>], String?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        HTTPSendRequest(request) {
            (data: String, error: String?) -> Void in
            if error != nil {
                callback([Dictionary<String, AnyObject>()], error)
            } else {
                // print(data)
                let jsonObj = self.JSONParseArray(data)
                callback(jsonObj, nil)
            }
        }
    }
}
