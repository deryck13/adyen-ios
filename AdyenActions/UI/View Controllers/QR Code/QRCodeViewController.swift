//
// Copyright (c) 2021 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

import Adyen
import UIKit

internal final class QRCodeViewController: UIViewController {
    
    private let qrCodeView: UIView
    
    internal init(qrCodeView: UIView) {
        self.qrCodeView = qrCodeView
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        view.backgroundColor = .clear
    }
    
    private func buildUI() {
        view.addSubview(qrCodeView)
        qrCodeView.translatesAutoresizingMaskIntoConstraints = false
        qrCodeView.adyen.anchor(inside: view)
    }
    
    override internal var preferredContentSize: CGSize {
        get {
            let targetSize = CGSize(width: UIScreen.main.bounds.width,
                                    height: UIView.layoutFittingCompressedSize.height)
            return qrCodeView.systemLayoutSizeFitting(targetSize,
                                                       withHorizontalFittingPriority: .required,
                                                       verticalFittingPriority: .fittingSizeLevel)
        }

        // swiftlint:disable:next unused_setter_value
        set { AdyenAssertion.assert(message: """
        PreferredContentSize is overridden for this view controller.
        getter - returns minimum possible content size.
        setter - no implemented.
        """) }
    }
}
