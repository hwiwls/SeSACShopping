//
//  ProfileImageViewModel.swift
//  SeSACShopping
//
//  Created by hwijinjeong on 2/26/24.
//

import Foundation

class ProfileImageViewModel {
    var imageList: [String] = ["profile1", "profile2", "profile3", "profile4", "profile5", "profile6", "profile7", "profile8", "profile9", "profile10", "profile11","profile12", "profile13", "profile14"]
    
    func numberOfItemsInSection() -> Int {
        return imageList.count
    }
    
    func imageForItemAt(_ indexPath: IndexPath) -> String {
        return imageList[indexPath.row]
    }
}
