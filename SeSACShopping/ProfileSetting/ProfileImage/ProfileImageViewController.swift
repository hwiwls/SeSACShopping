//
//  ProfileImageViewController.swift
//  SeSACShopping
//
//  Created by hwijinjeong on 1/19/24.
//

import UIKit

let imageList = ["profile1", "profile2", "profile3", "profile4", "profile5", "profile6", "profile7", "profile8", "profile9", "profile10", "profile11","profile12", "profile13", "profile14"]

class ProfileImageViewController: UIViewController {

    @IBOutlet weak var selectedProfileImageView: UIImageView!
    @IBOutlet weak var profileImageCollectionView: UICollectionView!
    
    lazy var randomImage = imageList.randomElement() ?? "profile1"
    
    lazy var selectedImage = randomImage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        profileImageCollectionView.backgroundColor = .clear
        configNav()
        configView()
    }
}

extension ProfileImageViewController {
    func configNav() {
        navigationItem.title = "프로필 설정"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let item = UIBarButtonItem(image: UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), style: .plain, target: self, action: #selector(backToPrevios))
        navigationItem.leftBarButtonItem = item
    }
    
    @objc func backToPrevios() {
        navigationController?.popViewController(animated: true)
    }
    
    func configView() {
        selectedProfileImageView.image = UIImage(named: selectedImage)
        selectedProfileImageView.contentMode = .scaleAspectFill
        selectedProfileImageView.layer.cornerRadius = selectedProfileImageView.frame.width / 2
        selectedProfileImageView.layer.borderWidth = 5
        selectedProfileImageView.layer.borderColor = UIColor.customColor.pointColor.cgColor
        
        let xib = UINib(nibName: "ProfileImageCollectionViewCell", bundle: nil) // 실제 파일 이름을 적어주어야 한다.
        profileImageCollectionView.register(xib, forCellWithReuseIdentifier: "ProfileImageCollectionViewCell")
        
        profileImageCollectionView.delegate = self
        profileImageCollectionView.dataSource = self
        
        // 생각하는 대로 잘 안 나온다. 어렵다.
        let layout = UICollectionViewFlowLayout()   // 여러행, 여러열
        let spacing: CGFloat = 16
        let cellWidth = UIScreen.main.bounds.width - spacing * 5
        layout.itemSize = CGSize(width: cellWidth / 4.5, height: cellWidth / 4.5)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .vertical
        
        profileImageCollectionView.collectionViewLayout = layout
    }
}

extension ProfileImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileImageCollectionViewCell" , for: indexPath) as! ProfileImageCollectionViewCell
        
        cell.profileImageView.image = UIImage(named: imageList[indexPath.row])
        cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.width / 2
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImage = imageList[indexPath.row]
        UserDefaultManager.shared.selectedImage = selectedImage
        selectedProfileImageView.image = UIImage(named: selectedImage)
        profileImageCollectionView.reloadData()
    }
    
}
