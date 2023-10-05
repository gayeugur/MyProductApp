//
//  ProductTableViewCell.swift
//  MyAppClothes
//
//  Created by gayeugur on 21.09.2023.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    // MARK: @IBOUTLET
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productBackgroundView: UIView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productCategoryLabel: UILabel!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    // MARK: PROPERTIES
    private var viewModel = ProductViewModel()
    let userDefaults = UserDefaults.standard
   
    var product: Product? {
        didSet {
            productDetailConfiguration()
        }
    }
    
    
    // MARK: LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    // MARK: @IBACTIONS
    @IBAction func buyClicked(_ sender: Any) {
        
        let containsProduct = SharedBasketArray.shared.basketArray.contains { (productParam) -> Bool in
            return productParam.title == self.product?.title
        }
        
        if var product = product {
            if containsProduct {
                if let index = SharedBasketArray.shared.basketArray.firstIndex(where: { $0.title == product.title }) {
                    var basketProduct =  SharedBasketArray.shared.basketArray[index]
                    basketProduct.stock = (basketProduct.stock ?? 1) + 1
                    SharedBasketArray.shared.basketArray.remove(at: index)
                    SharedBasketArray.shared.basketArray.append(basketProduct)
                } else {
                    showAlert(title: "Error", message: "Cannot find product")
                }
            
            } else {
                product.stock = 1
                SharedBasketArray.shared.basketArray.append(product)
         
            }
        }
        
        let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: SharedBasketArray.shared.basketArray, requiringSecureCoding: false)
        showAlert(title: "Success", message: "Product Added")
    }
    
    // MARK: PRIVATE FUNCTIONS
    private func setup(){
        productBackgroundView.clipsToBounds = false
        productBackgroundView.layer.cornerRadius = 15
        productImageView.layer.cornerRadius = 10
        self.productBackgroundView.backgroundColor = .systemGray6
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okey", style: .default, handler: nil)
           alertController.addAction(okAction)
        if let viewController = self.window?.rootViewController {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: FUNCTIONS
    func productDetailConfiguration() {
        guard let product else { return }
        if rateButton.isHidden {
            if let stock = product.stock {
                descriptionLabel.text = "\(stock)"
            }
            
        } else {
            descriptionLabel.text = product.description
        }
        productTitleLabel.text = product.title
        productCategoryLabel.text = product.category
        
        priceLabel.text = "$\(product.price)"
        rateButton.setTitle("\(product.rating.rate)", for: .normal)
        productImageView.setImage(with: product.image)
    }
    
}
