
import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameTextView: UITextView!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productLikeButton: UIButton!
    @IBOutlet weak var sizeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var quantityTextFeild: UITextField!
    
    @IBAction func cartButtonTapped(_ sender: UIButton) {
        //cartItem
        
        let cartItem = CartItemController.shared.newCartItem(with: productToShowDetail, chosenColor: colorTextField.text!, chosenIndex: sizeSegmentedControl.selectedSegmentIndex, quantity: quantityTextFeild.text!)
        
        var newCart = [CartItem]()
        Tool.shared.readUserDefaultData(with: PropertyKeys.cart, and: [CartItem].self) { (cart) in
            guard let cart = cart else {return}
            newCart.append(contentsOf: cart)
        }
        if newCart.contains(cartItem) {
            let index = newCart.firstIndex(of: cartItem)!
            var quantityBeforeUpdate = Int(newCart[index].itemQuantity)!
            newCart[index].itemQuantity = "\(quantityBeforeUpdate += 1)"
        }else{
            newCart.append(cartItem)
        }
        print("cart.count = \(newCart.count)")
        Tool.shared.writeUserDefault(with: PropertyKeys.cart, and: newCart)
        
        //分辨按鈕
        if sender.tag == 0 {
            Tool.shared.showAlert(in: self, with: "已加入購物車")
        }else if sender.tag == 1 {
            let controller = storyboard?.instantiateViewController(withIdentifier: PropertyKeys.shoppingcartController) as! UITableViewController
            present(controller, animated: true, completion: nil)
        }
    }
 
    
    var productToShowDetail: Product!
    var imageName: String!
    var colors = [String]()
    var selectedColor: String!
    var pickerField: UITextField!
    var likeList = [String]()
    @IBAction func productLikeButtonTapped(_ sender: UIButton) {
        let userDefault = UserDefaults.standard
        if let oldList = userDefault.stringArray(forKey: "likeList") {
            if oldList.contains(productNameTextView.text!) {
                var likeList = oldList
                likeList.removeAll { (product) -> Bool in
                    let isMatch = product == productNameTextView.text!
                    return isMatch
                }
                userDefault.setValue(likeList, forKey: "likeList")
                DispatchQueue.main.async {
                    self.productLikeButton.imageView?.image = UIImage(systemName: "heart")
                }
            }else {
                var likeList = oldList
                likeList.append(productNameTextView.text!)
                userDefault.setValue(likeList, forKey: "likeList")
                DispatchQueue.main.async {
                    self.productLikeButton.imageView?.image = UIImage(systemName: "heart.fill")
                }
            }
        }
    }
    @IBAction func plusButton(_ sender: UIButton) {
        var quantity = Int(quantityTextFeild.text!)!
        quantity += 1
        DispatchQueue.main.async {
            self.quantityTextFeild.text = String(quantity)
        }
    }
    @IBAction func minusButton(_ sender: UIButton) {
        var quantity = Int(quantityTextFeild.text!)!
        if quantity > 1 {
            quantity -= 1
        }
        DispatchQueue.main.async {
            self.quantityTextFeild.text = String(quantity)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.showsVerticalScrollIndicator = false
        colorTextField.delegate = self
        loadFavoriteList()
        ProductController.shared.fetchProductColor(with: productToShowDetail.productColors) { (colors) in
            guard let colors = colors else {return}
            self.colors = colors
            selectedColor = colors[0]
            showDetail(of: productToShowDetail)
        }
    }
    func loadFavoriteList() {
        let userDefault = UserDefaults.standard
        guard let likeList = userDefault.stringArray(forKey: "likeList") else {return}
        self.likeList = likeList
    }
    
    func showDetail(of product: Product) {
        setSizeSegmentedControl(with: product.productSizeChoices)
        productImageView.image = ProductController.shared.loadProductImage(with: product.imageUrl)
        productNameTextView.text = product.productName
        productPriceLabel.text = "NT$ \(product.productPrice)"
        colorTextField.text = selectedColor
        colorLabel.text = "\(colors.count) Colours"
        likeList.forEach { (favoriteProduct) in
            if product.productName == favoriteProduct {
                DispatchQueue.main.async {
                    self.productLikeButton.imageView!.image = UIImage(systemName: "heart.fill")!
                }
            }
        }
    }
    func setSizeSegmentedControl(with productSizeChoices: String) {
        for index in 0...3 {
            sizeSegmentedControl.setEnabled(false, forSegmentAt: index)
        }
        let sizeChoices = productSizeChoices.components(separatedBy: ",")
        var availableChoices = [ProductSize]()
        for size in sizeChoices {
            switch size {
            case ProductSize.S.rawValue:
                sizeSegmentedControl.setEnabled(true, forSegmentAt: 0)
                availableChoices.append(.S)
            case ProductSize.M.rawValue:
                sizeSegmentedControl.setEnabled(true, forSegmentAt: 1)
                availableChoices.append(.M)
            case ProductSize.L.rawValue:
                sizeSegmentedControl.setEnabled(true, forSegmentAt: 2)
                availableChoices.append(.L)
            case ProductSize.XL.rawValue:
                sizeSegmentedControl.setEnabled(true, forSegmentAt: 3)
                availableChoices.append(.XL)
            default:
                return
            }
        }
        switch availableChoices[0] {
        case .S:
            sizeSegmentedControl.selectedSegmentIndex = 0
        case .M:
            sizeSegmentedControl.selectedSegmentIndex = 1
        case .L:
            sizeSegmentedControl.selectedSegmentIndex = 2
        case .XL:
            sizeSegmentedControl.selectedSegmentIndex = 3
        }
    }

}
extension DetailViewController: UITextFieldDelegate {
    //beginEditing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            self.initColorPickerView()
        }
    }
    //shouldReturn and resign
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func initColorPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        //製作picker view的tool bar
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.tintColor = .systemBlue
        toolbar.sizeToFit()
        //set buttons
        let okButton = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(okMethod))
        let spaceInBetween = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelMethod))
        toolbar.setItems([cancelButton, spaceInBetween, okButton], animated: false)
        
        pickerField = UITextField(frame: CGRect.zero)
        view.addSubview(pickerField)
        pickerField.inputView = pickerView
        pickerField.inputAccessoryView = toolbar
        pickerField.becomeFirstResponder()
    }
    @objc func okMethod() {
        DispatchQueue.main.async { [self] in
            colorTextField.text = selectedColor
            pickerField.resignFirstResponder()
        }
    }
    @objc func cancelMethod() {
        pickerField.resignFirstResponder()
    }
}
//picker view有delegate跟 datasource
extension DetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //row是筆數，component是群組
        return colors[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedColor = colors[row]
    }
}

