//
//  OnboardingService.swift
//
//
//  Created by Er Baghdasaryan on 15.10.24.
//

import UIKit
import CardManagerModel

public protocol IOnboardingService {
    func getOnboardingItems() -> [OnboardingPresentationModel]
}

public class OnboardingService: IOnboardingService {
    public init() { }

    public func getOnboardingItems() -> [OnboardingPresentationModel] {
        [
            OnboardingPresentationModel(image: "onboarding-1",
                                        header: "Awesome games",
                                        description: "Control your playing games"),
            OnboardingPresentationModel(image: "onboarding-2",
                                        header: "Great statistics",
                                        description: "Be in focus with your winnings and loses"),
            OnboardingPresentationModel(image: "onboarding-3",
                                        header: "Very detailed",
                                        description: "Find out what was your game!"),
        ]
    }
}
