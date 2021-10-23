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
//  QuoteCastTextLinkCell.swift
//  Post
//
//  Created by Castcle Co., Ltd. on 17/8/2564 BE.
//

import UIKit
import LinkPresentation
import Core
import Networking
import ActiveLabel
import SwiftLinkPreview
import SkeletonView

class QuoteCastTextLinkCell: UITableViewCell {

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
    
    @IBOutlet var linkContainer: UIView!
    @IBOutlet var titleLinkView: UIView!
    @IBOutlet var linkImage: UIImageView!
    @IBOutlet var linkTitleLabel: UILabel!
    @IBOutlet var linkDescriptionLabel: UILabel!
    @IBOutlet var skeletonView: UIView!
    @IBOutlet var verifyConstraintWidth: NSLayoutConstraint!
    
    private var result = Response()
    private let slp = SwiftLinkPreview(cache: InMemoryCache())
    
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
        self.linkContainer.custom(color: UIColor.Asset.darkGraphiteBlue, cornerRadius: 12, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.skeletonView.custom(cornerRadius: 12, borderWidth: 1, borderColor: UIColor.Asset.gray)
        self.linkContainer.custom(cornerRadius: 12, borderWidth: 1, borderColor: UIColor.Asset.gray)
        self.titleLinkView.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.linkTitleLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.linkTitleLabel.textColor = UIColor.Asset.white
        self.linkDescriptionLabel.font = UIFont.asset(.regular, fontSize: .small)
        self.linkDescriptionLabel.textColor = UIColor.Asset.lightGray
        self.skeletonView.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: UIColor.Asset.gray))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configCell(content: Content?) {
        guard let content = content else { return }
        
        self.detailLabel.text = content.contentPayload.message
        self.skeletonView.isHidden = false
        self.linkContainer.isHidden = true
        if let link = content.contentPayload.link.first {
            self.loadLink(link: link.url)
        } else if let link = content.contentPayload.message.detectedFirstLink {
            self.loadLink(link: link)
        } else {
            self.setData()
        }
        
        let avatar = (content.author.castcleId == UserManager.shared.rawCastcleId ?  UserManager.shared.avatar : content.author.avatar)
        let url = URL(string: avatar)
        self.avatarImage.kf.setImage(with: url, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.5))])
        self.displayNameLabel.text = content.author.displayName
        self.dateLabel.text = content.postDate.timeAgoDisplay()
        if UserManager.shared.rawCastcleId == content.author.castcleId {
            self.followButton.isHidden = true
        } else {
            self.followButton.isHidden = false
        }
        if content.author.verified.official {
            self.verifyConstraintWidth.constant = 15.0
            self.verifyIcon.isHidden = false
        } else {
            self.verifyConstraintWidth.constant = 0.0
            self.verifyIcon.isHidden = true
        }
    }
    
    private func loadLink(link: String) {
        if let cached = self.slp.cache.slp_getCachedResponse(url: link) {
            self.result = cached
            self.setData()
        } else {
            self.slp.preview(link, onSuccess: { result in
                self.result = result
                self.setData()
            }, onError: { error in
                self.setData()
            })
        }
    }
    
    private func setData() {
        UIView.transition(with: self, duration: 0.35, options: .transitionCrossDissolve, animations: {
            self.skeletonView.isHidden = true
            self.linkContainer.isHidden = false
        })
        
        // MARK: - Image
        if let value = self.result.icon {
            let url = URL(string: value)
            self.linkImage.kf.setImage(with: url, placeholder: UIImage.Asset.placeholder, options: [.transition(.fade(0.5))])
        } else {
            self.linkImage.image = UIImage.Asset.placeholder
        }
        
        // MARK: - Title
        if let value: String = self.result.title {
            self.linkTitleLabel.text = value.isEmpty ? "" : value
        } else {
            self.linkTitleLabel.text = ""
        }
        
        // MARK: - Description
        if let value: String = self.result.description {
            self.linkDescriptionLabel.text = value.isEmpty ? "" : value
        } else {
            self.linkDescriptionLabel.text = ""
        }
    }
    
    @IBAction func followAction(_ sender: Any) {
        self.followButton.isHidden = true
    }
}
