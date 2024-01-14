//
//  MessageCell.swift
//  FireBaseApp
//
//  Created by gayeugur on 11.01.2024.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var receiverMessageLabel: UILabel!
    
    var message: SenderMessageModel? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        guard let message = message else {
            messageLabel.isHidden = true
            receiverMessageLabel.isHidden = true
            return
        }
        if message.isSendByMe {
            messageLabel.isHidden = false
            receiverMessageLabel.isHidden = true
            messageLabel.text = message.content
        }
        else {
            receiverMessageLabel.isHidden = false
            messageLabel.isHidden = true
            receiverMessageLabel.text = message.content
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        messageLabel.layer.cornerRadius = 12
        receiverMessageLabel.layer.cornerRadius = 12
        messageLabel.clipsToBounds = true
        receiverMessageLabel.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
