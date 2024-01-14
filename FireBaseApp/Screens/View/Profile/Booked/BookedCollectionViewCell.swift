//
//  BookedCollectionViewCell.swift
//  FireBaseApp
//
//  Created by gayeugur on 30.10.2023.
//

import UIKit

class BookedCollectionViewCell: UICollectionViewCell {
    
    //MARK: @IBOUTLET
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateIcon: UIImageView!
    @IBOutlet weak var priceIcon: UIImageView!
    @IBOutlet weak var guiderIcon: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var guiderLabel: UILabel!
    
    //MARK: PROPERTIES
    var place: Place? {
        didSet {
            setPlace()
        }
    }

    //MARK: OVERRIDE FUNCTION
    override func awakeFromNib() {
        super.awakeFromNib()
        setImageMask()
    }
    
    //MARK: FUNCTION
    private func setImageMask() {
        let customColor =  UIColor(hex: 0xA94438)
        dateIcon.image = dateIcon.image?.mask(withColor: customColor)
        priceIcon.image = priceIcon.image?.mask(withColor: customColor)
        guiderIcon.image = guiderIcon.image?.mask(withColor: customColor)
    }
    
    private func setPlace() {
        guard let place else { return }
        
        DispatchQueue.main.async {
            self.view.isHidden = true
        }
        if let imageURL = URL(string: place.image ?? "") {
            
            let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async { [self] in
                        imageView.image = image
                        dateLabel.text = place.date
                        guiderLabel.text = place.guider
                        priceLabel.text = String(place.price ?? 0)
                        view.isHidden = false
                    }
                }
            }
            task.resume()
        }
        
    }
}



