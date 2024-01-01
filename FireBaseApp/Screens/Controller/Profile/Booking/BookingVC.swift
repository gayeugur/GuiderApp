//
//  BookingVC.swift
//  FireBaseApp
//
//  Created by gayeugur on 21.11.2023.
//

import UIKit

class BookingVC: UIViewController, UINavigationControllerDelegate {
    
    //MARK: @IBOUTLET
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
        tabBarController?.tabBar.isHidden = true
        guiderPicker.delegate = self
        guiderPicker.dataSource = self
        setupDatePicker()
        setupTapGesture()
        setupText()
        initActivityView()
        getAllGuider()
        title = place?.name
        
        initActivityView()
        navigationController?.delegate = self
    }
    
    //MARK: FUNCTIONS
    
    
    private func initActivityView() {
        activityIndicator.center = detailView.center
        detailView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        guiderName.isHidden = true
        guiderPrice.isHidden = true
        guiderRate.isHidden = true
    }
    
    private func getAllGuider() {
        self.favoritePlacesVM.fetchAllGuidersInPlace(placeName: place?.name ?? "") { [weak self] success in
            guard let self = self else { return }
            if success {
                
                data.append(contentsOf: favoritePlacesVM.allGuidersInPlace)
                selectedOption = data.first
                guiderPicker.reloadAllComponents()
                
            } else {
                Constant.makeAlert(on: self, titleInput: "Rehberler", messageInput: "Guider bulunamadı")
                
            }
        }
    }
    
    func setupText() {
        guiderName.text = selectedOption
        addCarLabel.text = "Add Car"
        carPriceLabel.text = "$30"
        addShipLabel.text = "Add Ship"
        shipPriceLabel.text = "$40"
        let price = calculateTotalCost()
        
        bookingVM.fetchAllGuidersInPlace(placeName: place?.name ?? "")
        observeEvent()
    }
    
    func observeEvent() {
        bookingVM.eventHandler = { [weak self] event in
            guard let self else { return }
            switch event {
            case .loading:
                activityIndicator.startAnimating()
            case .stopLoading:
                break
            case .dataLoaded:
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.setupAllData()
                }
            case .error(let error):
                print(error ?? "ERROR")
            }
        }
    }
    
    func setupAllData() {
        
        if let imageString = place?.image, let imageURL = URL(string: imageString) {
            
            let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async { [self] in
                        self.guiderName.text = self.favoritePlacesVM.allGuidersInPlace.first
                        self.guiderImageView.image = image
                        self.guiderPrice.text = String(place?.price ?? 0)
                        self.guiderRate.text = String(place?.rate ?? 0)
                        guiderName.isHidden = false
                        guiderPrice.isHidden = false
                        guiderRate.isHidden = false
                        activityIndicator.stopAnimating()
                    }
                }
            }
            task.resume()
        }
    }
    
    func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: .valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date()
        datePicker.maximumDate =  Calendar.current.date(byAdding: .year, value: 2, to: Date())
        dateTF.inputView = datePicker
        dateTF.text = Constant.formatDate(date: Date())
    }
    
    func setupTapGesture() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissDatePicker))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dateChange(datePicker: UIDatePicker) {
        dateTF.text = Constant.formatDate(date: datePicker.date)
    }
    
    @objc func dismissDatePicker() {
        if dateTF.isFirstResponder {
            dateTF.resignFirstResponder()
        }
    }
    
    
    @IBAction func continueButtonAction(_ sender: Any) {
        let price = calculateTotalCost()
        if let image = place?.image,
           let name = place?.name,
           let guider = self.selectedOption,
           let price = price ,
           let date = self.dateTF.text,
           let rate = place?.rate {
            let place = Place(image: image, name: name, guider: guider, price: price, date: date, rate: rate)
            self.bookingVM.addBlogData(place: place)
            Constant.makeAlert(on: self, titleInput: "Success", messageInput: "") {
                let vc = BookedViewController()
                vc.isCameFromBooking = true
                RouterManager.shared.currentNavigationController?.pushViewController(vc, animated: true)
            }
        } else {
            Constant.makeAlert(on: self, titleInput: "Beklenmeyen bir hata oluştu", messageInput: "")
        }
    }
    
    @IBAction func addCarAction(_ sender: Any) {
        isCarSelected = !isCarSelected // Durumu tersine çevir
        
        if isCarSelected {
            let image = UIImage(systemName: "checkmark.seal.fill")
            addCarCheckBox.setImage(image, for: .normal)
        } else {
            let image = UIImage(systemName: "checkmark.seal")
            addCarCheckBox.setImage(image, for: .normal)
        }
        
        carPriceLabel.text = isCarSelected ? "$30" : "$0"
        calculateTotalCost()
    }
    
    @IBAction func addShipAction(_ sender: Any) {
        isShipSelected = !isShipSelected // Durumu tersine çevir
        
        if isShipSelected {
            let image = UIImage(systemName: "checkmark.seal.fill")
            addShipCheckBox.setImage(image, for: .normal)
        } else {
            let image = UIImage(systemName: "checkmark.seal")
            addShipCheckBox.setImage(image, for: .normal)
        }
        
        shipPriceLabel.text = isShipSelected ? "$40" : "$0"
        calculateTotalCost()
    }
    
    func calculateTotalCost() -> Int? {
        var totalCost = 0
        if isCarSelected {
            totalCost += 30
        }
        if isShipSelected {
            totalCost += 40
        }
        totalPriceLabel.text = "$ \(totalCost)"
        return totalCost
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
