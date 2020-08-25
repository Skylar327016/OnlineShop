import UIKit

class ProductCollectionViewController: UICollectionViewController {
    
    var products = [Product]()
    var likeList = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFavoriteList()
        updateDataSource()
//        let cart = [CartItem]()
//        Tool.shared.writeUserDefault(with: PropertyKeys.cart, and: cart)
    }
    
    override func viewDidLayoutSubviews() {
       setCellFlowLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadFavoriteList()
        updateDataSource()
    }


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return products.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PropertyKeys.productCell, for: indexPath) as? ProductCollectionViewCell else {return UICollectionViewCell()}
        // Configure the cell
        configure(with: likeList, for: cell, at: indexPath.row)
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: PropertyKeys.segueToDetail, sender: indexPath)
    }
    
    func updateDataSource() {
        ProductController.shared.fetechData { (products) in
            guard let products = products else {return}
            self.products = products
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    func loadFavoriteList() {
        let userDefault = UserDefaults.standard
        guard let likeList = userDefault.stringArray(forKey: "likeList") else {return}
        self.likeList = likeList
    }
    func setCellFlowLayout(){
        let itemSpace:CGFloat = 10
        let width = floor((collectionView.bounds.width - itemSpace * 3) / 2)
        let height = width / 204 * 347
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {return}
        flowLayout.estimatedItemSize = .zero
        flowLayout.itemSize = CGSize(width: width, height: height)
        flowLayout.minimumLineSpacing = itemSpace
        flowLayout.minimumInteritemSpacing = itemSpace
        //設定cell的邊界距離
        flowLayout.sectionInset.left = itemSpace
        flowLayout.sectionInset.right = itemSpace
        flowLayout.sectionInset.top = itemSpace
        flowLayout.sectionInset.bottom = itemSpace
    }
    
    func configure(with likeList: [String], for cell: ProductCollectionViewCell, at row: Int) {
        //先把愛心全清空，避免重複使用的cell亂掉
        cell.productLikeButton.imageView!.image = UIImage(systemName: "heart")!
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.gray.cgColor
        let product =  products[row]
        likeList.forEach { (favoriteProduct) in
            if product.productName == favoriteProduct {
                DispatchQueue.main.async {
                    cell.productLikeButton.imageView!.image = UIImage(systemName: "heart.fill")!
                }
            }
        }
        cell.productImageView.image = ProductController.shared.loadProductImage(with: product.imageUrl)
        cell.productNameTextView.text = product.productName
        cell.productPriceLabel.text = "NT$ \(product.productPrice)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == PropertyKeys.segueToDetail {
            guard let controller = segue.destination as? DetailViewController, let indexPath = sender as? IndexPath else {return}
            controller.productToShowDetail = products[indexPath.row]
        }
    }
}

