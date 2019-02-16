//
//  DefaultExtension.swift
//  CollectionViewShortcut
//
//  Created by Nuno Martins on 05/02/2019.
//  Copyright © 2019 Nuno Martins. All rights reserved.
//

import UIKit

extension UIView {
    
    func setGradientBackgroundColor(colorOne: UIColor, colorTow: UIColor) {
        let gradientLayer = CAGradientLayer()

        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTow.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        
        // ISTO É OURO (3 horas de procura)
        // https://hackernoon.com/color-it-with-gradients-ios-a4b374c3c79f
        // pelo que percebi add coloca por cima da cell ja o insert coloca dentro da cell como nos fazemos reload e o reload é back to front entao viamos as cores ao contrario
        self.layer.addSublayer(gradientLayer)
    }
    
}

extension Array {
    mutating func remove(at indexes: [Int]) {
        for index in indexes.sorted(by: >) {
            remove(at: index)
        }
    }
}

extension UIImage {
    convenience init(cell: CollectionViewCell) {
        
        let medidas = CGSize(width: cell.layer.bounds.width-1, height: cell.layer.bounds.height)
        UIGraphicsBeginImageContextWithOptions(medidas, true, 1.0)
        cell.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
    
}
