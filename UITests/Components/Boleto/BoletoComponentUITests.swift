//
// Copyright (c) 2022 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

@_spi(AdyenInternal) @testable import Adyen
@testable import AdyenComponents
import AdyenDropIn
import XCTest

final class BoletoComponentUITests: XCTestCase {

    private var context: AdyenContext {
        .init(
            apiContext: Dummy.apiContext,
            payment: Dummy.payment,
            analyticsProvider: AnalyticsProviderMock()
        )
    }
    
    private var paymentMethod: BoletoPaymentMethod {
        .init(type: .boleto, name: "Boleto Bancario")
    }

    func testUIConfiguration() {
        var style = FormComponentStyle()

        let textStyle = TextStyle(
            font: .preferredFont(forTextStyle: .body),
            color: .brown,
            textAlignment: .natural
        )

        let imageStyle = ImageStyle(
            borderColor: .cyan,
            borderWidth: 10.0,
            cornerRadius: 10.0,
            clipsToBounds: true,
            contentMode: .left
        )

        style.backgroundColor = .blue

        style.sectionHeader = TextStyle(
            font: .systemFont(ofSize: 20, weight: .semibold),
            color: .darkGray,
            textAlignment: .left
        )

        style.textField = FormTextItemStyle(
            title: textStyle,
            text: textStyle,
            placeholderText: textStyle,
            icon: imageStyle
        )

        var switchStyle = FormToggleItemStyle(title: textStyle)
        switchStyle.tintColor = UIColor.red
        switchStyle.separatorColor = UIColor.yellow
        switchStyle.backgroundColor = UIColor.blue

        style.toggle = switchStyle

        style.hintLabel = textStyle

        style.mainButtonItem = FormButtonItemStyle(
            button: ButtonStyle(title: textStyle, cornerRadius: 25.0, background: .gray),
            background: .magenta
        )

        style.secondaryButtonItem = FormButtonItemStyle(
            button: ButtonStyle(title: textStyle, cornerRadius: 25.0, background: .gray),
            background: .magenta
        )

        let sut = BoletoComponent(paymentMethod: paymentMethod,
                                  context: context,
                                  configuration: Dummy.getConfiguration(showEmailAddress: true))

        assertViewControllerImage(matching: sut.viewController, named: "UI_configuration")
    }

    func testPaymentDataProvided() throws {
        let mockInformation = Dummy.dummyFullPrefilledInformation
        let mockConfiguration = Dummy.getConfiguration(with: mockInformation, showEmailAddress: true)
        let mockDelegate = PaymentComponentDelegateMock()

        let sut = BoletoComponent(paymentMethod: paymentMethod,
                                  context: context,
                                  configuration: mockConfiguration)
        sut.delegate = mockDelegate
        
        presentOnRoot(sut.viewController)

        let dummyExpectation = XCTestExpectation(description: "Dummy Expectation")

        let submitButton: SubmitButton = try XCTUnwrap(sut.viewController.view.findView(by: "payButtonItem.button"))

        mockDelegate.onDidSubmit = { paymentData, paymentComponent in
            let boletoDetails = paymentData.paymentMethod as? BoletoDetails
            XCTAssertNotNil(boletoDetails)
            
            XCTAssertEqual(boletoDetails?.shopperName, mockInformation.shopperName)
            XCTAssertEqual(boletoDetails?.socialSecurityNumber, mockInformation.socialSecurityNumber)
            XCTAssertEqual(boletoDetails?.emailAddress, mockInformation.emailAddress)
            XCTAssertEqual(boletoDetails?.billingAddress, mockInformation.billingAddress)
            XCTAssertEqual(boletoDetails?.type, sut.boletoPaymentMethod.type)
            XCTAssertNil(boletoDetails?.telephoneNumber)

            self.wait(for: .aMoment)
            self.assertViewControllerImage(matching: sut.viewController, named: "boleto_flow")
            
            dummyExpectation.fulfill()
        }
        
        wait(for: .aMoment)

        submitButton.sendActions(for: .touchUpInside)
        
        wait(for: [dummyExpectation], timeout: 5)
    }
    
    func testPaymentDataNoName() throws {
        var mockInformation = Dummy.dummyFullPrefilledInformation
        mockInformation.shopperName = nil
        
        let mockConfiguration = Dummy.getConfiguration(with: mockInformation, showEmailAddress: true)
        
        let sut = BoletoComponent(paymentMethod: paymentMethod,
                                  context: context,
                                  configuration: mockConfiguration)

        let submitButton: SubmitButton = try XCTUnwrap(sut.viewController.view.findView(by: "payButtonItem.button"))
        submitButton.sendActions(for: .touchUpInside)

        wait(for: .aMoment)
        assertViewControllerImage(matching: sut.viewController, named: "boleto_flow_no_name")
    }
}
