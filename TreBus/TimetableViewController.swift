//
//  TimetableViewController.swift
//  TreBus
//
//  Created by Mikko Riihimäki on 5.2.2017.
//  Copyright © 2017 Mikko Riihimäki. All rights reserved.
//

import UIKit

class TimetableViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    var stop: String = ""    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let requestUrl = NSURL(string: "http://aikataulut.tampere.fi/?stop=\(stop)&mobile=1")
        let requestObj = URLRequest(url: requestUrl! as URL);
        webView.loadRequest(requestObj)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
