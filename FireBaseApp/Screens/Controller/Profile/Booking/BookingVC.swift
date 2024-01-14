//
//  BookingVC.swift
//  FireBaseApp
//
//  Created by gayeugur on 21.11.2023.
//

import UIKit

class BookingVC: UIViewController, UINavigationControllerDelegate {
    
    //MARK: @IBOUTLET
    @IBOutlet weak var bookedButton: UIButton!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var guiderImageView: UIImageView!
    @IBOutlet weak var guiderName: UILabel!
    @IBOutlet weak var guiderRate: UILabel!
    @IBOutlet weak var addCarCheckBox: UIButton!
    @IBOutlet weak var guiderPrice: UILabel!
    @IBOutlet weak var carPriceLabel: UILabel!
    @IBOutlet weak var addCarLabel: UILabel!
    @IBOutlet weak var addShipCheckBox: UIButton!
    @IBOutlet weak var addShipLabel: UILabel!
    @IBOutlet weak var shipPriceLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var guiderPicker: UIPickerView!
    @IBOutlet weak var detailView: UIView!
    
    @IBOutlet weak var carView: UIView!
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var shipView: UIView!
    
    //MARK: PROPERTIES
    let datePicker = UIDatePicker()
    var tapGesture: UITapGestureRecognizer!
    let bookingVM = BookingVM()
    var favoritePlacesVM = PlaceModel()
    var place: Place?
    let activityIndicator = UIActivityIndicatorView(style: .large)
    var isCarSelected = true
    var isShipSelected = true
    var data: [String] = []
    var bookedPlaces: [Place] = []
    
    var selectedOption: String? = "" {
        didSet {
            guiderName.text = selectedOption
        }
    }
    
    //MARK: OVERRIDE FUNCTIONS
    init(place: Place) {
        self.place = place
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        getAllGuider()
    }
    
    //MARK: FUNCTIONS
    private func configure() {
        title = place?.name
        tabBarController?.tabBar.isHidden = true
        guiderPicker.delegate = self
        guiderPicker.dataSource = self
        navigationController?.delegate = self
        activityIndicator.center = detailView.center
        detailView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        bookedButton.layer.cornerRadius = 12
        setUI()
        setupDatePicker()
        setupTapGesture()
        setupText()
    }
    
    private func setUI() {
        guiderName.isHidden = true
        guiderPrice.isHidden = true
        guiderRate.isHidden = true
        dateTF.layer.cornerRadius = 12.0
        guiderPicker.layer.cornerRadius = 12.0
        carView.layer.cornerRadius = 12.0
        totalView.layer.cornerRadius = 12.0
        shipView.layer.cornerRadius = 12.0
    }
    
    private func getAllGuider() {
        guard let placeName = place?.name else { return }
        self.favoritePlacesVM.fetchAllGuidersInPlace(placeName: placeName) { [weak self] success in
            guard let self = self else { return }
            if success {
                data.append(contentsOf: favoritePlacesVM.allGuidersInPlace)
                selectedOption = data.first
                guiderPicker.reloadAllComponents()
                
            } else {
                Helper.makeAlert(on: self,
                                 titleInput: ConstantMessages.guiderTitle,
                                 messageInput: ConstantMessages.genericErrorNotFound)
                
            }
        }
    }
    
    private func setupText() {
        guiderName.text = selectedOption
        addCarLabel.text = "Add Car"
        carPriceLabel.text = "$30"
        addShipLabel.text = "Add Ship"
        shipPriceLabel.text = "$40"
        _ = calculateTotalCost()
        
        self.activityIndicator.startAnimating()
        bookingVM.fetchAllGuidersInPlace(placeName: place?.name ?? "") { result in
            
            switch result {
            case .success(let places):
                self.bookedPlaces = places
                self.activityIndicator.stopAnimating()
                self.setupAllData()
            case .failure(let error):
                self.activityIndicator.stopAnimating()
                Helper.makeAlert(on: self,
                                 titleInput: ConstantMessages.errorTitle,
                                 messageInput: error.localizedDescription)
            }
            
        }
    }
    
    
    private func setData(place: Place, image: UIImage) {
        self.guiderName.text = self.favoritePlacesVM.allGuidersInPlace.first
        self.guiderImageView.image = image
        self.guiderPrice.text = String(place.price ?? 0)
        self.guiderRate.text = String(place.rate ?? 0)
        guiderName.isHidden = false
        guiderPrice.isHidden = false
        guiderRate.isHidden = false
        activityIndicator.stopAnimating()
    }
    
    private func setupAllData() {
        
        if let imageString = place?.image,
           let imageURL = URL(string: imageString) {
            let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                if error != nil {
                    Helper.makeAlert(on: self,
                                     titleInput: ConstantMessages.errorTitle,
                                     messageInput: ConstantMessages.genericError)
                    return
                }
                
                if let data = data,
                   let image = UIImage(data: data) {
                    guard let place = self.place else { return }
                    DispatchQueue.main.async { [self] in
                        setData(place: place, image: image)
                    }
                }
            }
            task.resume()
        }
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: .valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date()
        datePicker.maximumDate =  Calendar.current.date(byAdding: .year, value: 2, to: Date())
        dateTF.inputView = datePicker
        dateTF.text = Helper.formatDate(date: Date())
    }
    
    private func setupTapGesture() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissDatePicker))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func calculateTotalCost() -> Int? {
        let totalCost = (isCarSelected ? 30 : 0) + (isShipSelected ? 40 : 0)
        totalPriceLabel.text = "$ \(totalCost)"
        return totalCost
    }
    
    @objc func dateChange(datePicker: UIDatePicker) {
        dateTF.text = Helper.formatDate(date: datePicker.date)
    }
    
    @objc func dismissDatePicker() {
        if dateTF.isFirstResponder {
            dateTF.resignFirstResponder()
        }
    }
    
    
    @IBAction func continueButtonAction(_ sender: Any) {
        let price = calculateTotalCost()
        guard let place = place else { return }
        if let image = place.image,
           let name = place.name,
           let guider = self.selectedOption,
           let price = price ,
           let date = self.dateTF.text,
           let rate = place.rate {
            let place = Place(image: image, name: name, guider: guider, price: price, date: date, rate: rate)
            self.bookingVM.addBlogData(place: place)
            Helper.makeAlert(on: self,
                             titleInput: ConstantMessages.successTitle,
                             messageInput: ConstantMessages.successDetail) {
                let vc = BookedViewController()
                vc.isCameFromBooking = true
                RouterManager.shared.currentNavigationController?.pushViewController(vc, animated: true)
            }
        } else {
            Helper.makeAlert(on: self,
                             titleInput: ConstantMessages.errorTitle,
                             messageInput: ConstantMessages.genericError)
        }
    }
    
    @IBAction func addCarAction(_ sender: Any) {
        isCarSelected = !isCarSelected
        
        let image = isCarSelected ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "checkmark.circle")
        addCarCheckBox.setImage(image, for: .normal)
        carPriceLabel.text = isCarSelected ? "$30" : "$0"
        _ = calculateTotalCost()
    }
    
    @IBAction func addShipAction(_ sender: Any) {
        isShipSelected = !isShipSelected
        
        let image = isShipSelected ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "checkmark.circle")
        addShipCheckBox.setImage(image, for: .normal)
        shipPriceLabel.text = isShipSelected ? "$40" : "$0"
        _ = calculateTotalCost()
    }
    
    
}
// MARK: - UIPickerViewDelegate
extension BookingVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedOption = data[row]
    }
}

// MARK: - UIPickerViewDataSource
extension BookingVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
}
