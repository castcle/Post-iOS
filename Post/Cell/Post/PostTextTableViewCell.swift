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
//  PostTextTableViewCell.swift
//  Post
//
//  Created by Castcle Co., Ltd. on 16/8/2564 BE.
//

import UIKit
import Core
import Networking
import DropDown
import Atributika

protocol PostTextTableViewCellDelegate: AnyObject {
    func updateHeightOfRow(_ cell: PostTextTableViewCell, _ textView: UITextView)
}

class PostTextTableViewCell: UITableViewCell {

    @IBOutlet var postView: UITextView!
    @IBOutlet var limitLabel: UILabel!

    var delegate: PostTextTableViewCellDelegate?
    private var dataRepository: DataRepository = DataRepositoryImpl()
    private var limitCharacter: Int = 280
    let mentionDropDown = DropDown()
    let hastagDropDown = DropDown()
    var isShowDropDown: Bool = false
    var characterCount: Int = 0
    var mentionText: String = ""
    var viewModel = PostTextViewModel()
    let tokenHelper: TokenHelper = TokenHelper()
    var state: State = .none

    let hastags = Style.font(UIFont.asset(.regular, fontSize: .body)).foregroundColor(UIColor.Asset.lightBlue)
    let mentions = Style.font(UIFont.asset(.regular, fontSize: .body)).foregroundColor(UIColor.Asset.lightBlue)
    let all = Style.font(UIFont.asset(.regular, fontSize: .body)).foregroundColor(UIColor.Asset.white)

    private var currentTaggingRange: NSRange?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.postView.delegate = self
        self.postView.font = UIFont.asset(.regular, fontSize: .body)
        self.postView.textColor = UIColor.Asset.white
        self.limitLabel.font = UIFont.asset(.bold, fontSize: .small)
        self.limitLabel.textColor = UIColor.Asset.white
        self.limitLabel.text = "\(self.limitCharacter)"
        DropDown.appearance().textColor = UIColor.Asset.white
        DropDown.appearance().selectedTextColor = UIColor.Asset.white
        DropDown.appearance().textFont = UIFont.asset(.bold, fontSize: .overline)
        DropDown.appearance().backgroundColor = UIColor.Asset.darkGray
        DropDown.appearance().selectionBackgroundColor = UIColor.Asset.darkGray
        DropDown.appearance().cellHeight = 70
        DropDown.appearance().shadowColor = UIColor.clear
        self.tokenHelper.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setupMentionDropDown() {
        self.mentionDropDown.anchorView = self.postView
        self.mentionDropDown.bottomOffset = CGPoint(x: 0, y: self.postView.bounds.height)

        let mentionDataSource: [String] = self.viewModel.mention.map { $0.name }
        self.mentionDropDown.dataSource = mentionDataSource

        self.mentionDropDown.cellNib = UINib(nibName: PostNibVars.TableViewCell.mentionCell, bundle: ConfigBundle.post)

        self.mentionDropDown.customCellConfiguration = { (index: Index, _, cell: DropDownCell) -> Void in
            guard let cell = cell as? MentionTableViewCell else { return }
            let mention = self.viewModel.mention[index]
            let url = URL(string: mention.avatar)
            cell.avatarImage.kf.setImage(with: url, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
            cell.idLabel.text = mention.id
        }

        self.mentionDropDown.selectionAction = { [weak self] (index, _) in
            guard let self = self else { return }
            self.updateTaggedList(allText: self.postView.text, tagText: self.viewModel.mention[index].id)
            self.mentionDropDown.hide()
            self.isShowDropDown = false
        }

        self.mentionDropDown.cancelAction = { [unowned self] in
            self.isShowDropDown = false
        }
    }

    func setupHastagDropDown() {
        self.hastagDropDown.anchorView = self.postView
        self.hastagDropDown.bottomOffset = CGPoint(x: 0, y: self.postView.bounds.height)
        self.hastagDropDown.dataSource = self.viewModel.hastagDataSource
        self.hastagDropDown.cellNib = UINib(nibName: PostNibVars.TableViewCell.hashtagCell, bundle: ConfigBundle.post)
        self.hastagDropDown.selectionAction = { [weak self] (_, item) in
            guard let self = self else { return }
            self.updateTaggedList(allText: self.postView.text, tagText: item)
            self.hastagDropDown.hide()
            self.isShowDropDown = false
        }
        self.mentionDropDown.cancelAction = { [unowned self] in
            self.isShowDropDown = false
        }
    }

    private func checkCharacterCount() {
        self.characterCount = self.postView.text.count
        self.limitLabel.text = "\(self.limitCharacter - self.characterCount)"
        if self.characterCount > self.limitCharacter {
            self.limitLabel.textColor = UIColor.Asset.denger
        } else {
            self.limitLabel.textColor = UIColor.Asset.white
        }
    }
}

extension PostTextTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.characterCount = textView.text.count
        self.tagging(textView: textView)
        if textView.text.isEmpty {
            self.isShowDropDown = false
            self.mentionDropDown.hide()
            self.hastagDropDown.hide()
        }

