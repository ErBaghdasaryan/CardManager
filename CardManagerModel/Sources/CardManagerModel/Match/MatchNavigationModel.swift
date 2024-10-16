//
//  MatchNavigationModel.swift
//  
//
//  Created by Er Baghdasaryan on 16.10.24.
//

import Foundation
import Combine

public final class MatchNavigationModel {
    public var activateSuccessSubject: PassthroughSubject<Bool, Never>
    public var model: MatchModel
    
    public init(activateSuccessSubject: PassthroughSubject<Bool, Never>, model: MatchModel) {
        self.activateSuccessSubject = activateSuccessSubject
        self.model = model
    }
}
