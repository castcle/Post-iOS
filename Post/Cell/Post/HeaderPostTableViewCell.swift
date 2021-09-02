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
//  HeaderPostTableViewCell.swift
//  Post
//
//  Created by Tanakorn Phoochaliaw on 16/8/2564 BE.
//

import UIKit
import Core
import Kingfisher

class HeaderPostTableViewCell: UITableViewCell {

    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var verifyIcon: UIImageView!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var statusView: UIView!
    @IBOutlet var globalIcon: UIImageView!
    @IBOutlet var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.avatarImage.circle(color: UIColor.Asset.white)
        self.displayNameLabel.font = UIFont.asset(.medium, fontSize: .overline)
        self.displayNameLabel.textColor = UIColor.Asset.white
        self.verifyIcon.image = UIImage.init(icon: .castcle(.verify), size: CGSize(width: 15, height: 15), textColor: UIColor.Asset.lightBlue)
        self.statusLabel.font = UIFont.asset(.regular, fontSize: .small)
        self.statusLabel.textColor = UIColor.Asset.lightGray
        self.globalIcon.image = UIImage.init(icon: .castcle(.global), size: CGSize(width: 15, height: 15), textColor: UIColor.Asset.lightGray)
        self.statusView.custom(color: UIColor.Asset.darkGray, cornerRadius: 5.0, borderWidth: 1.0, borderColor: UIColor.Asset.black)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configCell(page: Page?) {
        guard let page = page else { return }
        let url = URL(string: page.avatar)
        self.avatarImage.kf.setImage(with: url)
        self.displayNameLabel.text = page.name
    }
}
