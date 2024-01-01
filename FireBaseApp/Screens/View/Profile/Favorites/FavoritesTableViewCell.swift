//
//  FavoritesTableViewCell.swift
//  FireBaseApp
//
//  Created by gayeugur on 18.10.2023.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {
    
    //MARK: @IBOUTLET
    @IBOutlet weak var favoritesImageView: UIImageView!
    @IBOutlet weak var favoriName: UILabel!
    @IBOutlet weak var guidersButton: UIButton!
    @IBOutlet weak var bookButton: UIButton!
    
    var showGuidersAction: (() -> Void)?
    var bookedAction: (() -> Void)?
    
    //MARK: PROPERTIES
    var place: Place? {
        didSet {
            setPlace()
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
    
    //MARK: @IBACTION
    @IBAction func bookAction(_ sender: Any) {
        bookedAction?()
    }
    
    @IBAction func showGuiderAction(_ sender: Any) {
        showGuidersAction?()
    }
    
    //MARK: FUNCTION
    private func initUI(){
        guidersButton.isHidden = true
        bookButton.isHidden = true
    }
    
    func setPlace() {
        guard let place else { return }
        
        if let imageURL = URL(string: place.image ?? "") {
            
            let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                if let error = error {
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async { [self] in
                        favoritesImageView.image = image
                        favoriName.text = place.name
                    }
                }
            }
            task.resume()
        }
        
    }
}
