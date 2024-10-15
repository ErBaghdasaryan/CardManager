//
//  OnboardingViewModel.swift
//  
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import Foundation
import CardManagerModel

public protocol IOnboardingViewModel {
    var onboardingItems: [OnboardingPresentationModel] { get set }
    func loadData()
}

public class OnboardingViewModel: IOnboardingViewModel {

    private let onboardingService: IOnboardingService

    public var onboardingItems: [OnboardingPresentationModel] = []

    public init(onboardingService: IOnboardingService) {
        self.onboardingService = onboardingService
    }

    public func loadData() {
        onboardingItems = onboardingService.getOnboardingItems()
    }
}
