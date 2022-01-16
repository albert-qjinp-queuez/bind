//
//  DetailViewController.swift
//  Bind
//
//  Created by Albert Q Park on 1/16/22.
//

import UIKit

class DetailViewController: UITableViewController {
    let service = ServiceRoot.shared
    
    var animal: AnimalData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = animal?.animal.name
        
        tableView.register(UINib(nibName: "AnimalTableViewCell", bundle: nil), forCellReuseIdentifier: "AnimalTableViewCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        if let animal = animal,
            animal.morePhotos.count == 0 {
            service.getBigImage(animal) { (images:[UIImage]) in
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return animal?.morePhotos.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let image = animal?.morePhotos[indexPath.row],
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnimalTableViewCell", for: indexPath) as? AnimalTableViewCell else {
            return AnimalTableViewCell()
        }
        cell.name.text = nil
        cell.setPhoto(image)
        return cell
    }
}
