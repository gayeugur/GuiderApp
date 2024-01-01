//
//  ChatTableViewCell.swift
//  FireBaseApp
//
//  Created by gayeugur on 28.10.2023.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    //MARK: @IBOUTLET
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var chatImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var iconView: UIView!
    
    //MARK: PROPERTIES
    var chat: Chat? {
        didSet {
            setChat()
        }
    }
    
    //MARK: OVERRIDE FUNCTION
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: FUNCTION
    private func initUI(){
        chatImageView.layer.cornerRadius = 12
        view.layer.cornerRadius = 12
        view.isHidden = true
    }
    
    
    func setChat() {
        guard let chat else { return }
        
        if let imageURL = URL(string: chat.icon) {
            let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async { [self] in
                        chatImageView.image = image
                        descLabel.text = "Last Seen: \(chat.lastMessage)"
                        titleLabel.text = chat.name
                        view.isHidden = false
                    }
                }
            }
            task.resume() 
        }
        
    }
    
}
