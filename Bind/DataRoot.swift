//
//  DataRoot.swift
//  Bind
//
//  Created by Albert Q Park on 1/16/22.
//

import UIKit

class AnimalData {
    var mainImage: UIImage?
    var morePhotos = [UIImage]()
    let animal: Animal
    init(_ animal: Animal) {
        self.animal = animal
    }
}

class DataRoot: NSObject {
    var animals = [AnimalData]()
}
