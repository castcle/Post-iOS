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
//  ImagePostTableViewCell.swift
//  Post
//
//  Created by Castcle Co., Ltd. on 16/8/2564 BE.
//

import UIKit
import Core
import TLPhotoPicker
import SwiftColor

protocol ImagePostTableViewCellDelegate {
    func imagePostTableViewCell(_ cell: ImagePostTableViewCell, didRemoveAt index: Int)
}

class ImagePostTableViewCell: UITableViewCell {

    @IBOutlet var containerView: UIView!
    
    @IBOutlet var imageX1View: UIView!
    @IBOutlet var image11: UIImageView!
    @IBOutlet var button11: UIButton!
    
    @IBOutlet var imageX2View: UIView!
    @IBOutlet var image21: UIImageView!
    @IBOutlet var image22: UIImageView!
    @IBOutlet var button21: UIButton!
    @IBOutlet var button22: UIButton!
    
    @IBOutlet var imageX3View: UIView!
    @IBOutlet var image31: UIImageView!
    @IBOutlet var image32: UIImageView!
    @IBOutlet var image33: UIImageView!
    @IBOutlet var button31: UIButton!
    @IBOutlet var button32: UIButton!
    @IBOutlet var button33: UIButton!
    
    @IBOutlet var imageX4View: UIView!
    @IBOutlet var image41: UIImageView!
    @IBOutlet var image42: UIImageView!
    @IBOutlet var image43: UIImageView!
    @IBOutlet var image44: UIImageView!
    @IBOutlet var button41: UIButton!
    @IBOutlet var button42: UIButton!
    @IBOutlet var button43: UIButton!
    @IBOutlet var button44: UIButton!
    
    @IBOutlet var containerConstraint: NSLayoutConstraint!
    
    var delegate: ImagePostTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let incorrectImage = UIImage.init(icon: .castcle(.incorrect), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white)
        
