//
// Copyright (c) 2023 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

import Foundation

internal final class AddressFormItemInjector: FormItemInjector, Localizable {
    
    internal var localizationParameters: LocalizationParameters?

    internal var value: PostalAddress?

    private let initialCountry: String

    internal var identifier: String

    internal let style: AddressStyle

    internal let addressViewModelBuilder: AddressViewModelBuilder
    
    private weak var presenter: ViewControllerPresenter?

    internal lazy var item: FormAddressItem = {
        let addressItem = FormAddressItem(initialCountry: initialCountry,
                                          configuration: .init(
                                              style: style,
                                              localizationParameters: localizationParameters
                                          ),
                                          identifier: identifier,
                                          presenter: presenter,
                                          addressViewModelBuilder: addressViewModelBuilder)
        value.map { addressItem.value = $0 }
        return addressItem
    }()
    
    internal init(value: PostalAddress?,
                  initialCountry: String,
                  identifier: String,
                  style: AddressStyle,
                  presenter: ViewControllerPresenter?,
                  addressViewModelBuilder: AddressViewModelBuilder) {
        self.value = value
        self.initialCountry = initialCountry
        self.identifier = identifier
        self.style = style
        self.presenter = presenter
        self.addressViewModelBuilder = addressViewModelBuilder
    }

    internal func inject(into formViewController: FormViewController) {
        formViewController.append(item)
    }
    
}
