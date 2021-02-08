//
//  ItemDataModelCell.swift
//  MVPShowcase
//
//  Created by Miran Brajsa on 08.02.2021..
//

import UIKit

class ItemDataModelCell: UITableViewCell {

    private var dataModel: ItemDataModel?

    @IBOutlet private weak var contentContainer: UIView!

    @IBOutlet private weak var lblLocation: UILabel!
    @IBOutlet private weak var lblName: UILabel!
    @IBOutlet private weak var lbDescription: UILabel!
    @IBOutlet private weak var lblPrice: UILabel!
        
    override func prepareForReuse() {
        super.prepareForReuse()
        
        dataModel = nil
        
        refresh()
    }
    
    func setup(with dataModel: ItemDataModel) {
        self.dataModel = dataModel
        
        refresh()
    }
}

extension ItemDataModelCell {
    
    private func refresh() {
        lblLocation.text = dataModel?.location
        lblName.text = dataModel?.name
        lbDescription.text = dataModel?.description
        lblPrice.text = String(format: "$%.2f", dataModel?.price ?? 0.00)
    }
}
