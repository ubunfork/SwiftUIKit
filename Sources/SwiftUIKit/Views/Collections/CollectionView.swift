//
//  CollectionView.swift
//  SwiftUIKit
//
//  Created by Daniel Saidi on 2020-11-10.
//  Copyright © 2020 Daniel Saidi. All rights reserved.

import SwiftUI

/**
 This view can be used to create a collection view that uses
 any kind of layout, e.g. a vertically scrolling list with a
 set of horizontally scrolling rows.
 
 You find the various layouts in the `Layouts` folder. There
 are currently these following layouts to choose from:
 
 * `.catalog` creates a vertical list with horizontal rows.
 * `.grid` creates a vertical grid with x items per grid row. 
 
 Credits to `@defagos`, who created this as part of his work
 to bring amazing, performant collection views to `SwiftUI`:
 https://github.com/defagos/SwiftUICollection
 */
public struct CollectionView<Section: Hashable, Item: Hashable, Cell: View, SupplementaryView: View>: UIViewRepresentable {
    
    
    // MARK: - Initialization
    
    /**
     Create a collection view with a certain layout instance.
     */
    public init(
        rows: [CollectionViewRow<Section, Item>],
        layout: CollectionViewLayout,
        @ViewBuilder cell: @escaping (IndexPath, Item) -> Cell,
        @ViewBuilder supplementaryView: @escaping (String, IndexPath) -> SupplementaryView) {
        self.cell = cell
        self.rows = rows
        self.sectionLayoutProvider = layout.sectionLayoutProvider
        self.supplementaryView = supplementaryView
    }
    
    /**
     Create a collection view with a certain layout provider.
     */
    public init(
        rows: [CollectionViewRow<Section, Item>],
        sectionLayoutProvider: @escaping (Int, NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection,
        @ViewBuilder cell: @escaping (IndexPath, Item) -> Cell,
        @ViewBuilder supplementaryView: @escaping (String, IndexPath) -> SupplementaryView) {
        self.cell = cell
        self.rows = rows
        self.sectionLayoutProvider = sectionLayoutProvider
        self.supplementaryView = supplementaryView
    }
    
    
    // MARK: - Properties
    
    public let rows: [CollectionViewRow<Section, Item>]
    
    private let cell: (IndexPath, Item) -> Cell
    private let sectionLayoutProvider: (Int, NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection
    private let supplementaryView: (String, IndexPath) -> SupplementaryView
    
    private let cellIdentifier = "hostCell"
    private let supplementaryViewIdentifier = "hostSupplementaryView"
    
    
    // MARK: - Public Functions
    
    public func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    public func makeUIView(context: Context) -> UICollectionView {
        let collectionView = createCollectionView(for: context)
        let dataSource = createDataSource(for: collectionView)
        context.coordinator.dataSource = dataSource
        setupSupplementaryView(for: context, dataSource: dataSource)
        reloadData(in: collectionView, context: context)
        return collectionView
    }
    
    public func updateUIView(_ uiView: UICollectionView, context: Context) {
        reloadData(in: uiView, context: context, animated: true)
    }
}


// MARK: - Private Functions

private extension CollectionView {
    
    func createCollectionView(for context: Context) -> UICollectionView {
        let layout = createLayout(for: context)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.delegate = context.coordinator
        view.register(HostCell.self, forCellWithReuseIdentifier: cellIdentifier)
        return view
    }
    
    func createDataSource(for collectionView: UICollectionView) -> Coordinator.DataSource {
        Coordinator.DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            let hostCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? HostCell
            hostCell?.hostedCell = cell(indexPath, item)
            return hostCell
        }
    }
    
    func createLayout(for context: Context) -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            context.coordinator.sectionLayoutProvider?(sectionIndex, layoutEnvironment)
        }
    }
    
    func setupSupplementaryView(for context: Context, dataSource: Coordinator.DataSource) {
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            let coordinator = context.coordinator
            if !coordinator.registeredSupplementaryViewKinds.contains(kind) {
                collectionView.register(HostSupplementaryView.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: supplementaryViewIdentifier)
                coordinator.registeredSupplementaryViewKinds.append(kind)
            }
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: supplementaryViewIdentifier, for: indexPath) as? HostSupplementaryView else { return nil }
            view.hostedSupplementaryView = supplementaryView(kind, indexPath)
            return view
        }
    }
    
    func snapshot() -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        for row in rows {
            snapshot.appendSections([row.section])
            snapshot.appendItems(row.items, toSection: row.section)
        }
        return snapshot
    }
    
    func reloadData(in collectionView: UICollectionView, context: Context, animated: Bool = false) {
        let coordinator = context.coordinator
        coordinator.sectionLayoutProvider = sectionLayoutProvider
        guard let dataSource = coordinator.dataSource else { return }
        let rowsHash = rows.hashValue
        if coordinator.rowsHash != rowsHash {
            dataSource.apply(snapshot(), animatingDifferences: animated) {
                coordinator.isFocusable = true
                collectionView.setNeedsFocusUpdate()
                collectionView.updateFocusIfNeeded()
                coordinator.isFocusable = false
            }
            coordinator.rowsHash = rowsHash
        }
    }
}


// MARK: - Coordinator

public extension CollectionView {
    
    class Coordinator: NSObject, UICollectionViewDelegate {
        
        typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
        
        var dataSource: DataSource? = nil
        var sectionLayoutProvider: ((Int, NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection)?
        var rowsHash: Int? = nil
        var registeredSupplementaryViewKinds: [String] = []
        var isFocusable: Bool = false
        
        public func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
            isFocusable
        }
    }
}


// MARK: - HostCell

private extension CollectionView {
    
    class HostCell: UICollectionViewCell, CollectionViewHost {
        
        var hostController: UIHostingController<Cell>?
        
        override func prepareForReuse() {
            handlePrepareForReuse()
        }
        
        var hostedCell: Cell? {
            willSet { handleWillSetHostedView(newValue) }
        }
    }
}


// MARK: - HostSupplementaryView

private extension CollectionView {
    
    class HostSupplementaryView: UICollectionReusableView, CollectionViewHost {
        
        var hostController: UIHostingController<SupplementaryView>?
        
        override func prepareForReuse() {
            handlePrepareForReuse()
        }
        
        var hostedSupplementaryView: SupplementaryView? {
            willSet { handleWillSetHostedView(newValue) }
        }
    }
}


// MARK: - CollectionViewHost

private protocol CollectionViewHost: UIView {
    
    associatedtype HostedView: View
    
    var hostController: UIHostingController<HostedView>? { get set }
}

private extension CollectionViewHost {
    
    func handlePrepareForReuse() {
        hostController?.view?.removeFromSuperview()
        hostController = nil
    }
    
    func handleWillSetHostedView(_ newValue: HostedView?) {
        guard let view = newValue else { return }
        hostController = UIHostingController(rootView: view, ignoreSafeArea: true)
        guard let hostView = hostController?.view else { return }
        hostView.frame = self.bounds
        hostView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(hostView)
    }
}

