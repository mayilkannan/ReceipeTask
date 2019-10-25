//
//  ReceipeDetailViewController.swift
//  Receipes
//
//  Created by Mac  on 25/10/19.
//  Copyright © 2019 kannan. All rights reserved.
//

import UIKit

class ReceipeDetailViewController: UIViewController {

    var receipeDetail: ReceipeModel!
    @IBOutlet weak var receipeNameText: UILabel!
    @IBOutlet weak var receipeTypeText: UILabel!
    @IBOutlet weak var receipeTimeText: UILabel!
    @IBOutlet weak var receipeDescText: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var ingredientView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        receipeNameText.text = receipeDetail.title
        let category = allCategories.filter{$0.id == receipeDetail.categoryId}
        if category.count > 0{
            receipeTypeText.text = category[0].name
        }
        receipeTimeText.text = "\(receipeDetail.time!) minutes"
        receipeDescText.text = receipeDetail.description
        
        pageControl.numberOfPages = receipeDetail.photosArray!.count
        pageControl.hidesForSinglePage = true

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    @IBAction func viewIngredientsAct(_ sender: Any) {
    
        ingredientView.isHidden = false
        
    }
    
    @IBAction func closeIngredientAct(_ sender: Any) {

        ingredientView.isHidden = true

    }
    @IBAction func backAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ReceipeDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receipeDetail.ingredients!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsTableViewCell", for: indexPath) as! IngredientsTableViewCell
        let ingredients = receipeDetail.ingredients![indexPath.row]
        let ingredientKey = ingredients.keys.first!
        let ingredient = allIngredients.filter{$0.ingredientId == Int(ingredientKey)}
        cell.ingredientNameText.text = ingredient[0].name
        cell.ingredientQuantityText.text = ingredients.values.first
        cell.ingredientImage.sd_setImage(with: URL(string: ingredient[0].photo_url!), completed: nil)
        return cell
    }
}

extension ReceipeDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return receipeDetail.photosArray!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReceipeDetailImageCollectionViewCell", for: indexPath) as! ReceipeDetailImageCollectionViewCell
        let imageUrl = receipeDetail.photosArray?[indexPath.row]
        cell.receipeImage.sd_setImage(with: URL(string: imageUrl!), completed: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        return CGSize(width: screenWidth, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.row
    }
}
