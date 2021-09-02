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
//  CommentViewController.swift
//  Post
//
//  Created by Tanakorn Phoochaliaw on 2/9/2564 BE.
//

import UIKit
import Core
import Component
import Networking
import IGListKit
import ShiftTransitions

class CommentViewController: UIViewController {

    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        return view
    }()
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    @IBOutlet var titleView: UIView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    
    var viewModel = CommentViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.backgroundColor = UIColor.clear
        self.contentView.addSubview(self.collectionView)
        self.adapter.collectionView = self.collectionView
        self.adapter.dataSource = self
        
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.titleView.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.contentView.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.backButton.setImage(UIImage.init(icon: .castcle(.back), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.titleLabel.font = UIFont.asset(.regular, fontSize: .h4)
        self.titleLabel.textColor = UIColor.Asset.white
        
        self.shift.baselineDuration = 0.3
        self.shift.defaultAnimation = DefaultAnimations.Scale(.up)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titleLabel.text = "Post of \(self.viewModel.feed?.feedPayload.author.displayName ?? "")"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionView.frame = self.contentView.bounds
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - ListAdapterDataSource
extension CommentViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var items: [ListDiffable] = [] as [ListDiffable]
        if let feed = self.viewModel.feed {
            items.append(feed as ListDiffable)
        }
        
        return items
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
//        if object is HashtagShelf {
//            return HashtagSectionController()
//        } else if object is Feed {
//
//        } else {
//            return NewPostSectionController()
//        }
        let section = FeedSectionController()
        section.delegate = self
        return section
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension CommentViewController: FeedSectionControllerDelegate {
    func didTabProfile() {
//        Utility.currentViewController().navigationController?.pushViewController(ProfileOpener.open(.userDetail(UserDetailViewModel(isMe: false))), animated: true)
    }
    
    func didTabComment(feed: Feed) {
//        let alert = UIAlertController(title: nil, message: "Go to comment view", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//        Utility.currentViewController().present(alert, animated: true, completion: nil)
    }
    
    func didTabQuoteCast(feed: Feed, page: Page) {
//        let vc = PostOpener.open(.post(PostViewModel(postType: .quoteCast, feed: feed, page: page)))
//        vc.modalPresentationStyle = .fullScreen
//        tabBarController?.present(vc, animated: true, completion: nil)
    }
    
    func didAuthen() {
//        Utility.currentViewController().presentPanModal(AuthenOpener.open(.signUpMethod) as! SignUpMethodViewController)
    }
}
