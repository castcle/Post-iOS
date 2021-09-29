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
//  QuoteCastBlogCell.swift
//  Post
//
//  Created by Tanakorn Phoochaliaw on 17/8/2564 BE.
//

import UIKit
import Core
import Networking
import Nantes

class QuoteCastBlogCell: UITableViewCell {

    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var verifyIcon: UIImageView!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var followButton: UIButton!
    @IBOutlet var lineView: UIView!
    
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var detailLabel: NantesLabel! {
        didSet {
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.Asset.lightBlue,
                              NSAttributedString.Key.font: UIFont.asset(.regular, fontSize: .overline)]
            self.detailLabel.attributedTruncationToken = NSAttributedString(string: " Read More...", attributes: attributes)
            self.detailLabel.numberOfLines = 2
        }
    }
    @IBOutlet var blogImageView: UIImageView!
    
    var content: Content? {
        didSet {
            if let content = self.content {
                self.detailLabel.text = content.contentPayload.message
                
                self.headerLabel.font = UIFont.asset(.medium, fontSize: .h4)
                self.headerLabel.textColor = UIColor.Asset.white
                self.detailLabel.font = UIFont.asset(.regular, fontSize: .overline)
                self.detailLabel.textColor = UIColor.Asset.lightGray
                
                self.headerLabel.text = content.contentPayload.header
                self.detailLabel.text = content.contentPayload.message
                
                let imageUrl = URL(string: content.contentPayload.cover)
                self.blogImageView.kf.setImage(with: imageUrl, placeholder: UIImage.Asset.placeholder, options: [.transition(.fade(0.5))])
                
                let url = URL(string: content.author.avatar)
                self.avatarImage.kf.setImage(with: url, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.5))])
                self.displayNameLabel.text = content.author.displayName
                self.dateLabel.text = content.postDate.timeAgoDisplay()
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func followAction(_ sender: Any) {
        self.followButton.isHidden = true
    }
}
