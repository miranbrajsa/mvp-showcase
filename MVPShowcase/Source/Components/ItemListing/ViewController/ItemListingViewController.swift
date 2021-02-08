//
//  ItemListingViewController.swift
//  MVPShowcase
//
//  Created by Miran Brajsa on 08.02.2021..
//

import UIKit

class ItemListingViewController: KeyboardReactingViewController {

    private let cellIdentifier = "ItemDataModelCell"
    
    private let presenter: ItemListingPresenter
    
    @IBOutlet private weak var sbGeneric: UISearchBar!
    @IBOutlet private weak var sbLocation: UISearchBar!

    @IBOutlet weak var tableView: UITableView!
    
    private var searchBarHeights: CGFloat {
        return sbGeneric.bounds.height + sbLocation.bounds.height
    }
    
    init(with presenter: ItemListingPresenter) {
        self.presenter = presenter
        
        super.init(nibName: String(describing: Self.self), bundle: nil)
        
        self.presenter.register(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented.")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        resignResponders()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.contentInset = UIEdgeInsets(top: searchBarHeights, left: 0, bottom: 0, right: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.requestListingData()
        
        navigationItem.title = "Item listing"

        setupAppearance()
        attachObservers()
    }
    
    private func setupAppearance() {
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.estimatedRowHeight = 73
    }
    
    private func attachObservers() {
        keyboardStateChangedClosure = { [weak self] state in
            switch state {
            case .willShow(let animationInfo):
                UIView.animate(
                    withDuration: animationInfo.duration,
                    delay: 0,
                    options: UIView.AnimationOptions(rawValue: animationInfo.curve),
                    animations: { [weak self] in
                        guard let self = self else { return }
                        self.tableView.contentInset = UIEdgeInsets(top: self.searchBarHeights, left: 0, bottom: animationInfo.keyboardHeight, right: 0)
                        self.view.layoutIfNeeded()
                })
            case .willHide(let animationInfo):
                UIView.animate(
                    withDuration: animationInfo.duration,
                    delay: 0,
                    options: UIView.AnimationOptions(rawValue: animationInfo.curve),
                    animations: { [weak self] in
                        guard let self = self else { return }
                        self.tableView.contentInset = UIEdgeInsets(top: self.searchBarHeights, left: 0, bottom: 0, right: 0)
                        self.view.layoutIfNeeded()
                })
            }
        }
        
        registerResponders(responders: [sbGeneric, sbLocation])
    }
}

extension ItemListingViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        guard let searchFieldType = SearchFieldType(rawValue: searchBar.tag) else { return }
        if searchFieldType == .generic {
            presenter.filterData(byGenericSearchString: searchBar.text)
        }
        else {
            presenter.filterData(byLocationSearchString: searchBar.text)
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchFieldType = SearchFieldType(rawValue: searchBar.tag) else { return }
        if searchFieldType == .generic {
            presenter.filterData(byGenericSearchString: searchBar.text)
        }
        else {
            presenter.filterData(byLocationSearchString: searchBar.text)
        }
    }
}

extension ItemListingViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.modelCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ItemDataModelCell else {
            fatalError("This should never happen.")
        }

        guard let dataModel = presenter.dataModel(for: indexPath) else { return cell }
        cell.setup(with: dataModel)
        return cell
    }
}

extension ItemListingViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        presenter.presentDetails(forItemAtIndexPath: indexPath)
    }
}
