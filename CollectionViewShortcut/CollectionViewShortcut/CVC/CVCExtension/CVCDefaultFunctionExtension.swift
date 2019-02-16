//
//  CVCDefaultFunctionExtension.swift
//  CollectionViewShortcut
//
//  Created by Nuno Martins on 05/02/2019.
//  Copyright © 2019 Nuno Martins. All rights reserved.
//

import UIKit

extension CollectionViewController {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((view.frame.width-16)/2)-12, height: 110)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if searchBarController.searchBar.text! == "" {
            return ListElementsText.count
        } else {
            return ListElementsTextFilter.count
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell

        if searchBarController.searchBar.text! == "" {
            // cell Efects
            roundCorner(cell: cell)
            gradientBackgroundColor(cell: cell, colors: ListElements[indexPath.row])
            setCellShadow(cell: cell)
            
            cell.textLabel.text = ListElementsText[indexPath.row]
            cell.textLabel.sizeToFit()
            
        } else {
            
            // cell Efects
            roundCorner(cell: cell)
            gradientBackgroundColor(cell: cell, colors: ListElementsColorsFilter[indexPath.row])
            setCellShadow(cell: cell)
            
            cell.textLabel.text = ListElementsTextFilter[indexPath.row]
            cell.textLabel.sizeToFit()
            
        }
       
        if animateCell == true {
            
            cell.StartWobble()
            cell.checkmarkView.isHidden = false
            
            if ListElementsTrash[indexPath.row] == 0 {
                cell.checkmarkView.checked = false
            } else {
                cell.checkmarkView.checked = true
            }
            
        } else {
            cell.checkmarkView.isHidden = true
            cell.StopWobble()
        }
        
        
        if countNumberOfCellsSelected == 0 {
            self.navigationItem.title = "Lists"
        } else {
            self.navigationItem.title = "\(countNumberOfCellsSelected) selected"
        }
        
        return cell
    }
    
    // https://www.youtube.com/watch?v=GyKYiHrXeBk
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        
        if EditButton.title == "OK" {
            
            collectionView.removeGestureRecognizer(tapGesture)

            let Image = UIImage(cell: cell)
            imageView = UIImageView(image: Image)
            
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = 14

            centerX = collectionView.convert(cell.center, to: nil).x
            centerY = collectionView.convert(cell.center, to: nil).y
            
            imageView.center = CGPoint(x:centerX, y:centerY)
            
            self.navigationController?.view.addSubview(imageView)
            cell.isHidden = true

            UIView.animate(withDuration: 0.25, animations: {
                self.imageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.imageView.alpha = 0.8
            })
            
            return true
        } else {
            return false
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let item = ListElements.remove(at: sourceIndexPath.item)
        ListElements.insert(item, at: destinationIndexPath.item)
        
        let itemTrash = ListElementsTrash.remove(at: sourceIndexPath.item)
        ListElementsTrash.insert(itemTrash, at: destinationIndexPath.item)
    
        let itemText = ListElementsText.remove(at: sourceIndexPath.item)
        ListElementsText.insert(itemText, at: destinationIndexPath.item)

        // calcular as medidas consoante o destinationIndexPath
        // tem de ser feito assim pois no momento em que queremos animar a celula esta ainda nao existe, e nao ha outra forma de sabermos o center da cell
        
        // como todas as celulas tem a mesma medida podemos usar esta como padrão
        let cellSource = self.collectionView.cellForItem(at: sourceIndexPath) as! CollectionViewCell

        let center = PositionCell(CellWidth: cellSource.frame.width, CellHeight: cellSource.frame.height, Index: destinationIndexPath.row)
        
        cellMoved = true
        
        UIView.animate(withDuration: 0.35, animations: {
            
            self.imageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.imageView.alpha = 1.0
            
            self.imageView.center.x = center.0
            self.imageView.center.y = center.1
            
        }) { (_ Finish: Bool) in
                
                self.imageView.removeFromSuperview()
                self.collectionView.isScrollEnabled = true
                self.collectionView.addGestureRecognizer(self.tapGesture)
                self.animateCell = true
            
                // por o wooble em todas
                self.collectionView.reloadData()
        }
    }
    
}
