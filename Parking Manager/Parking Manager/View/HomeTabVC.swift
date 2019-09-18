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
    @IBOutlet private weak var editButton: UIBarButtonItem!
    @IBOutlet weak var profilePictureButtonTopConstraint: NSLayoutConstraint!
    private var viewModel = HomeTabVM()
    private var imagePicker = UIImagePickerController()
    private var isTextEditable = false
    private var updatedData: [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if UIScreen.main.bounds.height <= CGFloat(Constants.iPhone5SHeight) {
            profilePictureButtonTopConstraint.constant = CGFloat(Constants.topConstraintfor5S)
        }
        setupUI()
    }
    
    @IBAction private func setImage(_ sender: Any) {
        var alertActions: [AlertAction] = []
        let camera = AlertAction(title: ImagePickerActionTypes.camera.rawValue, style: .default)
        let photoLibrary = AlertAction(title: ImagePickerActionTypes.photoLibrary.rawValue, style: .default)
        let cancel = AlertAction(title: ImagePickerActionTypes.cancel.rawValue, style: .cancel)
        alertActions.append(contentsOf: [camera, photoLibrary, cancel])
        if profilePictureButton.imageView?.image != UIImage(named: Constants.defaultProfilePhoto) {
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
                self?.profilePictureButton.setImage(UIImage(named: Constants.defaultProfilePhoto), for: .normal)
            default:
                return
            }
        })
        imagePicker.allowsEditing = false
    }
    
    @IBAction private func editAction(_ sender: Any) {
        if isTextEditable == false {
            isTextEditable = true
            updateDetailsButton.isHidden = false
            editButton.title = "Done"
            profilePictureButton.isUserInteractionEnabled = true
            guard let cell = homeTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? UserDetailsTVCell else { return }
            cell.userDetailTextField.becomeFirstResponder()
        } else {
            isTextEditable = false
            updateDetailsButton.isHidden = true
            editButton.title = "Edit"
            profilePictureButton.isUserInteractionEnabled = false
        }
        homeTableView.reloadData()
    }
    
    @IBAction private func updateDetails(_ sender: Any) {
        startSpin()
        var imageData: Data?
        if profilePictureButton.imageView?.image != UIImage(named: Constants.defaultProfilePhoto) {
            imageData = profilePictureButton.imageView?.image?.pngData()
        }
        viewModel.addUserToDatabase(email: viewModel.userData[UserDetails.email.rawValue] ?? "", name: viewModel.userData[UserDetails.name.rawValue] ?? "", phone: viewModel.userData[UserDetails.phone.rawValue] ?? "", vehicleNumber: viewModel.userData[UserDetails.vehicleNumber.rawValue] ?? "", vehicleType: viewModel.userData[UserDetails.vehicleType.rawValue] ?? "", imageData: imageData, completionHandler: { [weak self] (error) in
            guard error == nil else {
                let alertAction = AlertAction(title: AlertTitles.close, style: .cancel)
                self?.stopSpin()
                self?.presentAlert(title: AlertTitles.error, message: Constants.defaultErrorMessage, style: .alert, actions: [alertAction])
                return
            }
            self?.stopSpin()
            let alertAction = AlertAction(title: AlertTitles.close, style: .cancel)
            self?.presentAlert(title: AlertTitles.success, message: AlertMessages.detailsUpdated, style: .alert, actions: [alertAction])
        })
    }
    
    @IBAction private func logOut() {
        let okAction = AlertAction(title: "OK", style: .default)
        let cancelAction = AlertAction(title: "Cancel", style: .cancel)
        self.presentAlert(title: "Log out", message: "Are you sure you want to log out?", style: .alert, actions: [okAction, cancelAction]) { [weak self] (alertAction) in
            if alertAction.title == "OK" {
                UserDefaults.standard.set(false, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
                self?.viewModel.signOut()
                self?.present(UINavigationController(rootViewController: self?.storyboard?.instantiateViewController(withIdentifier: String(describing: LoginVC.self)) ?? LoginVC()), animated: true, completion: nil)
            }
        }
        
    }
    
    private func setupUI() {
        startSpin()
        navigationItem.title = "Home"
        imagePicker.delegate = self
        profilePictureButton.isUserInteractionEnabled = false
        profilePictureButton.clipsToBounds = true
        updateDetailsButton.isHidden = true
        viewModel.getLoggedInUserDetails { [weak self] (success, image) in
            self?.stopSpin()
            if success == true {
                self?.homeTableView.reloadData()
                self?.stopSpin()
                guard let image = image else { return }
                self?.profilePictureButton.setImage(image, for: .normal)
            }
        }
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
        return UserDetailsToDisplay.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserDetailsTVCell.self)) as? UserDetailsTVCell else { return UserDetailsTVCell() }
        cell.userDetailTextField.tag = indexPath.row
        cell.titleLabel.text = UserDetailsToDisplay.allCases[indexPath.row].title + ":"
        cell.userDetailTextField.isUserInteractionEnabled = isTextEditable
        cell.userDetailsCellDelegate = self
        if cell.userDetailTextField.tag == UserDetailsToDisplay.email.rawValue {
            cell.userDetailTextField.isUserInteractionEnabled = false
        }
        if cell.userDetailTextField.tag == UserDetailsToDisplay.phone.rawValue {
            cell.userDetailTextField.keyboardType = .numberPad
        }
        cell.userDetailTextField.text = viewModel.userData[UserDetails.allCases[indexPath.row].rawValue]
        return cell
    }
}

// MARK: - UIImagePickerControllerDelegate

extension HomeTabVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profilePictureButton.setImage(image, for: .normal)
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

// MARK: - UserDetailTVCellDelegate

extension HomeTabVC: UserDetailTVCellDelegate {
    
    func addUser(tag: Int, text: String) {
        let key = UserDetails.allCases[tag].rawValue
        viewModel.userData[key] = text
    }
}
