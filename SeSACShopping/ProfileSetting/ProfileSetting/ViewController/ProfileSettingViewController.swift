//
//  ProfileSettingViewController.swift
//  SeSACShopping
//
//  Created by hwijinjeong on 1/19/24.
//

import UIKit
import SnapKit

class ProfileSettingViewController: UIViewController {
    
    let viewModel = ProfileSettingViewModel()
    
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var completeBtn: UIButton!
    
    let profileImageView: ProfileImageView = {
        let imageView = ProfileImageView(frame: .zero)
        return imageView
    }()
    
    let cameraBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "camera"), for: .normal)
        return button
    }()
    
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
        
        viewModel.outputValidation.bind { value in
            self.stateLabel.text = value
        }
        
        viewModel.outputValidColor.bind { value in
            self.stateLabel.textColor = value ? UIColor.customColor.pointColor : .red
        }

        viewModel.outputEnable.bind { value in
            self.completeBtn.isEnabled = value
        }
        
        nicknameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        viewModel.inputNickname.value = text
    }
    
    // 프로필 설정 이미지에서 뒤로 돌아올 때 이미지가 업데이트 되기 위해
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let selectedImg = UserDefaultManager.shared.selectedImage
        profileImageView.image = UIImage(named: selectedImg)
        
        if UserDefaultManager.shared.isReg == false {
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
        if let nickname = nicknameTextField.text {
            viewModel.inputNickname.value = nickname
        }
        
        if UserDefaultManager.shared.isReg == false {
            navigationController?.popViewController(animated: true)
        } else {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
            // 네비게이션바가 2개 생기는 문제 때문에 present 방식을 사용
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        // 1. 컨텐츠
        let content = UNMutableNotificationContent()
        content.title = "(광고)\(UserDefaultManager.shared.nickname)님 안 주무시나요?!"
        content.body = "쇼핑리스트를 관리해보세요"
        content.badge = 1

        // 2.1. 캘린더 기반
        var component = DateComponents()
        component.hour = 23
        component.minute = 45
                
        let calendarTrigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
                
        // 3. 요청
        let request = UNNotificationRequest(identifier: "\(Date())", content: content, trigger: calendarTrigger)

        // 4. iOS system에 등록
        UNUserNotificationCenter.current().add(request)
    }
    
    func configNav() {
        let item = UIBarButtonItem(image: UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), style: .plain, target: self, action: #selector(backToPrevios))
        navigationItem.leftBarButtonItem = item
    }
    
    @objc func backToPrevios() {
        if viewModel.outputEnable.value || UserDefaultManager.shared.userState == false {
            navigationController?.popViewController(animated: true)
            UserDefaultManager.shared.removeSelectedImage()
            UserDefaultManager.shared.removeNickname()
        } else {
            // alert 띄우기
            let alert = UIAlertController(title: "알림", message: "닉네임을 올바르게 입력해주세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func configView() {
        view.addSubview(profileImageView)
        view.addSubview(cameraBtn)
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(90)
        }
        cameraBtn.snp.makeConstraints {
            $0.trailing.equalTo(profileImageView.snp.trailing)
            $0.bottom.equalTo(profileImageView.snp.bottom)
            $0.height.width.equalTo(25)
        }
        
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
    
    // 이 메소드는 뷰의 레이아웃이 결정된 후에 호출되므로, 이 시점에서 이미지 뷰의 너비를 알 수 있
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        cameraBtn.layer.cornerRadius = cameraBtn.frame.size.width / 2
    }
    
    @IBAction func profileImageViewClicked(_ sender: UITapGestureRecognizer) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ProfileImageViewController") as! ProfileImageViewController
        vc.selectedImage = UserDefaultManager.shared.selectedImage
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProfileSettingViewController: UITextFieldDelegate {
    // return 버튼 누르면 키보드 내려가게
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

