//
//  extentionForActiveChatVC.swift
//  tistic.co
//
//  Created by Yan Khamutouski on 4/22/18.
//  Copyright © 2018 Yan Khamutouski. All rights reserved.
//

import Foundation
import JSQMessagesViewController

extension JSQMessagesInputToolbar {
    override open func didMoveToWindow() {
        super.didMoveToWindow()
        if #available(iOS 11.0, *) {
            if self.window?.safeAreaLayoutGuide != nil {
                self.bottomAnchor.constraintLessThanOrEqualToSystemSpacingBelow((self.window?.safeAreaLayoutGuide.bottomAnchor)!, multiplier: 1.0).isActive = true
            }
        }
    }
}
