//
//  WatchLogViewController.swift
//  karamatsu
//
//  Created by hirogwa on 2015-05-21.
//  Copyright (c) 2015 hirogwa. All rights reserved.
//

import UIKit

class WatchLogViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var logLabel: UILabel!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var backdropImageView: UIImageView!

    
    var watchlogId: String?
    
    var watchlog: WatchLog?
    
    private var logText: String? {
        set {
            logLabel.text = newValue
        }
        get {
            return logLabel.text
        }
    }
    
    private func loadWatchLog() {
        if watchlogId != nil {
            println("loading \(watchlogId)")
            spinner.startAnimating()
            let url = "\(AppConstants.host)/watchlog?watchlog_id=\(watchlogId!)"
            let qos = Int(QOS_CLASS_USER_INITIATED.value)
            dispatch_async(dispatch_get_global_queue(qos, 0)) {
                let content = NSData(contentsOfURL: NSURL(string: url)!)
                let contentS = NSString(data: content!, encoding: NSUTF8StringEncoding)!
                
                let json: AnyObject! = NSJSONSerialization.JSONObjectWithData(content!, options: NSJSONReadingOptions.MutableContainers, error: nil)
                dispatch_async(dispatch_get_main_queue()) {
                    if let dict = json as? Dictionary<String, AnyObject> {
                        let watchlog = WatchLog.newInstance(self.watchlogId!, input: dict)
                        self.titleLabel.text = watchlog.title
                        self.logLabel.text = watchlog.log
                    }
                    self.spinner.stopAnimating()
                }
            }
        }
    }
    
    private func loadPosterImageAsync() {
        let qos = Int(QOS_CLASS_USER_INITIATED.value)
        dispatch_async(dispatch_get_global_queue(qos, 0)) {
            var imageData: NSData?
            if self.watchlog != nil {
                imageData = NSData(contentsOfURL: self.watchlog!.backdropUrl!)
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.backdropImageView.image = UIImage(data: imageData!)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if watchlog != nil {
            titleLabel.text = watchlog!.title
            logLabel.text = watchlog!.log
            loadPosterImageAsync()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
