//
//  HelpCenterTableViewCell.swift
//  FireBaseApp
//
//  Created by gayeugur on 26.10.2023.
//

import UIKit

protocol expandedProtocol {
    func expandedClicked(index: Int)
}

class HelpCenterTableViewCell: UITableViewCell {

    //MARK: @IBOUTLET
    @IBOutlet weak var labelDetail: UILabel!
    @IBOutlet weak var viewDetail: UIView!
    @IBOutlet weak var tview: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageViewHelpCenter: UIImageView!
    
    //MARK: PROPERTIES
    
    var indexPath: IndexPath?
    var menu : Menu? {
        didSet {
            setText()
        }
    }
    var isExpanded = false
    var delegate: expandedProtocol?
    
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
        delegate?.expandedClicked(index: indexPath?.row ?? 0)
    }
    
    private func setText() {
        titleLabel.text = menu?.name
        labelDetail.text = menu?.detail
    }
   
    
}
