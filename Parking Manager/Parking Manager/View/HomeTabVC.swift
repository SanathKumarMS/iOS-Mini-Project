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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    @IBAction private func makeTextFieldEditable(_ sender: Any) {
        isTextEditable = true
        profilePictureButton.isUserInteractionEnabled = true
        homeTableView.reloadData()
    }
    
    func setupUI() {
        startSpin()
        imagePicker.delegate = self
        profilePictureButton.isUserInteractionEnabled = false
        profilePictureButton.addTarget(self, action: #selector(setImage), for:  .touchUpInside)
        navigationItem.title = "Home"
        profilePictureButton.layer.cornerRadius = profilePictureButton.bounds.size.width / 2
        profilePictureButton.clipsToBounds = true
        profilePictureButton.showsTouchWhenHighlighted = false
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeTabTVCell.self)) as? HomeTabTVCell else { return HomeTabTVCell() }
        cell.displayTextField.tag = indexPath.row
        cell.detailLabel.text = UserDetails.allCases[indexPath.row].title + ":"
        cell.displayTextField.isUserInteractionEnabled = isTextEditable
        if cell.displayTextField.tag == UserDetails.email.rawValue {
            cell.displayTextField.isUserInteractionEnabled = false
        }
        cell.displayTextField.text = viewModel.dict[UserDetailsFromStructure.allCases[indexPath.row].rawValue]
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
