//
//  KeyboardReactingViewController.swift
//  MVPShowcase
//
//  Created by Miran Brajsa on 08.02.2021..
//

import UIKit

class KeyboardReactingViewController: UIViewController {
    
    private var responders = [UIResponder]()
    
    var keyboardStateChangedClosure: ((KeyboardState) -> ())? = nil

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerKeyboardObservers()
    }
    
    func registerResponders(responders: [UIResponder]) {
        self.responders = responders
    }
    
    func resignResponders() {
        responders.forEach { responder in
            responder.resignFirstResponder()
        }
    }
    
    private func registerKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(KeyboardReactingViewController.keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(KeyboardReactingViewController.keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardRectValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
              let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            else { return }
        
        let keyboardHeight = keyboardRectValue.cgRectValue.size.height
        let animationInfo = KeyboardAnimationInfo(duration: duration.doubleValue, keyboardHeight: keyboardHeight, curve: curve.uintValue)
        keyboardStateChangedClosure?(.willShow(animationInfo))
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardRectValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
              let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            else { return }
        
        let keyboardHeight = keyboardRectValue.cgRectValue.size.height
        let animationInfo = KeyboardAnimationInfo(duration: duration.doubleValue, keyboardHeight: keyboardHeight, curve: curve.uintValue)
        keyboardStateChangedClosure?(.willHide(animationInfo))
    }
}
