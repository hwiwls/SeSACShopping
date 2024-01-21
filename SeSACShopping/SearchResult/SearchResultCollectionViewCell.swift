//
//  SearchResultCollectionViewCell.swift
//  SeSACShopping
//
//  Created by hwijinjeong on 1/21/24.
//

import UIKit
import Kingfisher

class SearchResultCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var mallNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }
    
    func configureCell(_ data: Item) {
        let url = URL(string: data.image)
        productImageView.kf.setImage(with: url)
        productImageView.layer.cornerRadius = 10
        productImageView.contentMode = .scaleAspectFill
        
        mallNameLabel.text = data.mallName
        mallNameLabel.textColor = .lightGray
        mallNameLabel.font = .systemFont(ofSize: 13)
        
        titleLabel.text = data.title
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 15)
        titleLabel.numberOfLines = 2
        
        priceLabel.text = data.lprice
        priceLabel.textColor = .white
        priceLabel.font = .boldSystemFont(ofSize: 17)
    }
    
}
