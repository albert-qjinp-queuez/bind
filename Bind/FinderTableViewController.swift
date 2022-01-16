//
//  FinderTableViewController.swift
//  Bind
//
//  Created by Albert Q Park on 1/16/22.
//

import UIKit

class FinderTableViewController: UITableViewController {
    let service = ServiceRoot.shared
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        title = "Search"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        service.delegate = self
        tableView.register(UINib(nibName: "AnimalTableViewCell", bundle: nil), forCellReuseIdentifier: "AnimalTableViewCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if service.isServiceDirty  {
            self.tableView.reloadData()
            service.isServiceDirty = false
            service.findPet { (_: Any?) in
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
        return service.dataRoot.animals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let animal = service.dataRoot.animals[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AnimalTableViewCell", for: indexPath) as? AnimalTableViewCell else {
            let cell = AnimalTableViewCell(style: .default, reuseIdentifier: "AnimalTableViewCell")
            return cell
        }
        cell.name.text = animal.animal.name
        cell.setPhoto(animal.mainImage)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            return
        }
        let animal = service.dataRoot.animals[indexPath.row]
        
        detailVC.animal = animal
        navigationController?.pushViewController(detailVC, animated: true)
    }

}

extension FinderTableViewController: ServiceDelegate {
    func imageLoaded(index: Int) {
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
}
