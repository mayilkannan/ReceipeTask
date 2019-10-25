//
//  ViewController.swift
//  Receipes
//
//  Created by Mac  on 24/10/19.
//  Copyright © 2019 kannan. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

var allCategories = [CategoryModel]()
var allReceipes = [ReceipeModel]()

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var db: Firestore? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        getRecipes()
        getCategories()
        // Do any additional setup after loading the view.
    }
    
    func getRecipes() {
        db?.collection("recipes").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let data = document.data()
                    allReceipes.append(ReceipeModel(recipeId: data["recipeId"] as? Int, categoryId: data["categoryId"] as? Int, title: data["title"] as? String, photo_url: data["photo_url"] as? String, photosArray: data["photosArray"] as? [String], time: data["time"] as? Int, ingredients: data["ingredients"] as? [[String : String]], description: data["description"] as? String))
                }
                allReceipes = allReceipes.sorted(by: { $0.recipeId! < $1.recipeId! })
                if allCategories.count > 0{
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func getCategories() {
        db?.collection("categories").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let data = document.data()
                    allCategories.append(CategoryModel(id: data["id"] as? Int, name: data["name"] as? String, photo_url: data["photo_url"] as? String))
                }
                allCategories = allCategories.sorted(by: { $0.id! < $1.id! })
                if allReceipes.count > 0{
                    self.collectionView.reloadData()
                }
            }
        }
    }

    @IBAction func gotoCategoryAct(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CategoryVC")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allReceipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReceipesCollectionViewCell", for: indexPath) as! ReceipesCollectionViewCell
        let receipe = allReceipes[indexPath.row]
        let category = allCategories.filter{$0.id == receipe.categoryId}
        cell.receipeName.text = receipe.title
        if category.count > 0{
            cell.receipeType.text = category[0].name
        }
        cell.receipeImage.sd_setImage(with: URL(string: receipe.photo_url!), completed: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ReceipeDetailVC") as! ReceipeDetailViewController
        vc.receipeDetail = allReceipes[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width - 20
        let splitsize = Int(screenWidth/150)
        return CGSize(width: screenWidth/CGFloat(splitsize), height: 220)
    }
}
