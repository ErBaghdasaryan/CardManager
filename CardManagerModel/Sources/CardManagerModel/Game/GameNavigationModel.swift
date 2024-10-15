//
//  GameNavigationModel.swift
//
//
//  Created by Er Baghdasaryan on 16.10.24.
//

import Foundation
import Combine

public final class GameNavigationModel {
    public var activateSuccessSubject: PassthroughSubject<Bool, Never>
    public var model: GameModel
    
    public init(activateSuccessSubject: PassthroughSubject<Bool, Never>, model: GameModel) {
        self.activateSuccessSubject = activateSuccessSubject
        self.model = model
    }
}
