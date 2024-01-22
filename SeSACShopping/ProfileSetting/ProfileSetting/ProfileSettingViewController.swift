//
//  ProfileSettingViewController.swift
//  SeSACShopping
//
//  Created by hwijinjeong on 1/19/24.
//

import UIKit
import TextFieldEffects

class ProfileSettingViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var completeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        nicknameTextField.delegate = self
        configNav()
        configView()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageViewClicked(_:)))
            profileImageView.isUserInteractionEnabled = true
            profileImageView.addGestureRecognizer(tapGestureRecognizer)
        
        completeBtn.addTarget(self, action: #selector(completeBtnClicked), for: .touchUpInside)
    }
    
    // 프로필 설정 이미지에서 뒤로 돌아올 때 이미지가 업데이트 되기 위해
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let selectedImg = UserDefaultManager.shared.selectedImage
        profileImageView.image = UIImage(named: selectedImg)
        
        if UserDefaultManager.shared.isSetting == false {
            self.navigationItem.title = "프로필 편집"
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        } else {
            self.navigationItem.title = "프로필 설정"
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
    }
}

extension ProfileSettingViewController {
    @objc func completeBtnClicked() {
        UserDefaultManager.shared.nickname = nicknameTextField.text!
        UserDefaultManager.shared.userState = true
        
        if UserDefaultManager.shared.isSetting == false {
            navigationController?.popViewController(animated: true)
        } else {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
            // 네비게이션바가 2개 생기는 문제 때문에 present 방식을 사용
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func configNav() {
        let item = UIBarButtonItem(image: UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), style: .plain, target: self, action: #selector(backToPrevios))
        navigationItem.leftBarButtonItem = item
    }
    
    @objc func backToPrevios() {
        navigationController?.popViewController(animated: true)
        UserDefaultManager.shared.removeSelectedImage()
        UserDefaultManager.shared.removeNickname()
    }
    
    func configView() {
        let selectedImg = UserDefaultManager.shared.selectedImage
        profileImageView.image = UIImage(named: selectedImg)
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.layer.borderWidth = 5
        profileImageView.layer.borderColor = UIColor.customColor.pointColor.cgColor
        
        cameraBtn.setImage(UIImage(named: "camera"), for: .normal)
        cameraBtn.layer.cornerRadius = cameraBtn.frame.width / 2
        cameraBtn.layer.borderWidth = 0
        
        nicknameTextField.placeholder = "닉네임을 입력해주세요 :)"
        nicknameTextField.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력해주세요 :)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        nicknameTextField.textColor = .white
        nicknameTextField.text = UserDefaultManager.shared.nickname
        
        borderView.backgroundColor = .white
        
        stateLabel.text = ""
        stateLabel.textColor = UIColor.customColor.pointColor
        stateLabel.font = .systemFont(ofSize: 13)
        
        completeBtn.backgroundColor = UIColor.customColor.pointColor
        completeBtn.setTitle("완료", for: .normal)
        completeBtn.setTitleColor(.white, for: .normal)
        completeBtn.layer.cornerRadius = 10
        completeBtn.isEnabled = false
        completeBtn.layer.borderColor = UIColor.white.cgColor
    }
    
    @IBAction func profileImageViewClicked(_ sender: UITapGestureRecognizer) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ProfileImageViewController") as! ProfileImageViewController
        vc.selectedImage = UserDefaultManager.shared.selectedImage
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProfileSettingViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let specialChar = ["@", "#", "$", "%"]
        
        guard let text = textField.text else {
            return
        }
        
        if text.count < 2 || text.count > 9 || text.isEmpty {
            stateLabel.text = "2글자 이상 10글자 미만으로 설정해주세요"
            completeBtn.isEnabled = false
        } else if specialChar.contains(where: text.contains) {
            stateLabel.text = "닉네임에 @, #, $, %는 포함할 수 없어요"
            completeBtn.isEnabled = false
        } else if text.contains(where: { $0.isNumber }) {
            stateLabel.text = "닉네임에 숫자는 포함할 수 없어요"
            completeBtn.isEnabled = false
        } else {
            stateLabel.text = "사용할 수 있는 닉네임이에요"
            completeBtn.isEnabled = true
        }
    }
    
    // return 버튼 누르면 키보드 내려가게
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
