//
//  UserDetailsVC.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 05/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import UIKit

class UserDetailsVC: BaseVC {
    
    @IBOutlet private weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addButton: UIButton!
    private let imagePicker = UIImagePickerController()
    private let imageAddButton = UIButton()
    private var viewModel = UserDetailsVM()
    private var loggedInEmailID: String = ""
    private var userData: [String: String] = [:]
    
    private enum ImagePickerActionTypes: String {
        case camera = "Camera"
        case photoLibrary = "Photo Library"
        case cancel = "Cancel"
        case delete = "Delete"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(UIScreen.main.bounds.height)
        if UIScreen.main.bounds.height <= 568 {
            imageViewTopConstraint.constant = 70
        }
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.signOut()
    }
    
    @IBAction private func addUser(_ sender: Any) {
        if userData.count == UserDetails.allCases.count - 1 {
            guard let name = userData[UserDetails.name.title], let phone = userData[UserDetails.phone.title], let vehicleNumber = userData[UserDetails.vehicleNumber.title], let vehicleType = userData[UserDetails.vehicleType.title] else {
                return
            }
            var imageData: Data?
            if imageView.image != UIImage(named: defaultProfilePhoto) {
                imageData = imageView.image?.pngData()
            }
            viewModel.addUserToDatabase(email: loggedInEmailID, name: name, phone: phone, vehicleNumber: vehicleNumber, vehicleType: vehicleType, imageData: imageData, completionHandler: { [weak self] (message) in
                guard let message = message else { return }

                if message == successMessage {
//                    let alertAction = AlertAction(title: AlertTitles.close, style: .cancel)
//                    self?.presentAlert(title: AlertTitles.success, message: "", style: .alert, actions: [alertAction])
                    guard let tabBarVC = self?.storyboard?.instantiateViewController(withIdentifier: String(describing: TabBarVC.self)) as? TabBarVC else { return }
                    self?.present(tabBarVC, animated: true, completion: nil)
                } else {
                    let alertAction = AlertAction(title: AlertTitles.close, style: .cancel)
                    self?.presentAlert(title: AlertTitles.error, message: defaultErrorMessage, style: .alert, actions: [alertAction])
                }
            })
        }
    }
    
    func setupUI() {
        imagePicker.delegate = self
        loggedInEmailID = viewModel.getCurrentUsersEmail()
        makeCircularImageView()
    }
    
    func makeCircularImageView() {
        imageView.layer.cornerRadius = imageView.bounds.size.width / 2
        imageView.clipsToBounds = true
        imageAddButton.frame = imageView.bounds
        imageAddButton.addTarget(self, action: #selector(setImage), for: .touchUpInside)
        imageView.addSubview(imageAddButton)
    }

    @objc func setImage() {
        var alertActions: [AlertAction] = []
        let camera = AlertAction(title: ImagePickerActionTypes.camera.rawValue, style: .default)
        let photoLibrary = AlertAction(title: ImagePickerActionTypes.photoLibrary.rawValue, style: .default)
        let cancel = AlertAction(title: ImagePickerActionTypes.cancel.rawValue, style: .cancel)
        alertActions.append(contentsOf: [camera, photoLibrary, cancel])
        if imageView.image != UIImage(named: defaultProfilePhoto) {
            let delete = AlertAction(title: ImagePickerActionTypes.delete.rawValue, style: .default)
            alertActions.append(delete)
        }
        presentAlert(title: AlertTitles.profilePhoto, message: AlertMessages.chooseYourAction, style: .actionSheet, actions: alertActions, completionHandler: { [weak self] (item) in
            switch item.title {
            case ImagePickerActionTypes.camera.rawValue:
                self?.imagePicker.sourceType = .camera
                self?.present(self?.imagePicker ?? UIImagePickerController(), animated: true, completion: nil)
            case ImagePickerActionTypes.photoLibrary.rawValue:
                self?.imagePicker.sourceType = .photoLibrary
                self?.present(self?.imagePicker ?? UIImagePickerController(), animated: true, completion: nil)
            case ImagePickerActionTypes.cancel.rawValue:
                return
            case ImagePickerActionTypes.delete.rawValue:
                self?.imageView.image = UIImage(named: defaultProfilePhoto)
            default:
                return
            }
        })
        imagePicker.allowsEditing = false
    }
}

// MARK: - UITableViewDelegate

extension UserDetailsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

// MARK: - UITableViewDataSource

extension UserDetailsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserDetails.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserDetailsTVCell.self)) as? UserDetailsTVCell else { return UserDetailsTVCell() }
        cell.textField.tag = indexPath.row
        cell.label.text = UserDetails.allCases[indexPath.row].title + ":"
        cell.label.font = UIFont.systemFont(ofSize: 12)
        cell.userDetailsCellDelegate = self
        switch indexPath.row {
        case UserDetails.email.rawValue:
            if !loggedInEmailID.isEmpty {
                cell.textField.text = loggedInEmailID
                cell.textField.isUserInteractionEnabled = false
                cell.textField.backgroundColor = .lightGray
            }
        case UserDetails.vehicleType.rawValue:
            cell.addPickerToTextField()
        default:
            break
        }
        return cell
    }
}

// MARK: - UIImagePickerControllerDelegate

extension UserDetailsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFill
            imageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UserDetailTVCellDelegate

extension UserDetailsVC: UserDetailTVCellDelegate {
    
    func addUser(tag: Int, text: String) {
        let key = UserDetails(rawValue: tag)?.title
        guard let field = key else { return }
        userData[field] = text
    }
    
}
