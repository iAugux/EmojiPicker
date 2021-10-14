// Created by Augus on 2021/10/14
// Copyright © 2021 Augus <iAugux@gmail.com>

import UIKit
import EmojiPicker

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
        ])
    }

    private lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Select Emoji", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(presentEmojiPicker), for: .touchUpInside)
        return button
    }()

    @objc
    private func presentEmojiPicker() {
        let emojiPicker = EmojiPicker.viewController
        emojiPicker.sourceRect = button.frame
        emojiPicker.emojiFontSize = 20
        emojiPicker.size = .init(width: 300, height: 400)
        present(emojiPicker, animated: true, completion: nil)
    }
}

