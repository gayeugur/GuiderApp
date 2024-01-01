//
//  HelpCenterTableViewCell.swift
//  FireBaseApp
//
//  Created by gayeugur on 26.10.2023.
//

import UIKit

class HelpCenterTableViewCell: UITableViewCell {

    //MARK: @IBOUTLET
    @IBOutlet weak var labelDetail: UILabel!
    @IBOutlet weak var viewDetail: UIView!
    @IBOutlet weak var tview: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageViewHelpCenter: UIImageView!
    
    //MARK: PROPERTIES
    var butttonClicked: (() -> (Void))!
    var isExpanded = false
    
    //MARK: OVERRIDE FUNCTION
    override func awakeFromNib() {
        super.awakeFromNib()
        addRecognizer()
        initUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: FUNCTIONS
    private func initUI(){
        tview.layer.cornerRadius = 8
        tview.layer.borderColor = UIColor.black.cgColor
        tview.layer.borderWidth = 1.0
    }
    
    private func addRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageViewHelpCenter.isUserInteractionEnabled = true
        imageViewHelpCenter.addGestureRecognizer(tapGesture)
    }
    
    @objc func imageTapped() {
        isExpanded = true
    }

    
}
