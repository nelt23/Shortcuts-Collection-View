//
//  CollectionViewController.swift
//  CollectionViewShortcut
//
//  Created by Nuno Martins on 02/02/2019.
//  Copyright © 2019 Nuno Martins. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var EditButton: UIBarButtonItem!
    
    var item = UIBarButtonItem()

    var ListElements = [[#colorLiteral(red: 0.9338900447, green: 0.4315618277, blue: 0.2564975619, alpha: 1),#colorLiteral(red: 0.8518816233, green: 0.1738803983, blue: 0.01849062555, alpha: 1)],[#colorLiteral(red: 0.4613699913, green: 0.3118675947, blue: 0.8906354308, alpha: 1),#colorLiteral(red: 0.3018293083, green: 0.1458326578, blue: 0.7334778905, alpha: 1)],[#colorLiteral(red: 0.3796315193, green: 0.7958304286, blue: 0.2592983842, alpha: 1),#colorLiteral(red: 0.2060100436, green: 0.6006633639, blue: 0.09944178909, alpha: 1)],[#colorLiteral(red: 0.9409626126, green: 0.7209432721, blue: 0.1315650344, alpha: 1),#colorLiteral(red: 0.8931249976, green: 0.5340107679, blue: 0.08877573162, alpha: 1)],[#colorLiteral(red: 0.3045541644, green: 0.6749247313, blue: 0.9517192245, alpha: 1),#colorLiteral(red: 0.008423916064, green: 0.4699558616, blue: 0.882807076, alpha: 1)]]
    var ListElementsText = ["Aljustrel","Albufeira","Almada","Lisboa","Porto"]
    
    var ListElementsTextFilter : [String] = [] 
    var ListElementsColorsFilter : [[UIColor]] = []
    
    var previousList = [String]()
    var followingList = [String]()
    var imageList = [String:UIImage]()
    
    var ListElementsTrash : [Int] = {
        
        var ListTrash = [Int]()
        for i in 0...4 {
            ListTrash.append(0)
        }
        return ListTrash
    }()
    
    var previousText = ""
    var followingText = "" {
        willSet {
            previousText = followingText
        }
    }

    var panGesture = UIPanGestureRecognizer()
    var pressGesture = UILongPressGestureRecognizer()
    var tapGesture = UITapGestureRecognizer()
   
    var cellMoved = false
    var animateCell = false

    var centerX = CGFloat()
    var centerY = CGFloat()
    var imageView = UIImageView()

    var countNumberOfCellsSelected = 0
    var selectedIndexPath : IndexPath? = IndexPath()
    
    var searchBarController: UISearchController!

    let lBackgroundScreenWhite : UILabel = {
        
        let label = UILabel()
        label.backgroundColor = .white
        return label
    }()
    
    override func viewDidLoad() {  
        super.viewDidLoad()

        // Remove border between collection and navigationBar
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")

        item = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(AddList))
        self.navigationItem.setRightBarButton(item, animated: true)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(TapGesture(_:)))
        tapGesture.delegate = self
        
        pressGesture = UILongPressGestureRecognizer(target: self, action: #selector(PressGesture(_:)))
        pressGesture.minimumPressDuration = 0.1
        pressGesture.delegate = self
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(PanGesture(_:)))
        panGesture.delegate = self

        searchBarController = UISearchController(searchResultsController: nil)
        searchBarController.searchBar.delegate = self
        searchBarController.hidesNavigationBarDuringPresentation = false
        searchBarController.obscuresBackgroundDuringPresentation = false

        searchBarController.searchResultsUpdater = self
        searchBarController.delegate = self
        self.navigationItem.searchController = searchBarController
    }
    
    
    // https://stackoverflow.com/questions/46239883/show-search-bar-in-navigation-bar-without-scrolling-on-ios-11
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    
    @IBAction func EditList(_ sender: Any) {
        print("Edit list")

        // nao podemos ativar se estivermos a pesquisar
        if searchBarController.isActive == false {
        
            // ou seja se estavamos a editar e queremos parar a edição
            if animateCell == true {

                self.collectionView.removeGestureRecognizer(tapGesture)
                self.collectionView.removeGestureRecognizer(pressGesture)
                self.view.removeGestureRecognizer(panGesture)

                animateCell = false
                EditButton.title = "Edit"
                EditButton.style = .plain

                countNumberOfCellsSelected = 0
                self.navigationItem.title = "Lists"

                item = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(AddList))
                item.isEnabled = true
                
                // limpar os valores pois cancelarmos os checkmarks
                for i in 0..<ListElementsTrash.count {
                    ListElementsTrash[i] = 0
                }
                
            } else {
                
                self.collectionView.addGestureRecognizer(tapGesture)
                self.collectionView.addGestureRecognizer(pressGesture)
                self.view.addGestureRecognizer(panGesture)

                animateCell = true
                EditButton.title = "OK"
                EditButton.style = .done

                item = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(TrashList))
                item.isEnabled = false
            }
            
            self.navigationItem.setRightBarButton(item, animated: true)
            collectionView.reloadData()
        }
        
    }
    
    
    @objc func AddList(_ sender: Any) {
        print("Add list")
    }
    
    
    @objc func TrashList() {
        print("Add new list \(ListElementsTrash.count)")
        
        var trashArray = [Int]()
        
        for i in 0..<ListElementsTrash.count {
            if ListElementsTrash[i] == 1 {
                trashArray.append(i)
            }
        }

        var followingListElementsText = ListElementsText
        followingListElementsText.remove(at: trashArray)
        
        AnimationCell(FirstList: ListElementsText, SecondList: followingListElementsText, FollowingToPrevious: false, Delete: true)
        
        ListElements.remove(at: trashArray)
        ListElementsTrash.remove(at:trashArray)
        ListElementsText.remove(at: trashArray)
                
        countNumberOfCellsSelected = 0
        
        if ListElements.count == 0 {
            
            self.navigationItem.title = "Lists"
            
            animateCell = false
            EditButton.title = "Edit"
            EditButton.style = .plain

            item = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(AddList))
            item.isEnabled = true

            self.navigationItem.setRightBarButton(item, animated: true)
        }
        
        collectionView.reloadData()
    }

}

