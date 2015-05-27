//
//  WatchLogTableViewController.swift
//  karamatsu
//
//  Created by hirogwa on 2015-05-23.
//  Copyright (c) 2015 hirogwa. All rights reserved.
//

import UIKit

class WatchLogTableViewController: UITableViewController {
    
    var watchLogs = [WatchLog]()

    private func loadLogs() {
        let url = "\(AppConstants.host)/watchlogs"
        let qos = Int(QOS_CLASS_USER_INITIATED.value)
        dispatch_async(dispatch_get_global_queue(qos, 0)) {
            let content = NSData(contentsOfURL: NSURL(string: url)!)
            let contentS = NSString(data: content!, encoding: NSUTF8StringEncoding)!
            
            let json: AnyObject! = NSJSONSerialization.JSONObjectWithData(content!, options: NSJSONReadingOptions.MutableContainers, error: nil)
            dispatch_async(dispatch_get_main_queue()) {
                if let arr = json as? Array<AnyObject> {
                    self.watchLogs = arr.map { WatchLog.newInstance($0 as! Dictionary<String, AnyObject>) }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLogs()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchLogs.count
    }
    
    private struct StoryBoard {
        static let cellReuseIdentifier = "WatchLogSummary"
        static let segueIdentifierWatchLogDetail = "showWatchLogDetail"
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.cellReuseIdentifier, forIndexPath: indexPath) as! WatchLogTableViewCell
        
        cell.watchlog = watchLogs[indexPath.row]
        cell.loadImageAsync()
        
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("prep at TableViewController")
        if let dest = segue.destinationViewController as? WatchLogViewController {
            if let identifier = segue.identifier {
                println(identifier)
                switch identifier {
                case StoryBoard.segueIdentifierWatchLogDetail:
                    if let watchLogCell = sender as? WatchLogTableViewCell {
                        //dest.watchlogId = watchLogCell.watchLogId
                        dest.watchlog = watchLogCell.watchlog
                    }
                default: break
                }
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
