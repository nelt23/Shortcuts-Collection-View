//
//  CVCAnimationForCellsExtension.swift
//  CollectionViewShortcut
//
//  Created by Nuno Martins on 16/02/2019.
//  Copyright © 2019 Nuno Martins. All rights reserved.
//

import UIKit

extension CollectionViewController {
    
    // Previous -> Following
    // Following -> Previous
    func AnimationCell(FirstList: [String], SecondList: [String], FollowingToPrevious FtoP: Bool, Delete: Bool) {
        
        for x in FirstList {
            
            let firstIndex = FirstList.firstIndex(of: x)!
            
            // neste é para mudarmos as celulas de sitio caso seja necessario
            if SecondList.contains(x) {
                
                let secondIndex = SecondList.firstIndex(of: x)!
                
                // se extiverem em posiçoes das listas diferentes
                if firstIndex != secondIndex {
                    
                    // localizar a cell para ser copiada para uma imagem
                    var previousCell = CollectionViewCell()
                    var previousIndex = Int()
                    
                    if Delete == true {
                        previousIndex = FirstList.firstIndex(of: x)!
                        GetPreviousCell(previousCell: &previousCell, previousIndex: previousIndex, previousList: ListElementsText)
                        
                    } else {
                        // antes do trash
                        previousIndex = previousList.firstIndex(of: x)!
                        GetPreviousCell(previousCell: &previousCell, previousIndex: previousIndex, previousList: previousList)
                    }
                    
                    var imageViewSearch = UIImageView()
                    CopyCellToImage(Cell: previousCell, imageViewSearch: &imageViewSearch)
                    
                    var followingIndex = Int()
                    if Delete == true {
                        // depois do trash
                        followingIndex = SecondList.firstIndex(of: x)!
                    } else {
                        followingIndex = followingList.firstIndex(of: x)!
                    }
                    
                    let followingCenter = PositionCell(CellWidth: previousCell.frame.width, CellHeight: previousCell.frame.height, Index: followingIndex)
                    
                    collectionView.isHidden = true
                    
                    lBackgroundScreenWhite.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
                    self.view.insertSubview(lBackgroundScreenWhite, at: 0)
                    
                    UIView.animate(withDuration: 0.35, animations: {
                        
                        imageViewSearch.center.x = followingCenter.0
                        imageViewSearch.center.y = followingCenter.1
                        
                    }) { (_ Finish: Bool) in
                        
                        self.collectionView.isHidden = false
                        self.lBackgroundScreenWhite.removeFromSuperview()
                        imageViewSearch.removeFromSuperview()
                    }
                    
                    
                } else if FtoP == true || Delete == true {
                    // so acontece no Following -> Previous
                    // como  para adiconarmos imagens de celulas que nao estao visiveis temos de esconder a collection
                    // isto faz com que nas situaçoes onde temos celulas visiveis e queremos que aparecam outras as que ja estavam visiveis desaparecam
                    
                    // localizar a cell para ser copiada para uma imagem
                    var previousCell = CollectionViewCell()
                    var previousIndex = Int()
                    
                    if Delete == true {
                        previousIndex = FirstList.firstIndex(of: x)!
                        GetPreviousCell(previousCell: &previousCell, previousIndex: previousIndex, previousList: ListElementsText)

                    } else {
                        previousIndex = previousList.firstIndex(of: x)!
                        GetPreviousCell(previousCell: &previousCell, previousIndex: previousIndex, previousList: previousList)
                    }

                    var imageViewSearch = UIImageView()
                    CopyCellToImage(Cell: previousCell, imageViewSearch: &imageViewSearch)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        imageViewSearch.removeFromSuperview()
                    }
                    
                }
                
            } else {
                
                // esta é a situação onde nao temos celula nenhuma e queremos que ela apareca
                // para isso tivemos de criar uma imagem de cada celula antes do search para agora fazermos aparecer aquelas que nao sao visiveis
                if FtoP == true {
                    
                    if imageList.contains(where: { (string, image) -> Bool in
                        return string == x
                    }) {
                        
                        let imageViewSearch = UIImageView(image: imageList[x])
                        
                        imageViewSearch.layer.masksToBounds = true
                        imageViewSearch.layer.cornerRadius = 12.0
                        imageViewSearch.alpha = 0.0
                        
                        
                        let followingIndex = followingList.firstIndex(of: x)!
                        let size = CGSize(width: ((view.frame.width-16)/2)-12, height: 110)
                        let followingCenter = PositionCell(CellWidth: size.width, CellHeight: size.height, Index: followingIndex)
                        
                        imageViewSearch.center = CGPoint(x:followingCenter.0, y:followingCenter.1)
                        
                        self.navigationController?.view.addSubview(imageViewSearch)
                        
                        collectionView.isHidden = true
                        
                        lBackgroundScreenWhite.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
                        self.view.insertSubview(lBackgroundScreenWhite, at: 0)
                        
                        UIView.animate(withDuration: 0.35, animations: {
                            imageViewSearch.alpha = 1.0
                        }) { (Finish: Bool) in
                            self.collectionView.isHidden = false
                            self.lBackgroundScreenWhite.removeFromSuperview()
                            imageViewSearch.removeFromSuperview()
                        }
                        
                    }
                    
                    // fazer a celulas desaparecer
                } else {
                    
                    // localizar a cell para ser copiada para uma imagem
                    var previousCell = CollectionViewCell()
                    var previousIndex = Int()
                    
                    if Delete == true {
                        previousIndex = FirstList.firstIndex(of: x)!
                        GetPreviousCell(previousCell: &previousCell, previousIndex: previousIndex, previousList: ListElementsText)
                        
                    } else {
                        previousIndex = previousList.firstIndex(of: x)!
                        GetPreviousCell(previousCell: &previousCell, previousIndex: previousIndex, previousList: previousList)
                    }

                    var imageViewSearch = UIImageView()
                    CopyCellToImage(Cell: previousCell, imageViewSearch: &imageViewSearch)
                    
                    UIView.animate(withDuration: 0.35, animations: {
                        imageViewSearch.alpha = 0.0
                    }) { (Finish: Bool) in
                        imageViewSearch.removeFromSuperview()
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
    func GetPreviousCell(previousCell: inout CollectionViewCell, previousIndex: Int, previousList: [String]) {
        
        for z in collectionView.visibleCells {
            if (z as! CollectionViewCell).textLabel.text! == previousList[previousIndex] {
                previousCell = z as! CollectionViewCell
            }
        }
    }
    
    
    func CopyCellToImage(Cell: CollectionViewCell, imageViewSearch: inout UIImageView) {
        
        // criar a copia da celula para uma imagem
        let image = UIImage(cell: Cell)
        imageViewSearch = UIImageView(image: image)
        
        imageViewSearch.layer.masksToBounds = true
        imageViewSearch.layer.cornerRadius = 12.0
        
        let previousCenterX = collectionView.convert(Cell.center, to: nil).x
        let previousCenterY = collectionView.convert(Cell.center, to: nil).y
        
        imageViewSearch.center = CGPoint(x:previousCenterX, y:previousCenterY)
        
        self.navigationController?.view.addSubview(imageViewSearch)
    }
    
    func PositionCell(CellWidth: CGFloat, CellHeight: CGFloat, Index: Int) -> (CGFloat,CGFloat) {
        
        var cellCenterX: CGFloat
        var cellCenterY: CGFloat
        
        // par -> linha da esquerda
        if (Index%2) == 0 {
            
            cellCenterX = 8 + CellWidth/2
            
            // o y varia dependente o numero de linhas
            
            // 0  -> 0
            // 2 -> (cellSource.frame.height + 10) * 1
            // 4 -> (cellSource.frame.height + 10) * 2
            let NumberLines: CGFloat = CGFloat(Int(Index/2))
            
            cellCenterY = 8 + ((CellHeight + 10)*NumberLines) + CellHeight/2
            
            // impar -> linha da direita
        } else {
            
            cellCenterX = 8 + CellWidth + 24 + CellWidth/2
            
            // o y varia dependente o numero de linhas
            
            // 1  -> 0
            // 3 -> (cellSource.frame.height + 10) * 1
            // 5 -> (cellSource.frame.height + 10) * 2
            let NumberLines: CGFloat = CGFloat(Int(Index/2))
            
            cellCenterY = 8 + (CellHeight + 10)*NumberLines + CellHeight/2
        }
        
        let cellCenter = CGPoint(x: cellCenterX, y: cellCenterY)
        
        let centerX = self.collectionView.convert(cellCenter, to: nil).x
        let centerY = self.collectionView.convert(cellCenter, to: nil).y
        
        return (centerX,centerY)
    }
    
}
