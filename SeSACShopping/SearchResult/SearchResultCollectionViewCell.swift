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
    @IBOutlet weak var likeBtn: UIButton!
    
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
        
        likeBtn.layer.cornerRadius = likeBtn.frame.width / 2
        likeBtn.backgroundColor = .white
        likeBtn.tintColor = .black
        let isLike = UserDefaultManager.shared.likeProduct.contains(data.productID)
        likeBtn.setImage(UIImage(systemName: isLike ? "heart.fill" : "heart"), for: .normal)
        likeBtn.tag = Int(data.productID) ?? 0
        likeBtn.addTarget(self, action: #selector(likeBtnClicked), for: .touchUpInside)
    }
    
    @objc func likeBtnClicked(_ sender: UIButton) {
        let productID = String(sender.tag)
        var likeProducts = UserDefaultManager.shared.likeProduct

        if let index = likeProducts.firstIndex(of: productID) {
            // 좋아요한 상품들의 ID 목록에서 제거
            likeProducts.remove(at: index)
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            // 좋아요한 상품들의 ID 목록에 추가
            likeProducts.append(productID)
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
            
        UserDefaultManager.shared.likeProduct = likeProducts
    }
    
}
