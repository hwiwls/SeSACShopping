//
//  ProfileImageCollectionViewCell.swift
//  SeSACShopping
//
//  Created by hwijinjeong on 1/19/24.
//

import UIKit

class ProfileImageCollectionViewCell: UICollectionViewCell {
    
    /*
     버튼에 이미지를 넣어서 해보려고 했는데, 실패하여 이미지뷰 자체를 넣어주었습니다.
     이미지 크기가 너무 커서 버튼 영역 밖으로 나가는 문제가 있어서,
     cell 안에 뷰를 만들고 그 안에서 레이아웃을 잡아주는 방법으로 시도해보았습니다.
     그러나, 뷰가 화면에 보이지 않아서 구현을 포기했습니다..ㅠㅠ
    */
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }

}
