//  Copyright (c) 2021, Castcle and/or its affiliates. All rights reserved.
//  DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
//
//  This code is free software; you can redistribute it and/or modify it
//  under the terms of the GNU General Public License version 3 only, as
//  published by the Free Software Foundation.
//
//  This code is distributed in the hope that it will be useful, but WITHOUT
//  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
//  FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
//  version 3 for more details (a copy is included in the LICENSE file that
//  accompanied this code).
//
//  You should have received a copy of the GNU General Public License version
//  3 along with this work; if not, write to the Free Software Foundation,
//  Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
//
//  Please contact Castcle, 22 Phet Kasem 47/2 Alley, Bang Khae, Bangkok,
//  Thailand 10160, or visit www.castcle.com if you need additional information
//  or have any questions.
//
//  QuoteCastImageXMoreCell.swift
//  Post
//
//  Created by Tanakorn Phoochaliaw on 17/8/2564 BE.
//

import UIKit
import Core
import Networking
import ActiveLabel

class QuoteCastImageXMoreCell: UITableViewCell {

    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var verifyIcon: UIImageView!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var followButton: UIButton!
    @IBOutlet var lineView: UIView!
    @IBOutlet var detailLabel: ActiveLabel! {
        didSet {
            self.detailLabel.customize { label in
                label.font = UIFont.asset(.regular, fontSize: .overline)
                label.numberOfLines = 0
                label.enabledTypes = [.mention, .hashtag, .url]
                label.textColor = UIColor.Asset.white
                label.hashtagColor = UIColor.Asset.lightBlue
                label.mentionColor = UIColor.Asset.lightBlue
                label.URLColor = UIColor.Asset.lightBlue
            }
        }
    }
    
    @IBOutlet var imageContainer: UIView!
    @IBOutlet var firstImageView: UIImageView!
    @IBOutlet var secondImageView: UIImageView!
    @IBOutlet var thirdImageView: UIImageView!
    @IBOutlet var fourthImageView: UIImageView!
    @IBOutlet var moreImageView: UIImageView!
    @IBOutlet var moreLabel: UILabel!
    
    var feed: Feed? {
        didSet {
            if let feed = self.feed {
                self.detailLabel.text = feed.feedPayload.contentPayload.content
                
                self.moreImageView.image = UIColor.Asset.black.toImage()
                self.moreLabel.font = UIFont.asset(.medium, fontSize: .custom(size: 45))
                
                if feed.feedPayload.contentPayload.photo.count > 4 {
                    self.moreImageView.isHidden = false
                    self.moreImageView.alpha = 0.5
                    self.moreLabel.isHidden = false
                    self.moreLabel.text = "+\(feed.feedPayload.contentPayload.photo.count - 3)"
                } else {
                    self.moreImageView.isHidden = true
                    self.moreLabel.isHidden = true
                }
                
                if feed.feedPayload.contentPayload.photo.count >= 4 {
                    let firstUrl = URL(string: feed.feedPayload.contentPayload.photo[0].url)
                    self.firstImageView.kf.setImage(with: firstUrl, placeholder: UIImage.Asset.placeholder, options: [.transition(.fade(0.5))])
                    
                    let secondUrl = URL(string: feed.feedPayload.contentPayload.photo[1].url)
                    self.secondImageView.kf.setImage(with: secondUrl, placeholder: UIImage.Asset.placeholder, options: [.transition(.fade(0.5))])
                    
                    let thirdUrl = URL(string: feed.feedPayload.contentPayload.photo[2].url)
                    self.thirdImageView.kf.setImage(with: thirdUrl, placeholder: UIImage.Asset.placeholder, options: [.transition(.fade(0.5))])
                    
                    let fourthUrl = URL(string: feed.feedPayload.contentPayload.photo[3].url)
                    self.fourthImageView.kf.setImage(with: fourthUrl, placeholder: UIImage.Asset.placeholder, options: [.transition(.fade(0.5))])
                }
                
                let url = URL(string: feed.feedPayload.author.avatar)
                self.avatarImage.kf.setImage(with: url, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.5))])
                self.displayNameLabel.text = feed.feedPayload.author.displayName
                self.dateLabel.text = feed.feedPayload.postDate.timeAgoDisplay()
            } else {
                return
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.avatarImage.circle(color: UIColor.Asset.white)
        self.displayNameLabel.font = UIFont.asset(.medium, fontSize: .overline)
        self.displayNameLabel.textColor = UIColor.Asset.white
        self.dateLabel.font = UIFont.asset(.regular, fontSize: .custom(size: 10))
        self.dateLabel.textColor = UIColor.Asset.lightGray
        
        self.followButton.titleLabel?.font = UIFont.asset(.medium, fontSize: .overline)
        self.followButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
        self.verifyIcon.image = UIImage.init(icon: .castcle(.verify), size: CGSize(width: 15, height: 15), textColor: UIColor.Asset.lightBlue)
        self.lineView.custom(color: UIColor.clear, cornerRadius: 12, borderWidth: 1, borderColor: UIColor.Asset.lightGray)
        self.imageContainer.custom(cornerRadius: 12)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func followAction(_ sender: Any) {
        self.followButton.isHidden = true
    }
}
