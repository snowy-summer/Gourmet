//
//  EditPostViewModel.swift
//  Gourmet
//
//  Created by 최승범 on 8/22/24.
//

import Foundation
import RxSwift
import RxCocoa

final class EditPostViewModel: ViewModelProtocol {
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    private let networkManager: NetworkManagerProtocol
    private let disposeBag = DisposeBag()
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func transform(_ input: Input) -> Output {
        return Output()
    }
}
