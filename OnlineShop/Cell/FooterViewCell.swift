//
//  FooterViewCell.swift
//  OnlineShop
//
//  Created by 陳家豪 on 2020/8/28.
//

import UIKit

class FooterViewCell: UITableViewCell {
    
    @IBOutlet weak var totalLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setUp() {
        guard let total = CartManager.shared.getTotal() else {return}
        let totalPrice = "NT$ "+total
        backgroundColor = .white
        DispatchQueue.main.async {
            self.totalLabel.text = totalPrice
        }
    }
}

