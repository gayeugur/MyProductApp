//
//  BasketViewController.swift
//  MyAppClothes
//
//  Created by gayeugur on 23.09.2023.
//

import UIKit

class BasketViewController: UIViewController, UITableViewDelegate {
   
    // MARK: @IBOUTLET
    @IBOutlet weak var basketTableView: UITableView!
    
    @IBOutlet weak var stackViewButtons: UIStackView!
    // MARK: PROPERTIES
    private var viewModel = ProductViewModel()
    let userDefaults = UserDefaults.standard
    
    // MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        basketTableView.delegate = self
        basketTableView.dataSource = self
        basketTableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        basketTableView.reloadData()
        if SharedBasketArray.shared.basketArray.count == 0 {
            showAlert(title: "Empty", message: "", buttonTitle: "OK")
            stackViewButtons.isHidden = true
        }
    }
    
    // MARK: @IBACTIONS
    @IBAction func clearBasketAction(_ sender: Any) {
       clearBasket()
    }
    
    @IBAction func buyBasketProductAction(_ sender: Any) {
        let sum = SharedBasketArray.shared.totalValue()
        showAlert(title: "", message: "Total Price : \(sum)", buttonTitle: "Buy",actionFunction: buyAction)
    
    }
    
    // MARK: PRIVATE FUNCTIONS
    private func buyAction() {
        showAlert(title: "Success", message: "", buttonTitle: "OK", style: .actionSheet)
        clearBasket()
        
    }
    
    private func clearBasket() {
        SharedBasketArray.shared.basketArray = []
        basketTableView.reloadData()
    }
    
    // MARK: FUNCTIONS
    func showAlert(title: String, message: String, buttonTitle: String, actionFunction: (() -> Void)? = nil, style: UIAlertController.Style? = .alert) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: buttonTitle, style: .cancel) { (_) in
            actionFunction?()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: UITableViewDataSource
extension BasketViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SharedBasketArray.shared.basketArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as? ProductTableViewCell else {
            return UITableViewCell()
        }
        let product = SharedBasketArray.shared.basketArray[indexPath.row]
        
        cell.rateButton.isHidden = true
        cell.buyButton.isHidden = true
        cell.product = product
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
               SharedBasketArray.shared.basketArray.remove(at: indexPath.row)
               tableView.deleteRows(at: [indexPath], with: .fade)
           }
       }
    
    
}




