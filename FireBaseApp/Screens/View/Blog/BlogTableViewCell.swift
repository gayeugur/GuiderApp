//
//  BlogTableViewCell.swift
//  FireBaseApp
//
//  Created by gayeugur on 8.10.2023.
//

import UIKit

class BlogTableViewCell: UITableViewCell {
    
    //MARK: @IBOUTLETS
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var commentText: UILabel!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var blogimageView: UIImageView!
    
    //MARK: PROPERTIES
    let blogViewModel = BlogModel()
    
    var blog: Blog? {
        didSet {
            setTableCell()
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
    private func initUI() {
        stackView.layer.cornerRadius = 10
        stackView.layer.borderWidth = 1.0
        stackView.layer.borderColor = UIColor.gray.cgColor
        stackView.isHidden = true
    }
    
    func setTableCell() {
        guard let blog else { return }
        if let imageURL = URL(string: blog.blogImage) {
            let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                if error != nil {
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async { [self] in
                        blogimageView.image = image
                        commentText.text = blog.blogDescription
                        placeName.text = blog.blogName
                        stackView.isHidden = false
                    }
                }
            }
            task.resume()
        }
    }
    
}
