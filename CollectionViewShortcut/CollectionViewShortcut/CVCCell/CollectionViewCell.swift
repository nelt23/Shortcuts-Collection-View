//
//  CollectionViewCell.swift
//  CollectionViewShortcut
//
//  Created by Nuno Martins on 02/02/2019.
//  Copyright © 2019 Nuno Martins. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    let animationRotateDegres: CGFloat = 0.8
    let animationTranslateX: CGFloat = 1.0
    let animationTranslateY: CGFloat = 1.0
    let count: Int = 1
    
    var checkmarkView: SSCheckMark!
   
    var textLabel = UILabel()

    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel.frame = CGRect(x: self.contentView.center.x/2, y: self.contentView.center.y/2+20, width: textLabel.frame.width, height: textLabel.frame.height)
        textLabel.textColor = .white
        addSubview(textLabel)        
    }
    
   
    override func awakeFromNib() {
        super.awakeFromNib()

        checkmarkView = SSCheckMark(frame: CGRect(x: 10, y: 10, width: 35, height: 35))
        checkmarkView.backgroundColor = .clear
    
        self.addSubview(checkmarkView)
    }

}


extension CollectionViewCell {
    
    // https://stackoverflow.com/questions/14025600/uicollectionviewcell-shake/42308648#42308648
    func StartWobble() {
        
        let leftOrRight: CGFloat = (count % 2 == 0 ? 1 : -1)
        let rightOrLeft: CGFloat = (count % 2 == 0 ? -1 : 1)

        let leftWobble: CGAffineTransform = CGAffineTransform(rotationAngle: degreesToRadians(x: animationRotateDegres * leftOrRight))
        let rightWobble: CGAffineTransform = CGAffineTransform(rotationAngle: degreesToRadians(x: animationRotateDegres * rightOrLeft))
        let moveTransform: CGAffineTransform = leftWobble.translatedBy(x: -animationTranslateX, y: -animationTranslateY)
        let conCatTransform: CGAffineTransform = leftWobble.concatenating(moveTransform)
        
        transform = rightWobble // starting point
        
        UIView.animate(withDuration: 0.13, delay: 0.00, options: [.allowUserInteraction, .autoreverse, .repeat], animations: { () -> Void in
            self.transform = conCatTransform
        })
    
    }
    
    func StopWobble() {
        self.layer.removeAllAnimations()
        self.transform = CGAffineTransform(a: 1.0, b: 0.0, c: 0.0, d: 1.0, tx: 0.0, ty: 0.0)
    }
    
    func degreesToRadians(x: CGFloat) -> CGFloat {
        return CGFloat(CGFloat.pi) * x / 180.0
    }
    
}
