//
//  FeedTableViewCell.swift
//  SampleTableViewJSON
//
//  Created by Olga Pudrovska on 3/28/15.
//  Copyright (c) 2016 Olga Pudrovska. All rights reserved.
//

import UIKit

let FeedTableViewCellIdentifier = "FeedTableViewCell"

class FeedTableViewCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet var contentImage: UIImageView?
    @IBOutlet var contentTitleLabel: UILabel?
    @IBOutlet var contentBlurbLabel: UILabel?
    @IBOutlet var contentDateLabel: UILabel?
}
