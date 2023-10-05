//
//  DetailPage.swift
//  MyAppClothes
//
//  Created by gayeugur on 21.09.2023.
//

import UIKit

class DetailPage: UIViewController {
    
    //MARK: @IBOUTLET
    @IBOutlet weak var detailProductImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!

    //MARK: PROPERTIES
    var product: Product?
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = product?.category
        self.navigationItem.prompt = product?.title
        productDetailConfiguration()
    }
    
    //MARK: FUNCTION
    func productDetailConfiguration() {
        guard let product else { return }
        
        titleLabel.text = "Name : \(product.title)"
        categoryLabel.text = "Category : \(product.category)"
        descriptionLabel.text = "Description : \(product.description) "
        priceLabel.text = "Price : $\(product.price)"
        rateLabel.text = "Rate : \(product.rating.rate) "
        countLabel.text = "Count : \(product.rating.count)"
        detailProductImageView.setImage(with: product.image)
    }
     


}
