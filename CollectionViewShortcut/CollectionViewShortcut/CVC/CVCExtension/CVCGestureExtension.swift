//
//  CVCGestureExtension.swift
//  CollectionViewShortcut
//
//  Created by Nuno Martins on 14/02/2019.
//  Copyright © 2019 Nuno Martins. All rights reserved.
//

import UIKit

extension CollectionViewController: UIGestureRecognizerDelegate {
  
    func gestureRecognizer (_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // quando queremos selecionar o CheckMark
    @objc func TapGesture (_ gesture: UITapGestureRecognizer) {
        
        let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView))
        
        if let selectedIndexPath = selectedIndexPath {
            
            let cell = collectionView.cellForItem(at: selectedIndexPath) as! CollectionViewCell
            
            if cell.checkmarkView.checked == false {
                
                cell.checkmarkView.checked = true
                countNumberOfCellsSelected += 1
                ListElementsTrash[selectedIndexPath.row] = 1
                
            } else {
                
                cell.checkmarkView.checked = false
                countNumberOfCellsSelected -= 1
                ListElementsTrash[selectedIndexPath.row] = 0
            }
            
            if countNumberOfCellsSelected == 0 {
                self.navigationItem.title = "Lists"
                item.isEnabled = false
            } else {
                self.navigationItem.title = "\(countNumberOfCellsSelected) selected"
                item.isEnabled = true
            }
            
        }
        
    }
    
    
    @objc func PressGesture (_ gesture: UILongPressGestureRecognizer) {
        
        // quando nao se move a celula de sitio queremos que a animação diminua para a escala correta
        switch gesture.state {
            
        case .began:
            selectedIndexPath = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView))
            
            if let selectedIndexPath = self.selectedIndexPath {
                
                let cellSource = self.collectionView.cellForItem(at: selectedIndexPath) as! CollectionViewCell
                
                centerX = self.collectionView.convert(cellSource.center, to: nil).x
                centerY = self.collectionView.convert(cellSource.center, to: nil).y
            }
            
        case .ended:
            
            if cellMoved == false {
                
                UIView.animate(withDuration: 0.35, animations: {
                    
                    self.imageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    self.imageView.alpha = 1.0
                    
                    self.imageView.center.x = self.centerX
                    self.imageView.center.y = self.centerY
                    
                }) { (_ Finish: Bool) in
                    
                    self.imageView.removeFromSuperview()
                    self.collectionView.isScrollEnabled = true
                    self.collectionView.addGestureRecognizer(self.tapGesture)
                    self.animateCell = true
                    
                    self.collectionView.reloadData()
                }
                
            } else {
                cellMoved = false
            }
            
        default:
            break
        }
    }
    
    // O PanGesture é que tem o translation (UILongPressGestureRecognizer nao tem)
    @objc func PanGesture (_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: nil)
        
        switch (gesture.state) {
        case .began:
            self.collectionView.isScrollEnabled = false
        case .changed:
            imageView.center = CGPoint(x: centerX + translation.x, y: centerY + translation.y)
        default:
            break
        }
        
    }
    
}
