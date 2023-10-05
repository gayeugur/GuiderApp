//
//  BlogTableViewCell.swift
//  FireBaseApp
//
//  Created by gayeugur on 8.10.2023.
//

import UIKit

class BlogTableViewCell: UITableViewCell {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var commentText: UILabel!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var blogimageView: UIImageView!
    
    let blogViewModel = BlogModel()
    
    var blog: Blog? {
        didSet {
            setTableCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stackView.layer.cornerRadius = 10
        stackView.layer.borderWidth = 2.0
        stackView.layer.borderColor = UIColor.gray.cgColor
             
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        stackView.layer.cornerRadius = 10

    }
    
    func setTableCell() {
        guard let blog else { return }
        
        if let imageURL = URL(string: blog.blogImage) {
                 
            let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                          if let error = error {
                              print("Error: \(error.localizedDescription)")
                              return
                          }
                          
                          if let data = data, let image = UIImage(data: data) {
                              DispatchQueue.main.async { [self] in
                                  blogimageView.image = image
                                  commentText.text = blog.blogDescription
                                  placeName.text = blog.blogName
                                  
                              }
                          }
                      }
                      task.resume() // Start the network request
                  }
    }
    
}
