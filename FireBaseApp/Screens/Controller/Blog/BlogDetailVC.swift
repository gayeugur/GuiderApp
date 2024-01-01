//
//  BlogDetailVC.swift
//  FireBaseApp
//
//  Created by gayeugur on 8.12.2023.
//

import UIKit

class BlogDetailVC: UIViewController {
    
    //MARK: @IBOUTLET
    @IBOutlet weak var bloDetailImageView: UIImageView!
    @IBOutlet weak var blogTitle: UILabel!
    @IBOutlet weak var blogDetail: UILabel!
    
    //MARK: PROPERTIES
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    var blog: Blog? {
        didSet {
            setAllData()
        }
    }
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        configureActivityView()
        self.title = blog?.blogName
    }
    
    //MARK: FUNCTIONS
    private func configureActivityView() {
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func setAllData() {
        guard let blog else { return }
        if let imageURL = URL(string: blog.blogImage) {
            
            let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async { [self] in
                        bloDetailImageView.image = image
                        blogDetail.text = blog.blogDescription
                        blogTitle.text = blog.blogName
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
            task.resume()
        }
    }
    
}
