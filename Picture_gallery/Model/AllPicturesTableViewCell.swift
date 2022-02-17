//
//  AllPicturesTableViewCell.swift
//  Picture_gallery
//
//  Created by Денис Вагнер on 16.02.2022.
//

import UIKit

class AllPicturesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    
    @IBOutlet weak var viewsLabel: UILabel!
    
    @IBOutlet weak var imageResolution: UILabel!
    @IBOutlet weak var imageSize: UILabel!
    
    @IBOutlet weak var activInd: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
