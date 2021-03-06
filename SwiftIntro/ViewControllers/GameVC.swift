//
//  GameVC.swift
//  SwiftIntro
//
//  Created by Alexander Georgii-Hemming Cyon on 01/06/16.
//  Copyright © 2016 SwiftIntro. All rights reserved.
//

import UIKit

private let gameOverSeque = "gameOverSeque"
class GameVC: UIViewController, Configurable {

    //MARK: Variables
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var labelsView: UIView!
    var config: GameConfiguration!
    var cards: Cards!
    private var result: GameResult!
    var imagePrefetcher: ImagePrefetcherProtocol!
    
    private lazy var dataSourceAndDelegate: MemoryDataSourceAndDelegate = {
        let dataSourceAndDelegate = MemoryDataSourceAndDelegate(
            self.cards,
            level: self.config.level,
            delegate: self,
            imagePrefetcher: self.imagePrefetcher
            )
        return dataSourceAndDelegate
    }()

    //MARK: Instantiation
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    //MARK: VC Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        guard var configurable = segue?.destinationViewController as? Configurable else { return }
        configurable.config = config
        guard let vc = segue?.destinationViewController as? GameOverVC else { return }
        vc.result = result
    }
}

//MARK: GameDelegate
extension GameVC: GameDelegate {
    
    func foundMatch(matches: Int) {
        setScoreLabel(matches)
    }

    func gameOver(result: GameResult) {
        self.result = result
        self.result.cards = cards
        collectionView.userInteractionEnabled = false
        delay(1) {
            self.performSegueWithIdentifier(gameOverSeque, sender: self)
        }
    }
    
    private func setScoreLabel(matches: Int) {
        let unformatted = localizedString("PairsFoundUnformatted")
        let formatted = NSString(format: unformatted, matches, config.level.cardCount/2)
        scoreLabel.text = formatted as String
    }
}

//MARK: Private Methods
private extension GameVC {
    private func setupStyling() {
        setScoreLabel(0)
        labelsView.backgroundColor = .blackColor()
        collectionView.backgroundColor = .blackColor()
    }

    private func setupViews() {
        collectionView.dataSource = dataSourceAndDelegate
        collectionView.delegate = dataSourceAndDelegate
        collectionView.registerNib(CardCVCell.nib, forCellWithReuseIdentifier: CardCVCell.cellIdentifier)
        setupStyling()
    }
}