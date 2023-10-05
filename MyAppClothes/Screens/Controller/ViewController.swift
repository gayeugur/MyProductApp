//
//  ViewController.swift
//  MyAppClothes
//
//  Created by gayeugur on 20.09.2023.
//

import UIKit

class ViewController: UIViewController {
 
    //MARK: @IBOUTLET
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var categoryButton: UIButton! {
        didSet {
            categoryButton.layer.cornerRadius = categoryButton.bounds.size.height / 2
        }
    }
    @IBOutlet weak var productTableView: UITableView!
    
    //MARK: PROPERTIES
    private var viewModel = ProductViewModel()
    private var categoriesviewModel = CategoriesViewModel()
    let activityIndicator = UIActivityIndicatorView(style: .large)
//    var filteredProductList : [Product] = []
    var list: [Product] = []
    
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        productTableView.delegate = self
        productTableView.dataSource = self
        searchBar.delegate = self
        configuration()
        var list = viewModel.products
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configuration()
        productTableView.reloadData()
    }
    
    //MARK: @IBACTION
    @IBAction func basketClicked(_ sender: Any) {
        performSegue(withIdentifier: "toBasket", sender: nil)
    }
    
}

//MARK: EXTENSION FUNCTION
extension ViewController {
    
    private func setProduct() {
        self.viewModel.fetchProducts()
        self.observeEvent()
        self.productTableView.reloadData()
    }
    
    func configuration() {
        productTableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        categoryButton.setTitle("All", for: .normal)
        initViewModel()
        observeEvent()
    }

    func initViewModel() {
        viewModel.fetchProducts()
        categoriesviewModel.fetchCategories()
    }
    
    func observeEvent() {
        viewModel.eventHandler = { [weak self] event in
            guard let self else { return }

            switch event {
            case .loading:
                print("Product loading....")
                activityIndicator.startAnimating()
            case .stopLoading:
                print("Stop loading...")
                
            case .dataLoaded:
                print("Data loaded...")
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.productTableView.reloadData()
                    self.setPopUpButton()
                }
            case .error(let error):
                print(error ?? "ERROR")
            }
        }
    }
    
    func setPopUpButton() {
        var menuActions: [UIAction] = []
        
        let defaultSelection = UIAction(title: "All", state: .on) { _ in
            self.categoryButton.setTitle("All", for: .normal)
            self.setProduct()
        }
        menuActions.append(defaultSelection)
      
        for title in categoriesviewModel.categories {
            let action = UIAction(title: title) { _ in
                self.categoryButton.setTitle(title, for: .normal)
                self.filterByCategory(title)
            }
            menuActions.append(action)
        }
        
        self.categoryButton.menu = UIMenu(children: menuActions)
    }
    
    func filterByCategory(_ category: String) {
        viewModel.filterCategory(category)
        observeEvent()
        productTableView.reloadData()
    }
}

//MARK: EXTENSION UITableViewDataSource
extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as? ProductTableViewCell else {
            return UITableViewCell()
        }
        let product = viewModel.products[indexPath.row]
        cell.product = product
        return cell
    }

}

//MARK: EXTENSION UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = viewModel.products[indexPath.row]
        let detailPage = DetailPage()
        detailPage.product = product
        self.navigationController?.pushViewController(detailPage, animated: true)
    }
}

//MARK: EXTENSION UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if !(searchText.isEmpty) {
            viewModel.products = viewModel.products.filter {
                $0.title.lowercased().contains(searchText.lowercased()) ||
                $0.title.uppercased().contains(searchText.lowercased())
            }
        }
        viewModel.fetchProducts()
        observeEvent()
        productTableView.reloadData()
        
     
    }
}
