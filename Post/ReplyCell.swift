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
//  ReplyCell.swift
//  Post
//
//  Created by Tanakorn Phoochaliaw on 3/9/2564 BE.
//

import UIKit
import Core
import Networking
import ActiveLabel

class ReplyCell: UICollectionViewCell {

    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var lineView: UIView!
    @IBOutlet var commentLabel: ActiveLabel! {
        didSet {
            self.commentLabel.customize { label in
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
    
    var replyComment: ReplyComment? {
        didSet {
            guard let replyComment = self.replyComment else { return }
            guard let laseMessage = replyComment.comments.last else { return }
            self.commentLabel.text = laseMessage.message
            
            let url = URL(string: replyComment.author.avatar)
            self.avatarImage.kf.setImage(with: url)
            self.displayNameLabel.text = replyComment.author.displayName
            self.dateLabel.text = laseMessage.commentDate.timeAgoDisplay()
            
            self.commentLabel.handleHashtagTap { hashtag in
                let alert = UIAlertController(title: nil, message: "Go to hastag view", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                Utility.currentViewController().present(alert, animated: true, completion: nil)
            }
            self.commentLabel.handleMentionTap { mention in
                let alert = UIAlertController(title: nil, message: "Go to mention view", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                Utility.currentViewController().present(alert, animated: true, completion: nil)
            }
            self.commentLabel.handleURLTap { url in
                let alert = UIAlertController(title: nil, message: "Go to url view", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                Utility.currentViewController().present(alert, animated: true, completion: nil)
            }
            
            self.updateUi()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.avatarImage.circle(color: UIColor.Asset.white)
        self.displayNameLabel.font = UIFont.asset(.medium, fontSize: .overline)
        self.displayNameLabel.textColor = UIColor.Asset.white
        self.dateLabel.font = UIFont.asset(.regular, fontSize: .small)
        self.dateLabel.textColor = UIColor.Asset.lightGray
        self.lineView.backgroundColor = UIColor.Asset.lightGray
    }

    static func cellSize(width: CGFloat, text: String) -> CGSize {
        let label = ActiveLabel(frame: CGRect(x: 0, y: 0, width: width - 110, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.enabledTypes = [.mention, .hashtag, .url]
        label.text = text
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont.asset(.regular, fontSize: .overline)
        label.sizeToFit()
        return CGSize(width: width, height: (label.frame.height + 120))
    }
    
    @IBAction func likeAction(_ sender: Any) {
        if UserState.shared.isLogin {
            guard let replyComment = self.replyComment else { return }

//            if feed.feedPayload.liked.isLike {
//                self.likeRepository.unliked(feedUuid: feed.feedPayload.id) { success in
//                    print("Unliked : \(success)")
//                }
//            } else {
//                self.likeRepository.liked(feedUuid: feed.feedPayload.id) { success in
//                    print("Liked : \(success)")
//                }
//            }

            replyComment.like.isLike.toggle()
            self.updateUi()
        }
    }
    
    private func updateUi() {
        guard let replyComment = self.replyComment else { return }
        
        if replyComment.like.isLike {
            self.likeButton.titleLabel?.font = UIFont.asset(.medium, fontSize: .small)
            self.likeButton.setIcon(prefixText: "", prefixTextColor: UIColor.Asset.lightBlue, icon: .castcle(.like), iconColor: UIColor.Asset.lightBlue, postfixText: "  Like", postfixTextColor: UIColor.Asset.lightBlue, forState: .normal, textSize: 12, iconSize: 14)
        } else {
            self.likeButton.titleLabel?.font = UIFont.asset(.medium, fontSize: .small)
            self.likeButton.setIcon(prefixText: "", prefixTextColor: UIColor.Asset.white, icon: .castcle(.like), iconColor: UIColor.Asset.white, postfixText: "  Like", postfixTextColor: UIColor.Asset.white, forState: .normal, textSize: 12, iconSize: 14)
        }
    }
}
