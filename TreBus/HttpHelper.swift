//
//  HttpHelper.swift
//  TreBus
//
//  Created by Mikko Riihimäki on 30.8.2016.
//  Copyright © 2016 Mikko Riihimäki. All rights reserved.
//

import Foundation

class HttpHelper: NSObject {
    
    func JSONParseArray(_ jsonString:String) -> [Dictionary<String, AnyObject>] {
        if let data: Data = jsonString.data(using: String.Encoding.utf8) {
            do {
                if let jsonObj = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? NSArray {
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
    
    func JSONParseDict(_ jsonString:String) -> Dictionary<String, AnyObject> {
        if let data: Data = jsonString.data(using: String.Encoding.utf8) {
            do {
                if let jsonObj = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? Dictionary<String, AnyObject> {
                    return jsonObj
                }
            }
            catch {
                print("Error")
            }
        }
        return [String: AnyObject]()
    }
    
    func HTTPSendRequest(_ request: NSMutableURLRequest, callback: @escaping (String, String?) -> Void) {
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            data, response, error in
            if error != nil {
                callback("", (error!.localizedDescription) as String)
            } else {
                callback(NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as! String, nil)
            }
        })
        task.resume()
    }
    
    func HTTPGetJSON(_ url: String, callback: @escaping (Dictionary<String, AnyObject>, String?) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: url)!)
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
    
    func HTTPGetJSONArray(_ url: String, callback: @escaping ([Dictionary<String, AnyObject>], String?) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: url)!)
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
