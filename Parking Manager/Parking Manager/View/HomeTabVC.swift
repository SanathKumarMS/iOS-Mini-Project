//
//  HomeTabVC.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 11/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import UIKit

class HomeTabVC: BaseVC {

    @IBOutlet private weak var profilePictureButton: UIButton!
    @IBOutlet private weak var updateDetailsButton: UIButton!
    @IBOutlet private weak var homeTableView: UITableView!
    private var viewModel = HomeTabVM()
    private var imagePicker = UIImagePickerController()
    private var isTextEditable = false
    private var updatedData: [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    @IBAction private func makeTextFieldEditable(_ sender: Any) {
        isTextEditable = true
        updateDetailsButton.isHidden = false
        profilePictureButton.isUserInteractionEnabled = true
        homeTableView.reloadData()
    }
    
    @IBAction private func updateDetails(_ sender: Any) {
        startSpin()
        var imageData: Data?
        if profilePictureButton.imageView?.image != UIImage(named: defaultProfilePhoto) {
            imageData = profilePictureButton.imageView?.image?.pngData()
        }
        viewModel.addUserToDatabase(email: viewModel.userData[UserDetailsFromStructure.email.rawValue] ?? EmptyString, name: viewModel.userData[UserDetailsFromStructure.name.rawValue] ?? EmptyString, phone: viewModel.userData[UserDetailsFromStructure.phone.rawValue] ?? EmptyString, vehicleNumber: viewModel.userData[UserDetailsFromStructure.vehicleNumber.rawValue] ?? EmptyString, vehicleType: viewModel.userData[UserDetailsFromStructure.vehicleType.rawValue] ?? EmptyString, imageData: imageData, completionHandler: { [weak self] (error) in
            guard error == nil else {
                let alertAction = AlertAction(title: AlertTitles.close, style: .cancel)
                self?.stopSpin()
                self?.presentAlert(title: AlertTitles.error, message: defaultErrorMessage, style: .alert, actions: [alertAction])
                return
            }
            self?.stopSpin()
            let alertAction = AlertAction(title: AlertTitles.close, style: .cancel)
            self?.presentAlert(title: AlertTitles.success, message: AlertMessages.detailsUpdated, style: .alert, actions: [alertAction])
        })
    }
    
    @IBAction private func logOut() {
        viewModel.signOut()
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        present(UINavigationController(rootViewController: storyboard?.instantiateViewController(withIdentifier: String(describing: LoginVC.self)) ?? LoginVC()), animated: true, completion: nil)
    }
    
    func setupUI() {
        startSpin()
        navigationItem.title = "Home"
        imagePicker.delegate = self
        profilePictureButton.isUserInteractionEnabled = false
        profilePictureButton.addTarget(self, action: #selector(setImage), for:  .touchUpInside)
        profilePictureButton.layer.cornerRadius = profilePictureButton.bounds.size.width / 2
        profilePictureButton.clipsToBounds = true
        profilePictureButton.adjustsImageWhenHighlighted = false
        updateDetailsButton.isHidden = true
        viewModel.getLoggedInUserDetails { [weak self] (success, image) in
            if success == true {
                self?.homeTableView.reloadData()
                self?.stopSpin()
                guard let image = image else { return }
                self?.profilePictureButton.setImage(image, for: .normal)
            }
            self?.stopSpin()
        }
    }
    
    @objc func setImage() {
        var alertActions: [AlertAction] = []
        let camera = AlertAction(title: ImagePickerActionTypes.camera.rawValue, style: .default)
        let photoLibrary = AlertAction(title: ImagePickerActionTypes.photoLibrary.rawValue, style: .default)
        let cancel = AlertAction(title: ImagePickerActionTypes.cancel.rawValue, style: .cancel)
        alertActions.append(contentsOf: [camera, photoLibrary, cancel])
        if profilePictureButton.imageView?.image != UIImage(named: defaultProfilePhoto) {
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
                self?.profilePictureButton.setImage(UIImage(named: defaultProfilePhoto), for: .normal)
            default:
                return
            }
        })
        imagePicker.allowsEditing = false
    }

}

// MARK: - UITableViewDelegate

extension HomeTabVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITableViewDelegate

extension HomeTabVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserDetails.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserDetailsTVCell.self)) as? UserDetailsTVCell else { return UserDetailsTVCell() }
        cell.textField.tag = indexPath.row
        cell.label.text = UserDetails.allCases[indexPath.row].title + ":"
        cell.textField.isUserInteractionEnabled = isTextEditable
        cell.userDetailsCellDelegate = self
        if cell.textField.tag == UserDetails.email.rawValue {
            cell.textField.isUserInteractionEnabled = false
        }
        cell.textField.text = viewModel.userData[UserDetailsFromStructure.allCases[indexPath.row].rawValue]
        return cell
    }
}

// MARK: - UIImagePickerControllerDelegate

extension HomeTabVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profilePictureButton.imageView?.contentMode = .scaleAspectFill
            profilePictureButton.setImage(image, for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UserDetailTVCellDelegate

extension HomeTabVC: UserDetailTVCellDelegate {
    
    func addUser(tag: Int, text: String) {
        let key = UserDetailsFromStructure.allCases[tag].rawValue
        viewModel.userData[key] = text
    }
}
