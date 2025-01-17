//
//  EmojiPreviewer.swift
//  EmojiPicker
//
//  Created by levantAJ on 13/11/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

import UIKit

protocol EmojiPreviewable {
    func brief(sourceView: UIView, sourceRect: CGRect, emoji: Emoji, emojiFontSize: CGFloat, isDarkMode: Bool)
    func preview(sourceView: UIView, sourceRect: CGRect, emoji: Emoji, emojiFontSize: CGFloat, isDarkMode: Bool, completion: ((String) -> Void)?)
    func hide()
}

final class EmojiPreviewer: UIView {
    @IBOutlet var singleEmojiWrapperView: UIView!
    @IBOutlet var singleEmojiImageView: UIImageView!
    @IBOutlet var singleEmojiLabel: UILabel!

    @IBOutlet var multipleEmojisWrapperView: UIView!
    @IBOutlet var multipleEmojisLeftImageView: UIImageView!
    @IBOutlet var multipleEmojisCenterLeftImageView: UIImageView!
    @IBOutlet var multipleEmojisCenterLeftImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var multipleEmojisAnchorImageView: UIImageView!
    @IBOutlet var multipleEmojisCenterRightImageView: UIImageView!
    @IBOutlet var multipleEmojisRightImageView: UIImageView!
    @IBOutlet var multipleEmojisDefaultButton: UIButton!
    @IBOutlet var multipleEmojisWhiteButton: UIButton!
    @IBOutlet var multipleEmojisYellowButton: UIButton!
    @IBOutlet var multipleEmojisLightButton: UIButton!
    @IBOutlet var multipleEmojisDarkButton: UIButton!
    @IBOutlet var multipleEmojisBlackButton: UIButton!
    var selectedButton: UIButton?
    lazy var vibrator: Vibratable = Vibrator()
    var emoji: Emoji!
    var completion: ((String) -> Void)?

    static let shared: EmojiPreviewer = {
        let nib = UINib(nibName: "EmojiPreviewer", bundle: Bundle.module)
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! EmojiPreviewer
        view.backgroundColor = .clear
        view.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        return view
    }()

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard !(touches.first?.view is UIButton) else { return }
        hide()
    }
}

// MARK: - EmojiPreviewer Conformance to EmojiPreviewable

extension EmojiPreviewer: EmojiPreviewable {
    func brief(sourceView: UIView, sourceRect: CGRect, emoji: Emoji, emojiFontSize: CGFloat, isDarkMode: Bool) {
        self.emoji = emoji
        completion = nil
        singleEmojiWrapperView.isHidden = false
        multipleEmojisWrapperView.isHidden = true
        setupView(for: emoji.emojis[0], sourceRect: sourceRect, emojiFontSize: emojiFontSize, isDarkMode: isDarkMode)

        sourceView.addSubview(self)
    }

    func preview(sourceView: UIView, sourceRect: CGRect, emoji: Emoji, emojiFontSize: CGFloat, isDarkMode: Bool, completion: ((String) -> Void)?) {
        self.emoji = emoji
        self.completion = completion
        guard emoji.emojis.count > 1 else { return }
        singleEmojiWrapperView.isHidden = true
        multipleEmojisWrapperView.isHidden = false
        setupView(for: emoji, sourceView: sourceView, sourceRect: sourceRect, emojiFontSize: emojiFontSize, isDarkMode: isDarkMode)

        sourceView.addSubview(self)
    }

    func hide() {
        removeFromSuperview()
    }
}

// MARK: - User Interactions

extension EmojiPreviewer {
    @IBAction func multipleEmojisButtonTapped(_ button: UIButton) {
        switch button {
        case multipleEmojisDefaultButton:
            completion?(emoji.emojis[0])
        case multipleEmojisWhiteButton:
            completion?(emoji.emojis[1])
        case multipleEmojisYellowButton:
            completion?(emoji.emojis[2])
        case multipleEmojisLightButton:
            completion?(emoji.emojis[3])
        case multipleEmojisDarkButton:
            completion?(emoji.emojis[4])
        case multipleEmojisBlackButton:
            completion?(emoji.emojis[5])
        default:
            return
        }
        hide()
    }

    @IBAction func multipleEmojisButtonTouchDown(_ button: UIButton) {
        guard button != selectedButton else { return }
        vibrator.vibrate()
        selectedButton?.backgroundColor = .clear
        button.backgroundColor = button.tintColor
        selectedButton = button
    }
}

// MARK: - Privates

