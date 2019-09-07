//
//  UserDetailsVC.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 05/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import UIKit

class UserDetailsVC: BaseVC {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    let imagePicker = UIImagePickerController()
    let imageAddButton = UIButton()
    var viewModel = UserDetailsVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.add(emailArg: "asdasd@gmail.com", name: "SanathL", phone: "9980869477", vehicleNumber: "KA-01 4608", vehicleType: "Car")
    }
    
    @IBAction private func addUser(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func setupUI() {
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = imageView.bounds.size.width / 2
        imageView.clipsToBounds = true
        imageAddButton.frame = imageView.bounds
        //imageAddButton.backgroundColor = .red
        imageAddButton.titleLabel?.text = "Add Image"
        imageAddButton.addTarget(self, action: #selector(setImage), for: .touchUpInside)
        imageView.addSubview(imageAddButton)
    }
    
    @objc func setImage() {
        var alertActions: [AlertAction] = []
        let camera = AlertAction(title: "Camera", style: .default, handler: { (alerAction) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        let photoLibrary = AlertAction(title: "Albums", style: .default, handler: { (alerAction) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        let cancel = AlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertActions.append(contentsOf: [camera, photoLibrary, cancel])
        if imageView.image != nil {
            let delete = AlertAction(title: "Delete", style: .default, handler: { (alerAction) in
                self.imageView.image = nil
            })
            alertActions.append(delete)
        }
        presentAlert(title: "Profile Photo", message: "Choose your action", style: .actionSheet, actions: alertActions)
        imagePicker.allowsEditing = false
//        imagePicker.sourceType = .photoLibrary
//        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate

extension UserDetailsVC: UITableViewDelegate {
 
}

// MARK: - UITableViewDataSource

extension UserDetailsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserDetailsTVCell.self)) as? UserDetailsTVCell else { return UserDetailsTVCell() }
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
