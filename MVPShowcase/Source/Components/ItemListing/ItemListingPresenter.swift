//
//  ItemListingPresenter.swift
//  MVPShowcase
//
//  Created by Miran Brajsa on 08.02.2021..
//

import Foundation

protocol ItemListingPresenterView: class {
    func updateListingTableView()
}

class ItemListingPresenter {
    
    // We're using a serial queue to encase all reads and writes to our data model
    // since the API is delivering them on a background queue and the view controller
    // is reading them from the main queue. This way we avoid access violation if
    // both happen in the same time.
    private let modelQueue = DispatchQueue(label: "DataModelQueue", qos: .utility, attributes: .concurrent)
    private var models: [ItemDataModel]?

    private let filterQueue = DispatchQueue(label: "FilterQueue", qos: .utility)
    private var genericSearchString: String?
    private var locationSearchString: String?

    private let itemListingStore: ItemListingStore
    private let itemSelectedClosure: (ItemDataModel) -> (Void)
        
    private var filteredModels: [ItemDataModel] {
        let allModels = modelQueue.sync { models } ?? []
        
        var locationFilteredOutModels = allModels
        if let locationSearchString = (self.filterQueue.sync { self.locationSearchString }) {
            locationFilteredOutModels = filteringWorker(for: allModels, stringsToCheckClosure: { [$0.location] }, searchString: locationSearchString)
        }
        
        var genericallyFilteredOutModels = locationFilteredOutModels
        if let genericSearchString = (filterQueue.sync { genericSearchString }) {
            genericallyFilteredOutModels = filteringWorker(for: locationFilteredOutModels,
                                                           stringsToCheckClosure: { [$0.name,
                                                                                     $0.description ?? "",
                                                                                     String($0.price)] },
                                                           searchString: genericSearchString)
        }
        return genericallyFilteredOutModels
    }
    
    private func filteringWorker(for models: [ItemDataModel], stringsToCheckClosure: (ItemDataModel) -> ([String]), searchString: String) -> [ItemDataModel] {
        guard !searchString.isEmpty else { return models }
        
        let filteredOutModels = models.filter { model in
            stringsToCheckClosure(model).reduce(into: false) { $0 = $0 || ($1.range(of: searchString, options: .caseInsensitive) != nil) }
        }
        return filteredOutModels

    }
    
    init(with dataStore: DataStore, itemSelectedClosure: @escaping (ItemDataModel) -> (Void)) {
        guard let itemListingStore = dataStore as? ItemListingStore else {
            fatalError("'DataStore' needs to have 'ItemListingStore' implemented.")
        }
        self.itemListingStore = itemListingStore
        self.itemSelectedClosure = itemSelectedClosure
    }
    
    // MARK: - Presenter/view connection
    private weak var presenterView: ItemListingPresenterView?
    
    func register(_ presenterView: ItemListingPresenterView) {
        self.presenterView = presenterView
    }
}

// MARK: - Command interface
extension ItemListingPresenter {

    func requestListingData() {
        itemListingStore.fetchListing { [weak self] models in
            self?.modelQueue.async(flags: .barrier) { [weak self] in
                self?.models = models

                self?.updatePresentingVew()
            }
        }
    }
    
    func modelCount() -> Int {
        return filteredModels.count
    }
    
    func dataModel(for indexPath: IndexPath) -> ItemDataModel? {
        guard filteredModels.count > indexPath.row else { return nil }

        return filteredModels[indexPath.row]
    }
    
    func filterData(byGenericSearchString earchString: String?) {
        filterQueue.sync { self.genericSearchString = earchString }

        updatePresentingVew()
    }

    func filterData(byLocationSearchString searchString: String?) {
        filterQueue.sync { self.locationSearchString = searchString }

        updatePresentingVew()
    }
    
    func presentDetails(forItemAtIndexPath indexPath: IndexPath) {
        guard filteredModels.count > indexPath.row else { return }
        
        itemSelectedClosure(filteredModels[indexPath.row])
    }
    
    private func updatePresentingVew() {
        // We should make sure that presenters are always calling
        // their view's methods on the main thread.
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.presenterView?.updateListingTableView()
        }
    }
}
