//
//  NormalPostEditViewModel.swift
//  Gourmet
//
//  Created by 최승범 on 8/29/24.
//

import UIKit
import RxSwift
import RxCocoa

final class NormalPostEditViewModel: ViewModelProtocol {
    
    enum Input {
        case noValue
        case uploadContent(UIImage?, String?, String?)
    }
    
    enum Output {
        case noValue
        case uploadSuccess
        case needReLogin
    }
    
    private let networkManager: NetworkManagerProtocol
    
    private(set)var output = BehaviorSubject(value: Output.noValue)
    private var contentImage = UIImage()
    private var title = ""
    private var contentText = ""
    private let disposeBag = DisposeBag()
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func apply(_ input: Input) {
        
        switch input {
        case .noValue:
            return
            
        case .uploadContent(let image, let titleText, let content):
            
            if let image = image {
                contentImage = image
            }
            
            if let titleText = titleText {
                title = titleText
            }
            
            if let content = content {
                contentText = content
            }
            
            uploadPost()
        }
    }
    
    func transform(_ input: Input) -> Output {
        return Output.noValue
    }
    
    private func uploadPost() {

        let data = [contentImage.jpegData(compressionQuality: 1.0)]
            
        networkManager.uploadImage(data) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let success):
                
                networkManager.uploadPost(item: createUploadPostBody(files: success.files)) { [ weak self ] result in
                    switch result {
                    case .success:
                        self?.output.onNext(.uploadSuccess)
                        
                    case .failure(let error):
                        print(error)
                    }
                }
                
            case .failure(let error):
                if error == .expiredAccessToken {
                    refreshAccessToken()
                } else {
                    PrintDebugger.logError(error)
                }
            }
        }
        
    }
    
    private func createUploadPostBody(files: [String]) -> UploadPostBodyModel {
        
        return UploadPostBodyModel(title: title,
                                   content: contentText,
                                   subTitle: "",
                                   ingredients: nil,
                                   recipe: nil,
                                   time: nil,
                                   difficulty: nil,
                                   productID: FoodCategory.normal.productId,
                                   files: files)
    }
    
    
    private func refreshAccessToken() {
        
        networkManager.refreshAccessToken { [weak self] result in
            switch result {
            case .success:
                self?.uploadPost()
                
            case .failure:
                self?.output.onNext(.needReLogin)
            }
        }
    }
}
