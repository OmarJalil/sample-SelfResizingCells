//
//  ViewController.swift
//  SelfResizingCells
//
//  Created by Jalil Fierro on 10/06/22.
//

import UIKit

class ViewController: UIViewController {

    var collectionView : UICollectionView!

    private lazy var dataSource = makeDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()

        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        view.addSubview(collectionView)

        collectionView.delegate = self
        collectionView.dataSource = dataSource

        //2
        setData(animated: true)
    }

    
}

// MARK: - CollectionView Delegate
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {

        guard let movie = dataSource.itemIdentifier(for: indexPath) else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }

        movie.showDetails.toggle()
        var currentSnapshot = dataSource.snapshot()

        currentSnapshot.reconfigureItems([movie])
        dataSource.apply(currentSnapshot)

        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - Private Functions
private extension ViewController {

    func setData(animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Movies>()
        snapshot.appendSections(Section.allCases)

        snapshot.appendItems([Movies(name: "Wonder Woman", body: "Wonder Woman is published by DC Comics. The character is a founding member of the Justice League. The character first appeared in All Star Comics #8 published October 21, 1941 with her first feature in Sensation Comics #1 in January 1942. The Wonder Woman title has been published by DC Comics almost continuously ever since. In her homeland, the island nation of Themyscira, her official title is Princess Diana of Themyscira. When blending into the society outside of her homeland, she sometimes adopts her civilian identity Diana Prince.")], toSection: .one)
        snapshot.appendItems([Movies(name: "Doctor Strange", body: "Doctor Stephen Strange is a fictional character appearing in American comic books published by Marvel Comics. Created by Steve Ditko with Stan Lee, the character first appeared in Strange Tales #110 (cover-dated July 1963). Doctor Strange serves as the Sorcerer Supreme, the primary protector of Earth against magical and mystical threats. Strange was created during the Silver Age of Comic Books to bring a different kind of character and themes of mysticism to Marvel Comics.")], toSection: .one)
        snapshot.appendItems([Movies(name: "The Batman", body: "The character of Batman made his first appearance in the pages of Detective Comics #27 in May 1939. In the spring of 1940, Batman #1 was published and introduced new characters into Batman's pantheon, most notably those of Catwoman and Batman's eventual nemesis, the Joker. Alfred Pennyworth, the Wayne family butler, was introduced in issue #16 (April–May 1943).")], toSection: .one)

        snapshot.appendItems([Movies(name: "Iron Man")], toSection: .two)

        dataSource.apply(snapshot, animatingDifferences: animated)
    }

    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Movies> {

        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Movies> { cell, indexPath, movie in

            var content = cell.defaultContentConfiguration()

            if movie.showDetails {
                content.text = movie.name
                content.secondaryText = movie.body
            } else {
                content.text = movie.name
            }
            cell.contentConfiguration = content
        }

        return UICollectionViewDiffableDataSource<Section, Movies>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                collectionView.dequeueConfiguredReusableCell(
                    using: cellRegistration,
                    for: indexPath,
                    item: item
                )
            }
        )
    }
}
