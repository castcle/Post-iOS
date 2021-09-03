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
//  CommentSectionController.swift
//  Post
//
//  Created by Tanakorn Phoochaliaw on 2/9/2564 BE.
//

import Core
import Networking
import IGListKit

public class CommentSectionController: ListSectionController {
    var comment: Comment?
    public var isTop: Bool = false
    public var isBottom: Bool = false
    
    public override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

// MARK: - Data Provider
extension CommentSectionController {
    public override func numberOfItems() -> Int {
        return (comment?.reply.count ?? 0) + 1
    }
    
    public override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else {
            return .zero
        }
        
        if index == 0 {
            if let lastMessage = self.comment?.comments.last {
                return CommentCell.cellSize(width: context.containerSize.width, text: lastMessage.message)
            } else {
                return .zero
            }
        } else {
            if let lastMessage = self.comment?.reply[index - 1].comments.last {
                return ReplyCell.cellSize(width: context.containerSize.width, text: lastMessage.message)
            } else {
                return .zero
            }
        }
    }
    
    public override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let comment = self.comment else {
            return UICollectionViewCell()
        }
        
        if index == 0 {
            let cell = collectionContext?.dequeueReusableCell(withNibName: PostNibVars.CollectionViewCell.comment, bundle: ConfigBundle.post, for: self, at: index) as? CommentCell
            cell?.backgroundColor = UIColor.Asset.darkGraphiteBlue
//            cell?.delegate = self
            if comment.isFirst {
                cell?.topLineView.isHidden = true
                cell?.bottomLineView.isHidden = false
            } else if comment.isLast {
                cell?.topLineView.isHidden = false
                cell?.bottomLineView.isHidden = true
            } else {
                cell?.topLineView.isHidden = false
                cell?.bottomLineView.isHidden = false
            }
            
            cell?.comment = comment
            return cell ?? CommentCell()
        } else {
            let cell = collectionContext?.dequeueReusableCell(withNibName: PostNibVars.CollectionViewCell.reply, bundle: ConfigBundle.post, for: self, at: index) as? ReplyCell
            cell?.backgroundColor = UIColor.Asset.darkGraphiteBlue
            if comment.isFirst {
                cell?.lineView.isHidden = false
            } else {
                cell?.lineView.isHidden = true
            }
            cell?.replyComment = comment.reply[index - 1]
            return cell ?? ReplyCell()
        }
    }
    
    public override func didUpdate(to object: Any) {
        self.comment = object as? Comment
    }
    
    public override func didSelectItem(at index: Int) {
        print(index)
    }
}
