//
//  recentSearchTableViewCell.swift
//  SeSACShopping
//
//  Created by hwijinjeong on 1/20/24.
//

import UIKit

class RecentSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var magnifyingglassImageView: UIImageView!
    @IBOutlet weak var searchWordLabel: UILabel!
    @IBOutlet weak var deleteWordBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
