//
//  SubjectNavigationModel.swift
//  
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import Foundation
import Combine

public final class SubjectNavigationModel {
    public var activateSuccessSubject: PassthroughSubject<Bool, Never>
    
    public init(activateSuccessSubject: PassthroughSubject<Bool, Never>) {
        self.activateSuccessSubject = activateSuccessSubject
    }
}
