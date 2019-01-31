//
//  ViewController.swift
//  iOS Example Frame
//
//  Created by Floriel Fedry on 11/06/2018.
//  Copyright © 2018 Checkout. All rights reserved.
//

import UIKit
import FramesIos

class MainViewController: UIViewController, CardViewControllerDelegate {
    
    @IBOutlet weak var goToPaymentPageButton: UIButton!
    
    @IBAction func goToPaymentPage(_ sender: Any) {
        navigationController?.pushViewController(cardViewController, animated: true)
    }
    
    
    func onSubmit(controller: CardViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    var cardViewController: CardViewController {
        let aViewController = CardViewController(publicKey: "pk_test_03728582-062b-419c-91b5-63ac2a481e07", environment: .sandbox, cardHolderNameState: .normal, billingDetailsState: .normal, defaultRegionCode: "UK")
        aViewController.billingDetailsAddress = CkoAddress(addressLine1: "yo", addressLine2: "yo", city: "yo", state: "yo", postcode: "yo", country: "uk", phone: nil)
        aViewController.delegate = self
        return aViewController
    }

    @IBAction func onClickGoToPaymentPage(_ sender: Any) {
        navigationController?.pushViewController(cardViewController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cardViewController.delegate = self
        cardViewController.rightBarButtonItem = UIBarButtonItem(title: "Pay", style: .done, target: nil, action: nil)
        cardViewController.availableSchemes = [.visa, .mastercard, .maestro]
        cardViewController.setDefault(regionCode: "UK")
    }
        
    func onTapDone(controller: CardViewController, cardToken: CkoCardTokenResponse?, status: CheckoutTokenStatus) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        switch status {
        case .success:
            self.showAlert(with: cardToken!.id)
        case .failure:
            print("failure")
        }
    }

    private func showAlert(with cardToken: String) {
        let alert = UIAlertController(title: nil,
                                      message: cardToken, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
