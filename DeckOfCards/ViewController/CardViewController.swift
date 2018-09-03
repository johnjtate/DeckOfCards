//
//  CardViewController.swift
//  DeckOfCards
//
//  Created by John Tate on 9/3/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {

    @IBOutlet weak var suitLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var cardImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addVerticalGradientLayer(topColor: .green, bottomColor: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))
    }
    
    @IBAction func drawButtonTapped(_ sender: Any) {
        updateViews()
    }
    
    func updateViews() {
        
        CardController.shared.fetchCard(count: 1) { (cards) in
            guard let card = cards?.first else { return }
            // We want the first card that came back
            DispatchQueue.main.async {
                self.suitLabel.text = card.suit
                self.valueLabel.text = card.value
            }
            
            CardController.shared.fetchCardImage(card: card, completion: { (image) in
                DispatchQueue.main.async {
                    self.cardImageView.image = image
                }
            })
        }
    }
    

}
