//
//  WatchLogTableViewCell.swift
//  karamatsu
//
//  Created by hirogwa on 2015-05-23.
//  Copyright (c) 2015 hirogwa. All rights reserved.
//

import UIKit

class WatchLogTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    var posterImage: UIImage? {
        set {
            posterImageView.image = newValue
        }
        get {
            return posterImageView.image
        }
    }
    
    var watchlog: WatchLog? {
        didSet {
            labelTitle.text = watchlog?.title
            labelDate.text = watchlog?.date
        }
    }
    
    func loadImageAsync() {
        let qos = Int(QOS_CLASS_USER_INITIATED.value)
        dispatch_async(dispatch_get_global_queue(qos, 0)) {
            var imageData: NSData?
            if self.watchlog != nil {
                imageData = NSData(contentsOfURL: self.watchlog!.posterUrl!)
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.posterImage = UIImage(data: imageData!)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
