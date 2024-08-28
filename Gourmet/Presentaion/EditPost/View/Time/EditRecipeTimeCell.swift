//
//  EditRecipeTimeCell.swift
//  Gourmet
//
//  Created by 최승범 on 8/22/24.
//

import UIKit
import SnapKit

protocol EditRecipeTimeDelegate: AnyObject {
    func updateTime(_ value: String)
}

final class EditRecipeTimeCell: UICollectionViewCell {
    
    private let timeTextField = UITextField()
    weak var delegate: EditRecipeTimeDelegate?
    
    private let hours = Array(0...24)
    private let minutes = Array(0...60)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EditRecipeTimeCell {
    
    func updateContent(item: String) {
        timeTextField.text = item
    }
    
    @objc private func doneButtonTapped() {
        timeTextField.resignFirstResponder()
    }
}

//MARK: - Configuraion
extension EditRecipeTimeCell: BaseViewProtocol {
    
    func configureHierarchy() {
        
        contentView.addSubview(timeTextField)
    }
    
    func configureUI() {
        
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        configureTimePicker()
    }
    
    func configureLayout() {
        
        timeTextField.snp.makeConstraints { make in
            make.directionalVerticalEdges.equalTo(contentView.snp.directionalVerticalEdges)
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges).inset(8)
        }
    }
    
    func configureTimePicker() {
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        timeTextField.inputView = pickerView
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(doneButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil,
                                            action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        
        timeTextField.inputAccessoryView = toolbar
    }
}

extension EditRecipeTimeCell: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return hours.count
        case 1:
            return minutes.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(hours[row]) h"
        case 1:
            return "\(minutes[row]) m"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        
        let selectedHour = hours[pickerView.selectedRow(inComponent: 0)]
        let selectedMinute = minutes[pickerView.selectedRow(inComponent: 1)]
        
        delegate?.updateTime("\(selectedHour)h \(selectedMinute)m")
    }
}
