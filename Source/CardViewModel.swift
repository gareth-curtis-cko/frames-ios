//
//  CardViewModel.swift
//  FramesIos
//
//  Created by Gareth Curtis on 31/01/2019.
//  Copyright © 2019 Checkout. All rights reserved.
//

import Foundation

protocol CardViewModelDelegate: class {
    func viewModelDidGenerateToken(cardTokenResponse: CkoCardTokenResponse?, status: CheckoutTokenStatus)
}

class CardViewModel {

    let checkoutService: CheckoutService
    weak var delegate: CardViewModelDelegate?

    init(with publicKey: String, and environment: Environment) {
        self.checkoutService = CheckoutService(publicKey: publicKey, environment: environment)
    }

    func createCardToken(card: CkoCardTokenRequest) {
        checkoutService.createCardToken(card: card, successHandler: { cardToken in
            self.delegate?.viewModelDidGenerateToken(cardTokenResponse: cardToken, status: .success)
        }, errorHandler: { _ in
            self.delegate?.viewModelDidGenerateToken(cardTokenResponse: nil, status: .failure)
        })
    }
}
