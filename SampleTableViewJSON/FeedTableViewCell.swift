//
//  FeedTableViewCell.swift
//  SampleTableViewJSON
//
//  Created by Olga Pudrovska on 3/28/15.
//  Copyright (c) 2016 Olga Pudrovska. All rights reserved.
//

import UIKit

let FeedTableViewCellIdentifier = "Cell"

class FeedTableViewCell: UITableViewCell {
    // MARK: - Outlets

    @IBOutlet weak var contentImage: UIImageView!

    @IBOutlet weak var contentTitleLabel: UILabel!

    @IBOutlet weak var contentBlurbLabel: UILabel!

    @IBOutlet weak var contentDateLabel: UILabel!
}
