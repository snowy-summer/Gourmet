//
//  RecipeContentAddCell.swift
//  Gourmet
//
//  Created by 최승범 on 8/28/24.
//

import UIKit
import PhotosUI
import SnapKit
import RxSwift
import RxCocoa

protocol EditRecipeContentAddCellDelegate: AnyObject {
    func presentPhotoPicker(picker: UIViewController)
    func addContent(_ value: RecipeContent)
}

final class RecipeContentAddCell: UICollectionViewCell {
    
    private let headerView = HeaderView()
    private let stackview = UIStackView()
    private let imageView = ImageComponent()
    private let contentTextView = UITextView()
    private let saveButton = UIButton()
    
    weak var delegate: EditRecipeContentAddCellDelegate?
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension RecipeContentAddCell {
    
    @objc private func openPhotoPicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        delegate?.presentPhotoPicker(picker: picker)
    }
    
    @objc private func removeImageView() {
        
        imageView.updateContent(image: nil)
        imageView.isHidden = true
    }
    
}

//MARK: - Configuraion
extension RecipeContentAddCell: BaseViewProtocol {
    
    func configureHierarchy() {
        
        contentView.addSubview(headerView)
        contentView.addSubview(stackview)
        stackview.addArrangedSubview(imageView)
        stackview.addArrangedSubview(contentTextView)
        contentView.addSubview(saveButton)
    }
    
    func configureUI() {
        
        headerView.configureContent(type: .contentAdd)
        
        saveButton.normalStyle(title: "저장",
                               back: .main,
                               fore: .white)
        saveButton.layer.shadowOffset = CGSize(width: 0,
                                               height: 4)
        saveButton.layer.shadowOpacity = 0.2
        
        stackview.axis = .vertical
        stackview.alignment = .leading
        stackview.spacing = 16
        
        imageView.isHidden = true
        
        contentTextView.backgroundColor = .lightGray.withAlphaComponent(0.3)
        contentTextView.layer.cornerRadius = 16
        contentTextView.clipsToBounds = true
        contentTextView.font = .systemFont(ofSize: 18)
        contentTextView.autocorrectionType = .no
        contentTextView.spellCheckingType = .no
        
    }
    
    private func setupToolbar() {
        let toolbar = UIToolbar()
        
        let photoButton = UIBarButtonItem(
            image: UIImage(systemName: "photo.badge.plus"),
            style: .plain,
            target: self,
            action: #selector(openPhotoPicker)
        )

        toolbar.sizeToFit()
        photoButton.tintColor = .black
        
        toolbar.items = [photoButton]
        contentTextView.inputAccessoryView = toolbar
    }
    
    func configureLayout() {
        
        headerView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(4)
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges).inset(8)
            make.height.equalTo(44)
        }
        
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.bottom.equalTo(contentView.snp.bottom).inset(16)
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges).inset(20)
        }
        
        stackview.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(8)
            make.bottom.equalTo(saveButton.snp.top).offset(-20)
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges).inset(16)
        }
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(80)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.width.equalTo(stackview.snp.width)
        }
        
        setupToolbar()
        
    }
    
    func configureGestureAndButtonActions() {
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                              action: #selector(removeImageView)))
        
        saveButton.rx.tap
            .withLatestFrom(contentTextView.rx.text.orEmpty)
            .bind(with: self) { owner, content in
                owner.delegate?.addContent(RecipeContent(thumbnailImage: owner.imageView.imageView.image,
                                                         content: content))
                
            }.disposed(by: disposeBag)

    }
}

//MARK: - ImagePicker
extension RecipeContentAddCell: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController,
                didFinishPicking results: [PHPickerResult]) {
        
        if results.isEmpty { return }
        results[0].itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
            
            if let image = object as? UIImage {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    imageView.updateContent(image: image)
                    imageView.isHidden = false
                }
            }
        }
        picker.dismiss(animated: true)
    }
}


