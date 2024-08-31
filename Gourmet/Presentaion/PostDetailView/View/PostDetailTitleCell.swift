//
//  PostDetailTitleCell.swift
//  Gourmet
//
//  Created by 최승범 on 8/26/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol PostDetailTitleCellDelegate: AnyObject {
    func resetViewController()
}

final class PostDetailTitleCell: UICollectionViewCell {

    private let foodImageView = UIImageView()
    
    private let containerView = UIView()
    private let contentStackView = UIStackView()
    private let difficultLevelView = InformationDetailView()
    private let timeView = InformationDetailView()
    private let starView = InformationDetailView()
    private let foodNameLabel = UILabel()
    
    private let viewModel = PostDetailTitleViewModel(networkManger: NetworkManager.shared)
    private let disposeBag = DisposeBag()
    
    weak var delegate: PostDetailTitleCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        bindingOutput()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PostDetailTitleCell {
    
    private func bindingOutput() {
        
        viewModel.output.bind(with: self) { owner, output in
            
            switch output {
            case .noValue:
                return
                
            case.fetchImage(let data):
                owner.foodImageView.image = UIImage(data: data)
                
            case .needReLogin:
                owner.delegate?.resetViewController()
            }
        }
        .disposed(by: disposeBag)
    }
    
    func updateContent(item: PostDTO) {
        
        foodNameLabel.text = item.title
        difficultLevelView.updateContent(type: .difficultyLevel,
                                         text: item.difficulty)
        timeView.updateContent(type: .time,
                                         text: item.time)
        starView.updateContent(type: .like,
                               text: "\(item.likes.count)")
        
        if !item.files.isEmpty {
            viewModel.apply(.requestImage(item.files.last!))
        }
    }
}

extension PostDetailTitleCell: BaseViewProtocol {
    
    func configureHierarchy() {
        
        contentView.addSubview(foodImageView)
        contentView.addSubview(containerView)
        containerView.addSubview(foodNameLabel)
        containerView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(difficultLevelView)
        contentStackView.addArrangedSubview(timeView)
        contentStackView.addArrangedSubview(starView)
    }
    
    func configureUI() {

        foodImageView.contentMode = .scaleToFill
        
        containerView.layer.cornerRadius = 16
        containerView.backgroundColor = .systemBackground
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowOffset = CGSize(width: 0, height: 8)
        containerView.layer.shadowRadius = 8
        
        foodNameLabel.font = .systemFont(ofSize: 20,
                                         weight: .bold)
        foodNameLabel.textAlignment = .center
        
        contentStackView.axis = .horizontal
        contentStackView.distribution = .fillEqually
        
    }

    func configureLayout() {
       
        containerView.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.snp.bottom)
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges).inset(32)
        }
        
        foodNameLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).offset(16)
            make.directionalHorizontalEdges.equalTo(containerView.snp.directionalHorizontalEdges).inset(16)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(foodNameLabel.snp.bottom).offset(16)
            make.bottom.equalTo(containerView.snp.bottom).offset(-16)
            make.directionalHorizontalEdges.equalTo(containerView.snp.directionalHorizontalEdges).inset(16)
        }
        
        foodImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges)
            make.bottom.equalTo(contentStackView.snp.top)
        }
        
    }
}

