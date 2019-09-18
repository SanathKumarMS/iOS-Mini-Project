//
//  UserDetailsTVCell.swift
//  Parking Manager
//
//  Created by Sanath Kumar M S on 05/09/19.
//  Copyright © 2019 YML. All rights reserved.
//

import UIKit

protocol UserDetailTVCellDelegate: class {
    func addUser(tag: Int, text: String)
}

class UserDetailsTVCell: BaseTVCell, UITextFieldDelegate {
    
    @IBOutlet weak var userDetailTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var picker: UIPickerView?
    weak var userDetailsCellDelegate: UserDetailTVCellDelegate?
    private var toolBar: UIToolbar?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userDetailTextField.delegate = self
        userDetailTextField.addTarget(self, action: #selector(editingChanges), for: .editingChanged)
    }
    
    func addPickerToTextField() {
        picker = UIPickerView()
        picker?.delegate = self
        picker?.dataSource = self
        picker?.reloadAllComponents()
        picker?.showsSelectionIndicator = true
        
        userDetailTextField.inputView = picker
        setupToolBar()
    }
    
    private func setupToolBar() {
        toolBar = UIToolbar()
        toolBar?.barStyle = UIBarStyle.default
        toolBar?.isTranslucent = true
        toolBar?.tintColor = .darkText
        toolBar?.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: ToolBarTitles.done, style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: ToolBarTitles.cancel, style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPicker))
        
        toolBar?.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar?.isUserInteractionEnabled = true
        userDetailTextField.inputAccessoryView = toolBar
    }
    
    @objc func donePicker() {
        let selectedIndex = picker?.selectedRow(inComponent: 0) ?? 0
        userDetailTextField.text = VehicleTypes.allCases[selectedIndex].rawValue
        userDetailTextField.resignFirstResponder()
        editingChanges()
    }
    
    @objc func cancelPicker() {
        userDetailTextField.text = ""
        userDetailTextField.resignFirstResponder()
        editingChanges()
    }
    
    @objc func editingChanges() {
        userDetailsCellDelegate?.addUser(tag: userDetailTextField.tag, text: userDetailTextField.text ?? "")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == UserDetailsToDisplay.vehicleType.rawValue {
            addPickerToTextField()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

extension UserDetailsTVCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return VehicleTypes.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return VehicleTypes.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if userDetailTextField.tag == UserDetailsToDisplay.vehicleType.rawValue {
            userDetailTextField.text = VehicleTypes.allCases[row].rawValue
            userDetailsCellDelegate?.addUser(tag: userDetailTextField.tag, text: userDetailTextField.text ?? "")
        }
    }
}
