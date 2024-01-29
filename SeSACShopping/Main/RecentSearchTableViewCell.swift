//
//  recentSearchTableViewCell.swift
//  SeSACShopping
//
//  Created by hwijinjeong on 1/20/24.
//

import UIKit
import SnapKit

class RecentSearchTableViewCell: UITableViewCell {
    
    let magnifyingglassImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "노량"))
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        return imageView
    }()
    
    let searchWordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white
        return label
    }()
    
    let deleteWordBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), for: .normal)
        return button
    }()
    
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        contentView.addSubview(magnifyingglassImageView)
        contentView.addSubview(searchWordLabel)
        contentView.addSubview(deleteWordBtn)
        
        magnifyingglassImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(14)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(magnifyingglassImageView.snp.height).multipliedBy(1.0)
        }
        
        searchWordLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(magnifyingglassImageView.snp.trailing).offset(30)
        }
        
        deleteWordBtn.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-12)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
