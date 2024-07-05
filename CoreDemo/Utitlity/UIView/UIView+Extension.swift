//
//  UIView+Extension.swift
//  TriviaJack
//
//  Created by Mobilecoderz5 on 15/01/21.
//  Copyright © 2021 mobilecoderz. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    func makeRounded() {
        self.layer.cornerRadius = self.frame.size.width/2.0
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    var isViewEmpty : Bool {
        return self.subviews.count == 0
    }
    func makeRoundCorner(_ radius:CGFloat){
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    func makeRoundCornerDefault(){
        self.layer.cornerRadius = self.layer.cornerRadius / 2
        self.clipsToBounds = true
    }
    
    func makeBorder(_ width:CGFloat,color:UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        self.clipsToBounds = true
    }
    func addShadowWithRadius(radius: CGFloat ,cornerRadius: CGFloat ){
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = radius
        layer.cornerRadius = cornerRadius
    }
    func addShadowWithParticRadius(radius: CGFloat ,cornerRadius: CGFloat ){
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = radius
        layer.cornerRadius = cornerRadius
    }
    func setShadowWithColor() {
        layer.cornerRadius = 5
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 0 ,height: 3)
        self.layer.shadowRadius = 5
        
    }
    func setRadius(_ corner : CGFloat){
        layer.cornerRadius = corner
        clipsToBounds = true
    }
    var parentViewController: UIViewController? {
        for responder in sequence(first: self, next: { $0.next }) {
            if let viewController = responder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    // For insert layer in Foreground
    func addBlackGradientLayerInForeground(frame: CGRect, colors:[UIColor]){
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map{$0.cgColor}
        self.layer.addSublayer(gradient)
    }
    // For insert layer in background
    func addBlackGradientLayerInBackground(frame: CGRect, colors:[UIColor]){
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map{$0.cgColor}
        self.layer.insertSublayer(gradient, at: 0)
    }
    func setBottomShadow(radius: CGFloat = 2.0){
        self.layer.masksToBounds = false
        self.layer.cornerRadius = radius
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: -1 ,height: +3)
        self.layer.shadowRadius = radius
    }
    func snapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let copied = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return copied
    }
    func roundCornersFinal(corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            let cornerMasks = [
                corners.contains(.topLeft) ? CACornerMask.layerMinXMinYCorner : nil,
                corners.contains(.topRight) ? CACornerMask.layerMaxXMinYCorner : nil,
                corners.contains(.bottomLeft) ? CACornerMask.layerMinXMaxYCorner : nil,
                corners.contains(.bottomRight) ? CACornerMask.layerMaxXMaxYCorner : nil,
                corners.contains(.allCorners) ? [CACornerMask.layerMinXMinYCorner, CACornerMask.layerMaxXMinYCorner, CACornerMask.layerMinXMaxYCorner, CACornerMask.layerMaxXMaxYCorner] : nil
                ].compactMap({ $0 })
            
            var maskedCorners: CACornerMask = []
            cornerMasks.forEach { (mask) in maskedCorners.insert(mask) }
            
            self.clipsToBounds = true
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = maskedCorners
        } else {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}


extension UITextField {
    func setAttributedPlaceholder(placeHolder: String, color: UIColor , font: UIFont?) {
        let attributesDictionary = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font]
        self.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: attributesDictionary)
        
    }
    
}
