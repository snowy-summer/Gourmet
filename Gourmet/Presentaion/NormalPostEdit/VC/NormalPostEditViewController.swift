//
//  NormalPostEditViewController.swift
//  Gourmet
//
//  Created by 최승범 on 8/29/24.
//

import UIKit
import PhotosUI
import SnapKit
import RxSwift
import RxCocoa

final class NormalPostEditViewController: UIViewController {
    
    private let stackview = UIStackView()
    private let imageView = ImageComponent()
    private let titleTextField = UITextField()
    private let contentTextView = UITextView()
    
    private let viewModel = NormalPostEditViewModel(networkManager: NetworkManager.shared)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        bindingOutput()
    }
}

extension NormalPostEditViewController {
    
    private func bindingOutput() {
        
        viewModel.output.bind(with: self) { owner, output in
            switch output {
            case .noValue:
                return
            case .uploadSuccess:
                owner.navigationController?.popViewController(animated: true)
            case .needReLogin:
                owner.resetViewController(vc: LoginViewController())
            }
        }
        .disposed(by: disposeBag)
    }
    
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
    
    @objc private func savePost() {
        
        viewModel.apply(.uploadContent(imageView.imageView.image,
                                       titleTextField.text,
                                       contentTextView.text))
    }
    
}

//MARK: - COnfiguration
extension NormalPostEditViewController: BaseViewProtocol {
    
    func configureNavigationBar() {
        
        let saveItem = UIBarButtonItem(title: "저장",
                                       style: .plain,
                                       target: self,
                                       action: #selector(savePost))
        
        navigationItem.rightBarButtonItem = saveItem
    }
    
    func configureHierarchy() {
        
        view.addSubview(stackview)
        stackview.addArrangedSubview(titleTextField)
        stackview.addArrangedSubview(imageView)
        stackview.addArrangedSubview(contentTextView)
    }
    
    func configureUI() {
    
        view.backgroundColor = .systemBackground
        stackview.axis = .vertical
        stackview.alignment = .leading
        stackview.spacing = 16
        
        imageView.isHidden = true
        
        titleTextField.placeholder = "제목을 입력하세요"
        titleTextField.font = .systemFont(ofSize: 18, weight: .semibold)
        
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
        
        stackview.snp.makeConstraints { make in
            make.directionalVerticalEdges.equalTo(view.safeAreaLayoutGuide)
            make.directionalHorizontalEdges.equalTo(view.snp.directionalHorizontalEdges).inset(16)
        }
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(80)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.width.equalTo(stackview.snp.width)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.width.equalTo(stackview.snp.width)
        }
        
        setupToolbar()
        
    }
    
    func configureGestureAndButtonActions() {
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                              action: #selector(removeImageView)))
    }
}

//MARK: - ImagePicker
extension NormalPostEditViewController: PHPickerViewControllerDelegate {
    
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


