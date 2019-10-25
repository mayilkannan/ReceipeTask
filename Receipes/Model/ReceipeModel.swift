//
//  ReceipeModel.swift
//  Receipes
//
//  Created by Mac  on 25/10/19.
//  Copyright © 2019 kannan. All rights reserved.
//

struct ReceipeModel {
    var recipeId: Int?
    var categoryId: Int?
    var title: String?
    var photo_url: String?
    var photosArray: [String]?
    var time: Int?
    var ingredients: [[String: String]]?
    var description: String?
}
