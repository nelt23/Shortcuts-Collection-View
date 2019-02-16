//
//  CVCSearchBarExtension.swift
//  CollectionViewShortcut
//
//  Created by Nuno Martins on 14/02/2019.
//  Copyright © 2019 Nuno Martins. All rights reserved.
//

import UIKit

extension CollectionViewController: UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
        followingText = searchController.searchBar.text!
        
        // quando se começa
        if followingText == "" && previousText == "" {
            previousList = ListElementsText
        } else {
            previousList = ListElementsTextFilter
        }
        
        ListElementsTextFilter = ListElementsText.filter({ (List : String) -> Bool in
            
            if List.contains(searchController.searchBar.text!) {
                return true
            } else {
                return false
            }
            
        })
        
        ListElementsColorsFilter.removeAll()
        for i in 0..<ListElementsText.count {
            for j in 0..<ListElementsTextFilter.count {
                if ListElementsText[i] == ListElementsTextFilter[j] {
                    ListElementsColorsFilter.append(ListElements[i])
                }
            }
        }
        
        // caso a meio da pesquisa apaguemos tudo
        if followingText != "" && previousText == "" {
            previousList = ListElementsText
        }
        
        // quando se apaga tudo nao existem fitros
        if searchController.searchBar.text! == "" {
            followingList = ListElementsText
        } else {
            followingList = ListElementsTextFilter
        }
        
        // se tivermos a escrever no search
        if previousText.count <= followingText.count {
            
            // Previous -> Following
            AnimationCell(FirstList: previousList, SecondList: followingList, FollowingToPrevious: false, Delete: false)
 
        // se estivermos a apagar no search
        } else {
            
            // Following -> Previous
            AnimationCell(FirstList: followingList, SecondList: previousList, FollowingToPrevious: true, Delete: false)
        }
        
        print("Previous -> \(searchController.searchBar.text!) -> \(previousList)")
        print("Following -> \(searchController.searchBar.text!) -> \(followingList)")
        collectionView.reloadData()
    }

        
    // quando se entra e estiver no formato editar passa para o normal
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

        // podiamos ter saido e voltar a entrar mas ja com filter dando um erro
        if collectionView.visibleCells.count == ListElementsText.count {
            imageList.removeAll()
            
            for x in collectionView.visibleCells {
                let cell =  x as! CollectionViewCell
                let image = UIImage(cell: cell)
                imageList[cell.textLabel.text!] = image
            }
            
        }
        
        self.collectionView.removeGestureRecognizer(tapGesture)
        self.collectionView.removeGestureRecognizer(pressGesture)
        self.view.removeGestureRecognizer(panGesture)
        
        animateCell = false
        EditButton.title = "Edit"
        EditButton.style = .plain
        
        countNumberOfCellsSelected = 0
        self.navigationItem.title = "Lists"
        
        item = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:  #selector(AddList))
        item.isEnabled = true
        
        // limpar os valores pois cancelarmos os checkmarks
        for i in 0..<ListElementsTrash.count {
            ListElementsTrash[i] = 0
        }
        
        self.navigationItem.setRightBarButton(item, animated: true)
        collectionView.reloadData()
    } 
    
   
}
