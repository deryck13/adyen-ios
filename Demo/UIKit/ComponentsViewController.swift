//
// Copyright (c) 2023 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

import SwiftUI
import UIKit

internal final class ComponentsViewController: UIViewController {
    
    private lazy var componentsView = ComponentsView()

    private lazy var dropInExample: DropInExample = {
        let dropIn = DropInExample()
        dropIn.presenter = self
        return dropIn
    }()

    private lazy var dropInAdvancedFlowExample: DropInAdvancedFlowExample = {
        let dropInAdvancedFlow = DropInAdvancedFlowExample()
        dropInAdvancedFlow.presenter = self
        return dropInAdvancedFlow
    }()

    private lazy var cardComponentAdvancedFlowExample: CardComponentAdvancedFlowExample = {
        let cardComponentAdvancedFlow = CardComponentAdvancedFlowExample()
        cardComponentAdvancedFlow.presenter = self
        return cardComponentAdvancedFlow
    }()

    private lazy var cardComponentExample: CardComponentExample = {
        let cardComponentExample = CardComponentExample()
        cardComponentExample.presenter = self
        return cardComponentExample
    }()

    // MARK: - View
    
    override internal func loadView() {
        view = componentsView
    }
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Components"
        
        componentsView.items = [
            [
                ComponentsItem(title: "Drop In", selectionHandler: presentDropInComponent)
            ],
            [
                ComponentsItem(title: "Card", selectionHandler: presentCardComponent)
            ]
        ]
        
        if #available(iOS 13.0.0, *) {
            addConfigurationButton()
        }
    }
    
    // MARK: - DropIn Component

    internal func presentDropInComponent() {
        if componentsView.isUsingSession {
            dropInExample.start()
        } else {
            dropInAdvancedFlowExample.start()
        }
    }

    // MARK: - Components

    internal func presentCardComponent() {
        if componentsView.isUsingSession {
            cardComponentExample.start()
        } else {
            cardComponentAdvancedFlowExample.start()
        }
    }
}

// MARK: - Presenter

extension ComponentsViewController: PresenterExampleProtocol {
    
    internal func presentAlert(with error: Error, retryHandler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel))

        if let retryHandler = retryHandler {
            alertController.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
                retryHandler()
            }))
        }

        present(viewController: alertController, completion: nil)
    }

    internal func presentAlert(withTitle title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))

        present(viewController: alertController, completion: nil)
    }
    
    internal func showLoadingIndicator() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        componentsView.showsLoadingIndicator = true
    }
    
    internal func hideLoadingIndicator() {
        navigationItem.rightBarButtonItem?.isEnabled = true
        componentsView.showsLoadingIndicator = false
    }

    internal func present(viewController: UIViewController, completion: (() -> Void)?) {
        topPresenter.present(viewController, animated: true, completion: completion)
    }

    internal func dismiss(completion: (() -> Void)?) {
        dismiss(animated: true, completion: completion)
    }
}

extension UIViewController {
    var topPresenter: UIViewController {
        var topController: UIViewController = self
        while let presenter = topController.presentedViewController {
            topController = presenter
        }
        return topController
    }
}

// MARK: - Configuration, iOS13+

@available(iOS 13.0.0, *)
extension ComponentsViewController {
    
    private func addConfigurationButton() {
        let image = UIImage(systemName: "gear")
        let settingsButton = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(onSettingsTap)
        )
        navigationItem.rightBarButtonItem = settingsButton
    }
    
    @objc private func onSettingsTap() {
        let configurationVC = UIHostingController(rootView: ConfigurationView(viewModel: getConfigurationVM()))
        configurationVC.isModalInPresentation = true
        present(configurationVC, animated: true, completion: nil)
    }
    
    private func getConfigurationVM() -> ConfigurationViewModel {
        ConfigurationViewModel(
            configuration: ConfigurationConstants.current,
            onDone: { [weak self] in self?.onConfigurationClosed($0) }
        )
    }
    
    private func onConfigurationClosed(_ configuration: Configuration) {
        ConfigurationConstants.current = configuration
        dismiss(completion: nil)
    }
    
}