extension EmojiPreviewer {
    private func setupView(for emoji: String, sourceRect: CGRect, emojiFontSize: CGFloat, isDarkMode: Bool) {
        let image = UIImage(named: isDarkMode ? "darkEmojiTag" : "lightEmojiTag", in: Bundle.module, compatibleWith: nil)!
        singleEmojiImageView.image = image
        singleEmojiLabel.text = emoji
        singleEmojiLabel.font = UIFont.systemFont(ofSize: emojiFontSize)
        let width = Constant.EmojiCollectionViewCell.size.width + 37
        frame.size.height = width * image.size.height / image.size.width
        layoutIfNeeded()
        frame.size.width = singleEmojiWrapperView.frame.width
        frame.origin.x = sourceRect.midX - frame.width/2
        frame.origin.y = sourceRect.minY - frame.height + sourceRect.height + 9
    }

    private func setupView(for emoji: Emoji, sourceView: UIView, sourceRect: CGRect, emojiFontSize: CGFloat, isDarkMode: Bool) {
        multipleEmojisDefaultButton.titleLabel?.font = UIFont.systemFont(ofSize: emojiFontSize)
        multipleEmojisDefaultButton.backgroundColor = multipleEmojisDefaultButton.tintColor
        selectedButton = multipleEmojisDefaultButton
        multipleEmojisWhiteButton.titleLabel?.font = multipleEmojisDefaultButton.titleLabel?.font
        multipleEmojisWhiteButton.backgroundColor = .clear
        multipleEmojisYellowButton.titleLabel?.font = multipleEmojisDefaultButton.titleLabel?.font
        multipleEmojisYellowButton.backgroundColor = .clear
        multipleEmojisLightButton.titleLabel?.font = multipleEmojisDefaultButton.titleLabel?.font
        multipleEmojisLightButton.backgroundColor = .clear
        multipleEmojisDarkButton.titleLabel?.font = multipleEmojisDefaultButton.titleLabel?.font
        multipleEmojisDarkButton.backgroundColor = .clear
        multipleEmojisBlackButton.titleLabel?.font = multipleEmojisDefaultButton.titleLabel?.font
        multipleEmojisBlackButton.backgroundColor = .clear
        multipleEmojisDefaultButton.setTitle(emoji.emojis[0], for: .normal, animated: false)
        multipleEmojisWhiteButton.setTitle(emoji.emojis[1], for: .normal, animated: false)
        multipleEmojisYellowButton.setTitle(emoji.emojis[2], for: .normal, animated: false)
        multipleEmojisLightButton.setTitle(emoji.emojis[3], for: .normal, animated: false)
        multipleEmojisDarkButton.setTitle(emoji.emojis[4], for: .normal, animated: false)
        multipleEmojisBlackButton.setTitle(emoji.emojis[5], for: .normal, animated: false)

        multipleEmojisAnchorImageView.image = UIImage(named: isDarkMode ? "anchorDarkEmojiTag" : "anchorLightEmojiTag", in: Bundle.module, compatibleWith: nil)
        multipleEmojisLeftImageView.image = UIImage(named: isDarkMode ? "leftDarkEmojiTag" : "leftLightEmojiTag", in: Bundle.module, compatibleWith: nil)
        multipleEmojisRightImageView.image = UIImage(named: isDarkMode ? "rightDarkEmojiTag" : "rightLightEmojiTag", in: Bundle.module, compatibleWith: nil)
        multipleEmojisCenterLeftImageView.image = UIImage(named: isDarkMode ? "centerDarkEmojiTag" : "centerLightEmojiTag", in: Bundle.module, compatibleWith: nil)
        multipleEmojisCenterRightImageView.image = multipleEmojisCenterLeftImageView.image

        let image = UIImage(named: isDarkMode ? "darkEmojiTag" : "lightEmojiTag", in: Bundle.module, compatibleWith: nil)!
        let width = Constant.EmojiCollectionViewCell.size.width + 37
        frame.size.height = width * image.size.height / image.size.width
        multipleEmojisWrapperView.layoutIfNeeded()
        frame.size.width = multipleEmojisWrapperView.frame.width
        frame.origin.y = sourceRect.minY - frame.height + sourceRect.height + 9
        center.x = sourceRect.midX

        var factor: CGFloat = 0
        if sourceRect.minX <= multipleEmojisLeftImageView.frame.width + multipleEmojisAnchorImageView.frame.width/3 {
            factor = abs(frame.minX) - multipleEmojisLeftImageView.frame.width
        } else if frame.minX <= 0 {
            factor = abs(frame.minX) + multipleEmojisLeftImageView.frame.width
        } else if sourceView.frame.width - sourceRect.maxX <= multipleEmojisRightImageView.frame.width + multipleEmojisAnchorImageView.frame.width/3 {
            factor = sourceView.frame.width - frame.maxX + multipleEmojisRightImageView.frame.width
        } else if frame.maxX >= sourceView.frame.width {
            factor = sourceView.frame.width - frame.maxX
        }
        frame.origin.x = frame.origin.x + factor
        multipleEmojisCenterLeftImageViewWidthConstraint.constant = sourceRect.minX - frame.minX - multipleEmojisAnchorImageView.frame.width/2
    }
}
