//
//  ViewModelProtocol.swift
//  Gourmet
//
//  Created by 최승범 on 8/17/24.
//

import Foundation

protocol ViewModelProtocol: AnyObject {
    
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
