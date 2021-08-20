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
//  PostViewModel.swift
//  Post
//
//  Created by Tanakorn Phoochaliaw on 16/8/2564 BE.
//

import Foundation
import Core
import Networking
import TLPhotoPicker

public enum PostType: String {
    case newCast = "New Cast"
    case quoteCast = "Quote Cast"
}

public final class PostViewModel {
    
    var limitCharacter: Int = 280
    var postText: String = ""
    var imageInsert: [TLPHAsset] = []
    var postType: PostType = .newCast
    var feed: Feed?
    var page: Page?
    
    public init(postType: PostType = .newCast, feed: Feed? = nil, page: Page = Page(name: UserState.shared.name, avatar: UserState.shared.avatar)) {
        self.postType = postType
        self.feed = feed
        self.page = page
    }
    
    func isCanPost() -> Bool {
        if !self.postText.isEmpty {
            if self.postText.count <= self.limitCharacter {
                return true
            } else {
                return false
            }
        } else {
            if self.imageInsert.count > 0 {
                return true
            } else {
                return false
            }
        }
    }
}
