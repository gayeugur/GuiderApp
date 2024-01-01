//
//  BookedViewController.swift
//  FireBaseApp
//
//  Created by gayeugur on 30.10.2023.
//

import UIKit

class BookedViewController: UIViewController, UINavigationControllerDelegate {
    
    
    //MARK: @IBOUTLET
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: PROPERTIES
    let bookedVM = BookedModel()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    var isCameFromBooking = false
    
    //MARK: LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        self.title = "Booked"
        getData()
        navigationController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initActivityView()
    }
    
    //MARK: FUNCTIONS
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.setTitle("Back", for: .normal)
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    
    @objc func goBack() {
        if isCameFromBooking {
            navigationController?.popToRootViewController(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func initTableView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "BookedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "bookedCell")
    }
    
    private func initActivityView() {
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    private func getData() {
        bookedVM.fetchBookedPlaces()
        observeEvent()
    }
    
    func observeEvent() {
        bookedVM.eventHandler = { [weak self] event in
            guard let self else { return }
            
            switch event {
            case .loading:
                activityIndicator.startAnimating()
            case .stopLoading:
                break
            case .dataLoaded:
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.collectionView.reloadData()
                }
            case .error(let error):
                print(error ?? "ERROR")
            }
        }
    }
    
}

//MARK: UICollectionViewDelegate
extension BookedViewController: UICollectionViewDelegate {
    
}

//MARK: UICollectionViewDataSource
extension BookedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookedVM.booked.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        self.activityIndicator.stopAnimating()
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookedCell", for: indexPath) as? BookedCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.place = bookedVM.booked[indexPath.row]
        DispatchQueue.main.async {
            cell.view.isHidden = true
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    } 
    
}

