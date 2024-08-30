//
//  RecipeCollectionViewCell.swift
//  Gourmet
//
//  Created by 최승범 on 8/20/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol RecipeCollectionViewCellDelegate: AnyObject {
    func resetViewController()
}

final class RecipeCollectionViewCell: UICollectionViewCell {
    
    private let thumbnailImageView = UIImageView()
    private let titleLabel = UILabel()
    weak var delegate: RecipeCollectionViewCellDelegate?
    private let viewModel = RecipeCollectionViewModel(networkManger: NetworkManager.shared)
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        bindingOutput()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbnailImageView.image = nil
        titleLabel.text = ""
    }
}

extension RecipeCollectionViewCell {
    
    private func bindingOutput() {
        
        viewModel.output.bind(with: self) { owner, output in
            
            switch output {
            case .noValue:
                return
                
            case.fetchImage(let data):
                owner.thumbnailImageView.image = UIImage(data: data)
                
            case .needReLogin:
                owner.delegate?.resetViewController()
            }
        }
        .disposed(by: disposeBag)
    }
    
    func updateContent(item: PostDTO) {
        
        if !item.files.isEmpty {
            viewModel.apply(.requestImage(item.files.last!))
        }
        
        titleLabel.text = item.title
    }
}

//MARK: - Configuraion
extension RecipeCollectionViewCell: BaseViewProtocol {
    
    func configureHierarchy() {
        
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
    }
    
    func configureUI() {
        
        thumbnailImageView.backgroundColor = .lightGray
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.layer.cornerRadius = 8
        thumbnailImageView.clipsToBounds = true
    }
    
    func configureLayout() {
        
        thumbnailImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(8)
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
}
