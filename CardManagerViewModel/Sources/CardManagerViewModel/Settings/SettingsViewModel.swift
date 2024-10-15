//
//  SettingsViewModel.swift
//
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import Foundation
import CardManagerModel

public protocol ISettingsViewModel {
    
}

public class SettingsViewModel: ISettingsViewModel {

    private let settingsService: ISettingsService

    public init(settingsService: ISettingsService) {
        self.settingsService = settingsService
    }
}
