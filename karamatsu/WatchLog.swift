//
//  WatchLog.swift
//  karamatsu
//
//  Created by hirogwa on 2015-05-24.
//  Copyright (c) 2015 hirogwa. All rights reserved.
//

import Foundation

class WatchLog {
    let watchLogId: String
    let title: String
    let log: String
    let posterUrl: NSURL?
    let backdropUrl: NSURL?
    let date: String?
    
    private init(watchLogId: String, title: String, log: String, posterUrl: NSURL?, backdropUrl: NSURL?, date: String?) {
        self.watchLogId = watchLogId
        self.title = title
        self.log = log
        self.posterUrl = posterUrl
        self.backdropUrl = backdropUrl
        self.date = date
    }

    static func newInstance(watchLogId: String, input: Dictionary<String, AnyObject>) -> WatchLog {
        let posterUrl = ((input["poster"] as! Dictionary<String, AnyObject>)["paths"] as! Dictionary<String, String>)["original"]
        let backdropUrl = ((input["backdrop"] as! Dictionary<String, AnyObject>)["paths"] as! Dictionary<String, String>)["original"]
        return WatchLog(watchLogId: watchLogId, title: input["title"] as! String, log: input["log"] as! String, posterUrl: NSURL(string: posterUrl!), backdropUrl: NSURL(string: backdropUrl!), date: input["date"] as? String)
    }
    
    static func newInstance(input: Dictionary<String, AnyObject>) -> WatchLog {
        return WatchLog.newInstance(input["watchlog_id"] as! String, input: input)
    }
}