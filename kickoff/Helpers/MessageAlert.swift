//
//  MessageError.swift
//  kickoff
//
//  Created by Denner Evaldt on 26/09/16.
//  Copyright © 2016 Denner Evaldt. All rights reserved.
//

import UIKit
import SCLAlertView

class MessageAlert {
    
    static func error (message: String) -> Void {
        SCLAlertView().showTitle(
            "Ops",
            subTitle: message,
            duration: nil,
            completeText: "OK",
            style: .Error,
            colorStyle: nil,
            colorTextButton: nil
        )
    }
}
