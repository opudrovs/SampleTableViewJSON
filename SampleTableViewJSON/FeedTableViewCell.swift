//
//  FeedTableViewCell.swift
//  SampleTableViewJSON
//
//  Created by Olga Pudrovska on 3/28/15.
//  Copyright (c) 2016 Olga Pudrovska. All rights reserved.
//

import UIKit
import SDWebImage

let FeedTableViewCellIdentifier = "FeedTableViewCell"

class FeedTableViewCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet var contentImage: UIImageView?
    @IBOutlet var contentTitleLabel: UILabel?
    @IBOutlet var contentBlurbLabel: UILabel?
    @IBOutlet var contentDateLabel: UILabel?

    var viewData: FeedTableViewCellViewData?

    func update(with viewData: FeedTableViewCellViewData) {
        guard let viewData = self.viewData else { return }

        self.contentTitleLabel?.text = viewData.titleLabelText
        self.contentBlurbLabel?.text = viewData.blurbLabelText
        self.contentDateLabel?.text = viewData.dateLabelText

        guard let imageURL = URL(string: viewData.imageURL) else { return }
        self.contentImage?.sd_setImage(with: imageURL)
    }
}
