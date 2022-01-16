//
//  AnimalTableViewCell.swift
//  Bind
//
//  Created by Albert Q Park on 1/16/22.
//

import UIKit

class AnimalTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var photo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    func setPhoto(_ image:UIImage?) {
        photo.image = image
        photo.sizeThatFits(self.frame.size)
    }
    
}
