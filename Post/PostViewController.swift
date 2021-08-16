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
//  PostViewController.swift
//  Post
//
//  Created by Tanakorn Phoochaliaw on 15/8/2564 BE.
//

import UIKit
import Core
import SwiftColor
import TLPhotoPicker

class PostViewController: UIViewController {

    @IBOutlet var titleView: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var blogSwitch: UISwitch!
    
    @IBOutlet var tableView: UITableView!
    
    var viewModel = PostViewModel()
    
    private lazy var castKeyboardInput: CastKeyboardInput = {
        let inputView = CastKeyboardInput(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 45))
        inputView.castButton.setTitle("Cast", for: .normal)
        inputView.castButton.setBackgroundImage(UIColor.Asset.darkGraphiteBlue.toImage(), for: .normal)
        inputView.castButton.setTitleColor(UIColor.Asset.gray, for: .normal)
        inputView.castButton.titleLabel?.font = UIFont.asset(.medium, fontSize: .body)
        inputView.castButton.capsule(color: UIColor.clear, borderWidth: 1.0, borderColor: UIColor.Asset.black)
        inputView.imageButton.setImage(UIImage.init(icon: .castcle(.image), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        inputView.castButton.addTarget(self, action: #selector(self.castAction), for: .touchUpInside)
        inputView.imageButton.addTarget(self, action: #selector(self.selectPhotoAction), for: .touchUpInside)
        
        return inputView
    }()
    
    enum PostViewControllerSection: Int, CaseIterable {
        case header = 0
        case newPost
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.titleView.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.backButton.setImage(UIImage.init(icon: .castcle(.back), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.titleLabel.font = UIFont.asset(.regular, fontSize: .h4)
        self.blogSwitch.tintColor = UIColor.Asset.darkGray
        self.blogSwitch.onTintColor = UIColor.Asset.gray
        self.blogSwitch.thumbTintColor = UIColor.Asset.white
        self.blogSwitch.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
        
        self.configureTableView()
    }
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: PostNibVars.TableViewCell.header, bundle: ConfigBundle.post), forCellReuseIdentifier: PostNibVars.TableViewCell.header)
        self.tableView.register(UINib(nibName: PostNibVars.TableViewCell.newPost, bundle: ConfigBundle.post), forCellReuseIdentifier: PostNibVars.TableViewCell.newPost)
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }
    
    @objc func switchValueDidChange(_ sender: UISwitch) {
        if sender.isOn {
            self.blogSwitch.thumbTintColor = UIColor.Asset.lightBlue
        } else {
            self.blogSwitch.thumbTintColor = UIColor.Asset.white
        }
    }
    
    @objc func castAction() {
        
    }
    
    @objc func selectPhotoAction() {
        let photosPickerViewController = TLPhotosPickerViewController()
        photosPickerViewController.delegate = self
        photosPickerViewController.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        photosPickerViewController.collectionView.backgroundColor = UIColor.clear
        photosPickerViewController.navigationBar.barTintColor = UIColor.Asset.darkGraphiteBlue
        photosPickerViewController.navigationBar.isTranslucent = false
        photosPickerViewController.titleLabel.font = UIFont.asset(.regular, fontSize: .overline)
        photosPickerViewController.subTitleLabel.font = UIFont.asset(.regular, fontSize: .small)
        
        photosPickerViewController.doneButton.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.asset(.medium, fontSize: .h4),
            NSAttributedString.Key.foregroundColor : UIColor.Asset.lightBlue
        ], for: .normal)
        photosPickerViewController.cancelButton.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.asset(.regular, fontSize: .body),
            NSAttributedString.Key.foregroundColor : UIColor.Asset.lightBlue
        ], for: .normal)

        var configure = TLPhotosPickerConfigure()
        configure.numberOfColumn = 3
        configure.maxSelectedAssets = 4
        configure.mediaType = .image
        configure.usedCameraButton = false
        configure.allowedLivePhotos = false
        configure.allowedPhotograph = true
        configure.allowedVideo = false
        configure.allowedVideoRecording = false
        configure.selectedColor = UIColor.Asset.lightBlue
        photosPickerViewController.configure = configure

        Utility.currentViewController().present(photosPickerViewController, animated: true, completion: nil)
    }

    private func updateCastToolBarButton(isHaveText: Bool) {
        if isHaveText {
            self.castKeyboardInput.castButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
            self.castKeyboardInput.castButton.setTitleColor(UIColor.Asset.white, for: .normal)
            self.castKeyboardInput.castButton.capsule(color: UIColor.clear, borderWidth: 1.0, borderColor: UIColor.Asset.lightBlue)
        } else {
            self.castKeyboardInput.castButton.setBackgroundImage(UIColor.Asset.darkGraphiteBlue.toImage(), for: .normal)
            self.castKeyboardInput.castButton.setTitleColor(UIColor.Asset.gray, for: .normal)
            self.castKeyboardInput.castButton.capsule(color: UIColor.clear, borderWidth: 1.0, borderColor: UIColor.Asset.black)
        }
    }
    
    private func updateImageToolBarButton() {
        if self.viewModel.imageInsert.isEmpty {
            self.castKeyboardInput.imageButton.setImage(UIImage.init(icon: .castcle(.image), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            self.castKeyboardInput.imageButton.setImage(UIImage.init(icon: .castcle(.image), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.lightBlue).withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PostViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return PostViewControllerSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case PostViewControllerSection.header.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: PostNibVars.TableViewCell.header, for: indexPath as IndexPath) as? HeaderPostTableViewCell
            cell?.backgroundColor = UIColor.clear
            return cell ?? HeaderPostTableViewCell()
        case PostViewControllerSection.newPost.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: PostNibVars.TableViewCell.newPost, for: indexPath as IndexPath) as? PostTextTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.delegate = self
            cell?.postView.inputAccessoryView = self.castKeyboardInput
            cell?.postView.becomeFirstResponder()
            return cell ?? PostTextTableViewCell()
        default:
            return UITableViewCell()
        }
    }
}

extension PostViewController: PostTextTableViewCellDelegate {
    func updateHeightOfRow(_ cell: PostTextTableViewCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = self.tableView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            self.tableView?.beginUpdates()
            self.tableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            if let thisIndexPath = self.tableView.indexPath(for: cell) {
                self.tableView.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
        
        let characterCount = textView.text.count
        if characterCount == 0 || characterCount > self.viewModel.limitCharacter {
            self.updateCastToolBarButton(isHaveText: false)
            self.viewModel.isCanPost = false
        } else {
            self.updateCastToolBarButton(isHaveText: true)
            self.viewModel.isCanPost = true
        }
    }
}

extension PostViewController: TLPhotosPickerViewControllerDelegate {
    func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {
        self.viewModel.imageInsert = withTLPHAssets
        self.updateImageToolBarButton()
//        if let asset = withTLPHAssets.first {
//            if let image = asset.fullResolutionImage {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    self.presentCropViewController(image: image)
//                }
//            }
//        }
        return true
    }
}
