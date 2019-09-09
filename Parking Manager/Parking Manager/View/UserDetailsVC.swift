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
    let picker = UIPickerView()
    var viewModel = UserDetailsVM()
    var loggedInEmailID: String = ""
    var toolBar = UIToolbar()
    var pickerTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        viewModel.add(emailArg: "asdasd@gmail.com", name: "SanathL", phone: "9980869477", vehicleNumber: "KA-01 4608", vehicleType: "Car")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.signOut()
    }
    
    //TO-DO check for empty array, protocol to read data from cells, Enum
    @IBAction private func addUser(_ sender: Any) {
        var dataFromUser: [String] = []
        for index in 0...viewModel.inputDetails.count {
            if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? UserDetailsTVCell {
                let data = cell.textField.text ?? ""
                dataFromUser.append(data)
            }
        }
        let imageData = imageView.image?.pngData()
        if dataFromUser.count == 5 {
            viewModel.addUserToDatabase(emailArg: dataFromUser[0], name: dataFromUser[1], phone: dataFromUser[2], vehicleNumber: dataFromUser[3], vehicleType: dataFromUser[4], imageData: imageData)
        }
    }
    
    func setupUI() {
        self.title = "Parking Manager"
        picker.delegate = self
        picker.dataSource = self
        picker.showsSelectionIndicator = true
        loggedInEmailID = viewModel.getCurrentUsersEmail()
        setUpPicker()
        makeCircularImageView()
    }
    
    func setUpPicker() {
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76 / 255, green: 217 / 255, blue: 100 / 255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
    }
    
    func makeCircularImageView() {
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = imageView.bounds.size.width / 2
        imageView.clipsToBounds = true
        imageAddButton.frame = imageView.bounds
        imageAddButton.titleLabel?.text = "Add Image"
        imageAddButton.addTarget(self, action: #selector(setImage), for: .touchUpInside)
        imageView.addSubview(imageAddButton)
    }
    
    @objc func donePicker() {
        pickerTextField?.resignFirstResponder()
    }
    
    @objc func setImage() {
        var alertActions: [AlertAction] = []
        let camera = AlertAction(title: "Camera", style: .default, handler: { (_) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        let photoLibrary = AlertAction(title: "Albums", style: .default, handler: { (_) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        let cancel = AlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertActions.append(contentsOf: [camera, photoLibrary, cancel])
        if imageView.image != UIImage(named: "Network-Profile") {
            let delete = AlertAction(title: "Delete", style: .default, handler: { (_) in
                self.imageView.image = UIImage(named: "Network-Profile")
            })
            alertActions.append(delete)
        }
        presentAlert(title: "Profile Photo", message: "Choose your action", style: .actionSheet, actions: alertActions) 
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
        return viewModel.inputDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserDetailsTVCell.self)) as? UserDetailsTVCell else { return UserDetailsTVCell() }
        cell.tag = indexPath.row
        let label = UILabel()
        label.text = viewModel.inputDetails[indexPath.row] + ":"
        label.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        label.font = UIFont.systemFont(ofSize: 12)
        cell.textField.leftViewMode = .always
        cell.textField.leftView = label
        if indexPath.row == 0 {
            if !loggedInEmailID.isEmpty {
                cell.textField.text = loggedInEmailID
                cell.textField.isUserInteractionEnabled = false
                cell.textField.backgroundColor = .lightGray
            }
        }
        if indexPath.row == 3 {
            pickerTextField = cell.textField
            cell.textField.inputView = picker
            cell.textField.text = "Bike"
            cell.textField.inputAccessoryView = toolBar
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

// MARK: - UIPickerViewDelegate

extension UserDetailsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.vehicleTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.vehicleTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let cell = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? UserDetailsTVCell {
            cell.textField.text = viewModel.vehicleTypes[row]
            cell.textField.endEditing(true)
        }
    }
}


extension UserDetailsVC: UserDetailTVCellDelegate {
    func addUser() {
        
    }
}


