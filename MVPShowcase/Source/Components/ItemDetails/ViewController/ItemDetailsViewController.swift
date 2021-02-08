//
//  ItemDetailsViewController.swift
//  MVPShowcase
//
//  Created by Miran Brajsa on 09.02.2021..
//

import UIKit

class ItemDetailsViewController: UIViewController {

    private let presenter: ItemDetailsPresenter
    
    @IBOutlet private weak var lblPrice: UILabel!
    @IBOutlet private weak var lblDescription: UILabel!
    @IBOutlet private weak var lblLocation: UILabel!
    
    init(with presenter: ItemDetailsPresenter) {
        self.presenter = presenter
        
        super.init(nibName: String(describing: Self.self), bundle: nil)
        
        self.presenter.register(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = presenter.viewTitle
        
        setupContent()
    }

    private func setupContent() {
        lblPrice.text = presenter.price
        lblLocation.text = presenter.location
        lblDescription.text = presenter.description
    }
}
