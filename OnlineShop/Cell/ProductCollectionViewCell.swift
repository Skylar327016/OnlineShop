//
//  ProductCollectionViewCell.swift
//  OnlineShop
//
//  Created by 陳家豪 on 2020/8/22.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameTextView: UITextView!
    @IBOutlet weak var productLikeButton: UIButton!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBAction func productLikeButtonTapped(_ sender: UIButton) {
        var favoriteList = FavoriteListManager.shared.favoriteList
        if favoriteList.contains(productNameTextView.text!) {
            favoriteList.removeAll { (product) -> Bool in
                let isMatch = product == productNameTextView.text!
                return isMatch
            }
            DispatchQueue.main.async {
                self.productLikeButton.imageView?.image = UIImage(systemName: "heart")
            }
            
        }else {
            favoriteList.append(productNameTextView.text!)
            DispatchQueue.main.async {
                self.productLikeButton.imageView?.image = UIImage(systemName: "heart.fill")
            }
        }
        FavoriteListManager.shared.favoriteList = favoriteList
    }
}
