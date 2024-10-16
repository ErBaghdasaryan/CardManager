//
//  StrategyNavigationModel.swift
//  
//
//  Created by Er Baghdasaryan on 16.10.24.
//

import Foundation
import Combine

public final class StrategyNavigationModel {
    public var activateSuccessSubject: PassthroughSubject<Bool, Never>
    public var model: StrategyModel
    
    public init(activateSuccessSubject: PassthroughSubject<Bool, Never>, model: StrategyModel) {
        self.activateSuccessSubject = activateSuccessSubject
        self.model = model
    }
}