        self.containerView.custom(cornerRadius: 12)
        self.button11.setBackgroundImage(UIColor.Asset.gray.toImage()?.alpha(0.4), for: .normal)
        self.button11.setImage(incorrectImage, for: .normal)
        self.button11.tintColor = UIColor.Asset.white
        self.button11.capsule()
        self.button21.setBackgroundImage(UIColor.Asset.gray.toImage()?.alpha(0.4), for: .normal)
        self.button21.setImage(incorrectImage, for: .normal)
        self.button21.tintColor = UIColor.Asset.white
        self.button21.capsule()
        self.button22.setBackgroundImage(UIColor.Asset.gray.toImage()?.alpha(0.4), for: .normal)
        self.button22.setImage(incorrectImage, for: .normal)
        self.button22.tintColor = UIColor.Asset.white
        self.button22.capsule()
        self.button31.setBackgroundImage(UIColor.Asset.gray.toImage()?.alpha(0.4), for: .normal)
        self.button31.setImage(incorrectImage, for: .normal)
        self.button31.tintColor = UIColor.Asset.white
        self.button31.capsule()
        self.button32.setBackgroundImage(UIColor.Asset.gray.toImage()?.alpha(0.4), for: .normal)
        self.button32.setImage(incorrectImage, for: .normal)
        self.button32.tintColor = UIColor.Asset.white
        self.button32.capsule()
        self.button33.setBackgroundImage(UIColor.Asset.gray.toImage()?.alpha(0.4), for: .normal)
        self.button33.setImage(incorrectImage, for: .normal)
        self.button33.tintColor = UIColor.Asset.white
        self.button33.capsule()
        self.button41.setBackgroundImage(UIColor.Asset.gray.toImage()?.alpha(0.4), for: .normal)
        self.button41.setImage(incorrectImage, for: .normal)
        self.button41.tintColor = UIColor.Asset.white
        self.button41.capsule()
        self.button42.setBackgroundImage(UIColor.Asset.gray.toImage()?.alpha(0.4), for: .normal)
        self.button42.setImage(incorrectImage, for: .normal)
        self.button42.tintColor = UIColor.Asset.white
        self.button42.capsule()
        self.button43.setBackgroundImage(UIColor.Asset.gray.toImage()?.alpha(0.4), for: .normal)
        self.button43.setImage(incorrectImage, for: .normal)
        self.button43.tintColor = UIColor.Asset.white
        self.button43.capsule()
        self.button44.setBackgroundImage(UIColor.Asset.gray.toImage()?.alpha(0.4), for: .normal)
        self.button44.setImage(incorrectImage, for: .normal)
        self.button44.tintColor = UIColor.Asset.white
        self.button44.capsule()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configCell(image: [TLPHAsset]) {
        var imageHeight: Double = 0
        if image.count == 0 {
            imageHeight = 0
        } else if image.count > 2  {
            imageHeight = UIView.aspectRatioCalculator(ratioWidth: 1, ratioHeight: 1, pixelsWidth: Double(UIScreen.main.bounds.width - 30))
        } else {
            imageHeight = UIView.aspectRatioCalculator(ratioWidth: 16, ratioHeight: 9, pixelsWidth: Double(UIScreen.main.bounds.width - 30))
        }
        
        self.containerConstraint.constant = CGFloat(imageHeight)
        
        if image.count == 1 {
            self.imageX1View.isHidden = false
            self.imageX2View.isHidden = true
            self.imageX3View.isHidden = true
            self.imageX4View.isHidden = true
            
            self.image11.image = image[0].fullResolutionImage
        } else if image.count == 2 {
            self.imageX1View.isHidden = true
            self.imageX2View.isHidden = false
            self.imageX3View.isHidden = true
            self.imageX4View.isHidden = true
            
            self.image21.image = image[0].fullResolutionImage
            self.image22.image = image[1].fullResolutionImage
        } else if image.count == 3 {
            self.imageX1View.isHidden = true
            self.imageX2View.isHidden = true
            self.imageX3View.isHidden = false
            self.imageX4View.isHidden = true
            
            self.image31.image = image[0].fullResolutionImage
            self.image32.image = image[1].fullResolutionImage
            self.image33.image = image[2].fullResolutionImage
        } else if image.count == 4 {
            self.imageX1View.isHidden = true
            self.imageX2View.isHidden = true
            self.imageX3View.isHidden = true
            self.imageX4View.isHidden = false
            
            self.image41.image = image[0].fullResolutionImage
            self.image42.image = image[1].fullResolutionImage
            self.image43.image = image[2].fullResolutionImage
            self.image44.image = image[3].fullResolutionImage
        } else {
            self.imageX1View.isHidden = true
            self.imageX2View.isHidden = true
            self.imageX3View.isHidden = true
            self.imageX4View.isHidden = true
        }
    }
    
    @IBAction func action11(_ sender: Any) {
        self.delegate?.imagePostTableViewCell(self, didRemoveAt: 0)
    }
    
    @IBAction func action21(_ sender: Any) {
        self.delegate?.imagePostTableViewCell(self, didRemoveAt: 0)
    }
    
    @IBAction func action22(_ sender: Any) {
        self.delegate?.imagePostTableViewCell(self, didRemoveAt: 1)
    }
    
    @IBAction func action31(_ sender: Any) {
        self.delegate?.imagePostTableViewCell(self, didRemoveAt: 0)
    }
    
    @IBAction func action32(_ sender: Any) {
        self.delegate?.imagePostTableViewCell(self, didRemoveAt: 1)
    }
    
    @IBAction func action33(_ sender: Any) {
        self.delegate?.imagePostTableViewCell(self, didRemoveAt: 2)
    }
    
    @IBAction func action41(_ sender: Any) {
        self.delegate?.imagePostTableViewCell(self, didRemoveAt: 0)
    }
    
    @IBAction func action42(_ sender: Any) {
        self.delegate?.imagePostTableViewCell(self, didRemoveAt: 1)
    }
    
    @IBAction func action43(_ sender: Any) {
        self.delegate?.imagePostTableViewCell(self, didRemoveAt: 2)
    }
    
    @IBAction func action44(_ sender: Any) {
        self.delegate?.imagePostTableViewCell(self, didRemoveAt: 3)
    }
}