        if let deletate = delegate {
            deletate.updateHeightOfRow(self, textView)
        }

        self.updateTextView()
        self.checkCharacterCount()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "@" {
            if !self.isShowDropDown {
                self.isShowDropDown = true
                self.getMention()
            }
        } else if text == "#" {
            if !self.isShowDropDown {
                self.isShowDropDown = true
                self.getHastag()
            }
        } else if text == " " {
            self.isShowDropDown = false
            self.mentionDropDown.hide()
            self.hastagDropDown.hide()
        }
        return true
    }

    private func getMention() {
        self.state = .getMention
        self.dataRepository.getMentions(keyword: "@") { (success, response, isRefreshToken) in
            if success {
                self.viewModel.mappingMention(response: response)
                self.setupMentionDropDown()
                self.mentionDropDown.show()
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }

    private func getHastag() {
        self.state = .getHastag
        self.dataRepository.getHashtag(keyword: "#") { (success, response, isRefreshToken) in
            if success {
                self.viewModel.mappingHastag(response: response)
                self.setupHastagDropDown()
                self.hastagDropDown.show()
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
}

extension PostTextTableViewCell {
    private func tagging(textView: UITextView) {
        let selectedLocation = textView.selectedRange.location
        let taggingText = (textView.text as NSString).substring(with: NSRange(location: 0, length: selectedLocation))
        let space: Character = " "
        let lineBrak: Character = "\n"
        var tagable: Bool = false
        var characters: [Character] = []
        for char in Array(taggingText).reversed() {
            if char == "@".first || char == "#".first {
                characters.append(char)
                tagable = true
                break
            } else if char == space || char == lineBrak {
                tagable = false
                break
            }
            characters.append(char)
        }

        guard tagable else {
            currentTaggingRange = nil
            return
        }

        let data = matchedData(taggingCharacters: characters, selectedLocation: selectedLocation, taggingText: taggingText)
        currentTaggingRange = data.0
    }

    private func matchedData(taggingCharacters: [Character], selectedLocation: Int, taggingText: String) -> (NSRange?, String?) {
        var matchedRange: NSRange?
        var matchedString: String?
        let tag = String(taggingCharacters.reversed())
        let textRange = NSRange(location: (selectedLocation - tag.count), length: tag.count)
        guard tag == "#" || tag == "@" else {
            if tag.hasPrefix("#") {
                do {
                    let hastagRegex = try NSRegularExpression(pattern: RegexpParser.hashtagPattern)
                    let matched = hastagRegex.matches(in: taggingText, options: .reportCompletion, range: textRange)
                    if matched.count > 0, let range = matched.last?.range {
                        matchedRange = range
                        matchedString = (taggingText as NSString).substring(with: range).replacingOccurrences(of: "#", with: "")
                    }
                    return (matchedRange, matchedString)
                } catch {
                    return (matchedRange, matchedString)
                }
            } else {
                do {
                    let mentionRegex = try NSRegularExpression(pattern: RegexpParser.mentionPattern)
                    let matched = mentionRegex.matches(in: taggingText, options: .reportCompletion, range: textRange)
                    if matched.count > 0, let range = matched.last?.range {
                        matchedRange = range
                        matchedString = (taggingText as NSString).substring(with: range).replacingOccurrences(of: "@", with: "")
                    }
                    return (matchedRange, matchedString)
                } catch {
                    return (matchedRange, matchedString)
                }
            }
        }

        let symbol = tag
        matchedRange = textRange
        matchedString = symbol
        return (matchedRange, matchedString)
    }

    public struct TaggingModel {
        public var text: String
        public var range: NSRange
    }

    public func updateTaggedList(allText: String, tagText: String) {
        guard let range = currentTaggingRange else {return}
        let replace = tagText.appending(" ")
        let changed = (allText as NSString).replacingCharacters(in: range, with: replace)
        self.postView.text = changed
        self.updateAttributeText(selectedLocation: range.location+replace.count)
    }

    public func updateTextView() {
        let str = postView.text
            .styleMentions(mentions)
            .styleHashtags(hastags)
            .styleAll(all)
            .attributedString
        self.postView.attributedText = str
    }

    private func updateAttributeText(selectedLocation: Int) {
        let str = postView.text
            .styleMentions(mentions)
            .styleHashtags(hastags)
            .styleAll(all)
            .attributedString
        self.postView.attributedText = str
        self.checkCharacterCount()
        if let deletate = delegate {
            deletate.updateHeightOfRow(self, self.postView)
        }
        self.postView.selectedRange = NSRange(location: selectedLocation, length: 0)
    }
}

extension PostTextTableViewCell: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.state == .getMention {
            self.getMention()
        } else if self.state == .getHastag {
            self.getHastag()
        }
    }
}
