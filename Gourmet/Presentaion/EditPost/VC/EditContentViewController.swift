//
//  EditContentViewController.swift
//  Gourmet
//
//  Created by 최승범 on 8/23/24.
//

import UIKit
import PhotosUI
import SnapKit
import RxSwift
import RxCocoa

protocol EditContentViewDelegate: AnyObject {
    func dismissView(item: RecipeContent)
}

final class EditContentViewController: UIViewController {
    
    private let stackview = UIStackView()
    private let imageView = ImageComponent()
    private let contentTextView = UITextView()
    private let saveButton = UIButton()
    
    private var recipeContent: RecipeContent
    
    weak var delegate: EditContentViewDelegate?
    private let disposeBag = DisposeBag()
    
    init(content: RecipeContent) {
        self.recipeContent = content.isAddCell ? RecipeContent(thumbnailImage: nil, content: "") : content
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

extension EditContentViewController {
    
    @objc private func openPhotoPicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func removeImageView() {
        
        imageView.updateContent(image: nil)
        imageView.isHidden = true
    }
    
}

// MARK: - Configuration
extension EditContentViewController: BaseViewProtocol {
    
    func configureHierarchy() {
        
        view.addSubview(stackview)
        stackview.addArrangedSubview(imageView)
        stackview.addArrangedSubview(contentTextView)
        view.addSubview(saveButton)
    }
    
    func configureUI() {
        
        view.backgroundColor = .white
        
        saveButton.normalStyle(title: "저장",
                               back: .main,
                               fore: .white)
        saveButton.layer.shadowOffset = CGSize(width: 0,
                                               height: 4)
        saveButton.layer.shadowOpacity = 0.2
        
        stackview.axis = .vertical
        stackview.alignment = .leading
        stackview.spacing = 8
        
        if recipeContent.thumbnailImage == nil {
            imageView.isHidden = true
        } else {
            imageView.updateContent(image: recipeContent.thumbnailImage)
        }
        
        contentTextView.backgroundColor = .lightGray
        contentTextView.layer.cornerRadius = 16
        contentTextView.clipsToBounds = true
        contentTextView.font = .systemFont(ofSize: 18)
        contentTextView.autocorrectionType = .no
        contentTextView.spellCheckingType = .no
        
        if !recipeContent.isAddCell {
            contentTextView.text = recipeContent.content
        }
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
        
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        stackview.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.bottom.equalTo(saveButton.snp.top).offset(-20)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(100)
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
                owner.recipeContent.content = content
                owner.dismiss(animated: true) {
                    owner.delegate?.dismissView(item: owner.recipeContent)
                }
                
            }.disposed(by: disposeBag)
        
        
    }
    
}

//MARK: - ImagePicker
extension EditContentViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController,
                didFinishPicking results: [PHPickerResult]) {
        
        if results.isEmpty { return }
        results[0].itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
            
            if let image = object as? UIImage {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    imageView.updateContent(image: image)
                    imageView.isHidden = false
                    recipeContent.thumbnailImage = image
                }
            }
        }
        dismiss(animated: true)
    }
}


