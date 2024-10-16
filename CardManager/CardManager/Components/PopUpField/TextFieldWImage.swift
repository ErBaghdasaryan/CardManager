//
//  TextFieldWImage.swift
//  CardManager
//
//  Created by Er Baghdasaryan on 16.10.24.
//

import UIKit

public class TextFieldWImage: UITextField {

    private let leftImageView = UIImageView()

    public convenience init(placeholder: String, leftImage: UIImage?) {
        self.init()
        self.placeholder = placeholder
        self.isSecureTextEntry = isSecureTextEntry
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor(hex: "#121828")
        self.textColor = .white
        self.font = UIFont(name: "SFProText-Regular", size: 17)
        self.rightViewMode = .always
        self.autocorrectionType = .no
        self.autocapitalizationType = .none

        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor

        self.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.7)]
        )

        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(hex: "#0099FA")?.cgColor

        if let image = leftImage {
            leftImageView.image = image
            leftImageView.contentMode = .scaleAspectFit
            self.leftView = leftImageView
            self.leftViewMode = .always
        }

        self.autocorrectionType = .no
        self.autocapitalizationType = .none
    }

    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: leftImageView.frame.width + 20, dy: 0)
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: leftImageView.frame.width + 20, dy: 0)
    }
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: leftImageView.frame.width + 20, dy: 0)
    }

    public override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 10, y: 14, width: 24, height: 22)
    }

    public func setLeftImage(_ image: UIImage?) {
        if let image = image {
            leftImageView.image = image
            self.leftView = leftImageView
            self.leftViewMode = .always
        } else {
            self.leftView = nil
            self.leftViewMode = .never
        }
    }
}
