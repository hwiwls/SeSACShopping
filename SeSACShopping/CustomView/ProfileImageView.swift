//
//  ProfileImageView.swift
//  SeSACShopping
//
//  Created by hwijinjeong on 1/30/24.
//

import UIKit

class ProfileImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let selectedImg = UserDefaultManager.shared.selectedImage
        
        image = UIImage(named: selectedImg)
        contentMode = .scaleAspectFit
        layer.borderWidth = 5
        layer.borderColor = UIColor.customColor.pointColor.cgColor
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
