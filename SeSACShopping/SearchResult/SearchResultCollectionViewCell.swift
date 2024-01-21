//
//  SearchResultCollectionViewCell.swift
//  SeSACShopping
//
//  Created by hwijinjeong on 1/21/24.
//

import UIKit

class SearchResultCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var mallNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .red
    }

}
