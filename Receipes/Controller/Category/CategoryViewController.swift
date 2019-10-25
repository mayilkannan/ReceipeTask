//
//  CategoryViewController.swift
//  Receipes
//
//  Created by Mac  on 24/10/19.
//  Copyright © 2019 kannan. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
        let category = allCategories[indexPath.row]
        cell.categoryType.text = category.name
        let receipes = allReceipes.filter{$0.categoryId == category.id}
        cell.receipesCount.text = "\(receipes.count) receipes"
        cell.categoryImage.sd_setImage(with: URL(string: category.photo_url!), completed: nil)
        return cell
    }
}

