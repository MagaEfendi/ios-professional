//
//  PasswordStatusView.swift
//  Password
//
//  Created by Mahammad Afandiyev on 02.03.23.
//
import UIKit

class PasswordStatusView: UIView {
    
    let stackView = UIStackView()
    
    let criteriaLabel = UILabel()
    
    let lengthCriteriaView = PasswordCriteriaView(text: "8-32 characters (no spaces)")
    let uppercaseCriteriaView = PasswordCriteriaView(text: "uppercase letter (A-Z)")
    let lowerCaseCriteriaView = PasswordCriteriaView(text: "lowercase (a-z)")
    let digitCriteriaView = PasswordCriteriaView(text: "digit (0-9)")
    let specialCharacterCriteriaView = PasswordCriteriaView(text: "special character (e.g. !@#$%^)")
    
    var shouldResetCriteria: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        layout()
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 200)
    }
}
extension PasswordStatusView {
    private func style() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .tertiarySystemFill
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .equalCentering
        
        criteriaLabel.numberOfLines = 0
        criteriaLabel.lineBreakMode = .byWordWrapping
        criteriaLabel.attributedText = makeCriteriaMessage()
        
        lengthCriteriaView.translatesAutoresizingMaskIntoConstraints = false
        uppercaseCriteriaView.translatesAutoresizingMaskIntoConstraints = false
        lowerCaseCriteriaView.translatesAutoresizingMaskIntoConstraints = false
        digitCriteriaView.translatesAutoresizingMaskIntoConstraints = false
        specialCharacterCriteriaView.translatesAutoresizingMaskIntoConstraints = false
        
        
    }
    
    private func layout() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(lengthCriteriaView)
        stackView.addArrangedSubview(criteriaLabel)
        stackView.addArrangedSubview(uppercaseCriteriaView)
        stackView.addArrangedSubview(lowerCaseCriteriaView)
        stackView.addArrangedSubview(digitCriteriaView)
        stackView.addArrangedSubview(specialCharacterCriteriaView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2),
            bottomAnchor.constraint(equalToSystemSpacingBelow: stackView.bottomAnchor, multiplier: 2),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2)
        ])
        
        
    }
    
    private func makeCriteriaMessage() -> NSAttributedString {
        var plainTextAttributes = [NSAttributedString.Key: AnyObject]()
        plainTextAttributes[.font] = UIFont.preferredFont(forTextStyle: .subheadline)
        plainTextAttributes[.foregroundColor] = UIColor.secondaryLabel
        
        var boldTextAttributes = [NSAttributedString.Key: AnyObject]()
        boldTextAttributes[.foregroundColor] = UIColor.label
        boldTextAttributes[.font] = UIFont.preferredFont(forTextStyle: .subheadline)

        let attrText = NSMutableAttributedString(string: "Use at least ", attributes: plainTextAttributes)
        attrText.append(NSAttributedString(string: "3 of these 4 ", attributes: boldTextAttributes))
        attrText.append(NSAttributedString(string: "criteria when setting your password:", attributes: plainTextAttributes))

        return attrText
    }
}

extension PasswordStatusView {
    func updateDisplay(_ text : String) {
        let lenghtAndNoSpaceMet = PasswordCriteria.lengthAndNoSpaceMet(text)
        let uppercaseMet = PasswordCriteria.uppercaseMet(text)
        let lowercaseMet = PasswordCriteria.lowercaseMet(text)
        let digitsMet = PasswordCriteria.digitsMet(text)
        let specialcharacterMet = PasswordCriteria.specialcharacterMet(text)
        
        if shouldResetCriteria {
            lenghtAndNoSpaceMet
            ?lengthCriteriaView.criteriaIsMet = true
            :lengthCriteriaView.reset()
            
            uppercaseMet
            ?uppercaseCriteriaView.criteriaIsMet = true
            :uppercaseCriteriaView.reset()
            
            lowercaseMet
            ?lowerCaseCriteriaView.criteriaIsMet = true
            :lowerCaseCriteriaView.reset()
            
            digitsMet
            ?digitCriteriaView.criteriaIsMet = true
            :digitCriteriaView.reset()
            
            specialcharacterMet
            ?specialCharacterCriteriaView.criteriaIsMet = true
            :specialCharacterCriteriaView.reset()
        } else {
            lengthCriteriaView.criteriaIsMet = lenghtAndNoSpaceMet
            uppercaseCriteriaView.criteriaIsMet = uppercaseMet
            lowerCaseCriteriaView.criteriaIsMet = lowercaseMet
            digitCriteriaView.criteriaIsMet = digitsMet
            specialCharacterCriteriaView.criteriaIsMet = specialcharacterMet
            
        }
        }
    
    func validate(_ text: String) -> Bool {
        let uppercaseMet = PasswordCriteria.uppercaseMet(text)
        let lowercaseMet = PasswordCriteria.lowercaseMet(text)
        let digitsMet = PasswordCriteria.digitsMet(text)
        let specialcharacterMet = PasswordCriteria.specialcharacterMet(text)
        
        let checkable = [uppercaseMet,lowercaseMet,digitsMet,specialcharacterMet]
        let metCriteria = checkable.filter{$0}
        let lenghtAndNoSpaceMet = PasswordCriteria.lengthAndNoSpaceMet(text)
        if lenghtAndNoSpaceMet && metCriteria.count >= 3 {
            return true
        }
        return false
        }
        
    
    func reset() {
        lengthCriteriaView.reset()
        uppercaseCriteriaView.reset()
        lowerCaseCriteriaView.reset()
        digitCriteriaView.reset()
        specialCharacterCriteriaView.reset()
    }
    
}
