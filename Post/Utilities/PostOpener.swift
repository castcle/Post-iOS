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
//  PostOpener.swift
//  Post
//
//  Created by Castcle Co., Ltd. on 15/8/2564 BE.
//

import UIKit
import Core

public enum PostScene {
    case post(PostViewModel)
}

public struct PostOpener {
    public static func open(_ postScene: PostScene) -> UIViewController {
        switch postScene {
        case .post(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: PostNibVars.Storyboard.post, bundle: ConfigBundle.post)
            let vc = storyboard.instantiateViewController(withIdentifier: PostNibVars.ViewController.post) as? PostViewController
            vc?.viewModel = viewModel
            return vc ?? PostViewController()
        }
    }
}
