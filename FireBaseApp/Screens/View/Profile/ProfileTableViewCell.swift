//
//  ProfileTableViewCell.swift
//  FireBaseApp
//
//  Created by gayeugur on 15.10.2023.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    //MARK: @IBOUTLET
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var menuText: UILabel!
    
    //MARK: PROPERTIES
    var profile: Menu? {
        didSet {
            setProfile()
        }
    }
    
    //MARK: OVERRIDE FUNCTION
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: FUNCTIONS
    func setProfile() {
        guard let profile else { return }
        menuText.text = profile.name
        let image = UIImage(systemName: profile.icon)
        iconImageView.image = image
    }
    
}
