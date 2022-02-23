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
//  Created by Castcle Co., Ltd. on 16/8/2564 BE.
//

import Foundation
import UIKit
import Core
import Networking
import TLPhotoPicker
import SwiftyJSON
import Defaults

public enum PostType: String {
    case newCast = "New Cast"
    case quoteCast = "Quote Cast"
}

public protocol PostViewModelDelegate {
    func didCreateContentFinish(success: Bool)
    func didQuotecastContentFinish(success: Bool)
}

public final class PostViewModel {
    
    public var delegate: PostViewModelDelegate?
    private var contentRepository: ContentRepository = ContentRepositoryImpl()
    var contentRequest: ContentRequest = ContentRequest()
    let tokenHelper: TokenHelper = TokenHelper()
    var featureSlug: String = "feed"
    var limitCharacter: Int = 280
    var postText: String = ""
    var imageInsert: [TLPHAsset] = []
    var postType: PostType = .newCast
    var content: Content?
    var page: Page?
    
    public init(postType: PostType = .newCast, content: Content? = nil, page: Page = Page().initCustom(id: UserManager.shared.id, displayName: UserManager.shared.displayName, castcleId: UserManager.shared.rawCastcleId, avatar: UserManager.shared.avatar, cover: UserManager.shared.cover, overview: UserManager.shared.overview, official: UserManager.shared.official)) {
        self.postType = postType
        self.content = content
        self.page = page
        self.tokenHelper.delegate = self
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
    
    func createContent() {
        self.imageInsert.forEach { asset in
            if let image = asset.fullResolutionImage {
                self.contentRequest.payload.image.append(image.resizeImage(targetSize: CGSize.init(width: 1024, height: 1024)).toBase64() ?? "")
            }
        }
        self.contentRequest.payload.message = self.postText
        self.contentRequest.castcleId = self.page?.castcleId ?? UserManager.shared.rawCastcleId
        self.contentRequest.type = .short
        self.contentRepository.createContent(featureSlug: self.featureSlug, contentRequest: self.contentRequest) { (success, response, isRefreshToken) in
            if success {
                self.delegate?.didCreateContentFinish(success: success)
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.didCreateContentFinish(success: false)
                }
            }
        }
    }
    
    func quotecastContent() {
        guard let content = self.content else { return }
        self.contentRequest.message = self.postText
        self.contentRequest.castcleId = self.page?.castcleId ?? UserManager.shared.rawCastcleId
        self.contentRequest.contentId = content.id
        self.contentRepository.quotecastContent(contentRequest: self.contentRequest) { (success, response, isRefreshToken) in
            if success {
                self.delegate?.didQuotecastContentFinish(success: success)
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.didQuotecastContentFinish(success: false)
                }
            }
        }
    }
}

extension PostViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.postType == .newCast {
            self.createContent()
        } else if self.postType == .quoteCast {
            self.quotecastContent()
        }
    }
}
