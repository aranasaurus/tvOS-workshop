//
//  ViewController.swift
//  RoShamBo
//
//  Created by Ryan Arana on 10/6/15.
//  Copyright © 2015 PDX-iOS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var selectedButton: UIButton? {
        didSet {
            oldValue?.highlighted = false
            selectedButton?.highlighted = true
        }
    }

    @IBOutlet weak var inputsView: UIView!

    @IBOutlet weak var resultsView: UIView!
    @IBOutlet weak var winnerImage: UIImageView!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var loserImage: UIImageView!
    @IBOutlet weak var loserOverlay: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        resultsView.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonClicked(sender: UIButton) {
        selectedButton = sender

        let playerChoice = Choice(rawValue: sender.tag)!
        let result = Game.play(playerChoice)
        resultsView.hidden = false

        if playerChoice == result.winner {
            winnerImage.image = UIImage(named: "\(result.winner.name)-highlighted")
        } else {
            winnerImage.image = UIImage(named: result.winner.name)
        }

        if playerChoice == result.loser {
            loserImage.image = UIImage(named: "\(result.loser.name)-highlighted")
        } else {
            loserImage.image = UIImage(named: result.loser.name)
        }

        actionLabel.text = result.summary

        UIView.animateWithDuration(0.3, animations: { self.winnerImage.center.y += 100 }) { _ in
            UIView.animateWithDuration(0.3) { self.winnerImage.center.y -= 100 }

            switch Verb(result) {
            case .crushes:
                // TODO: Use transforms instead, this doesn't look quite the way I'd like it to yet.
                UIView.animateWithDuration(0.6, delay: 0, options: [.CurveEaseIn], animations: {
                    self.loserImage.bounds.size.height = 10
                    self.loserImage.center.y += self.winnerImage.bounds.height / 2.0
                    }, completion: nil)
                UIView.animateWithDuration(0.3, delay: 1.5, options: [], animations: {
                    self.loserImage.bounds.size.height = self.winnerImage.bounds.size.height
                    self.loserImage.center.y -= self.winnerImage.bounds.height / 2.0
                    self.loserImage.contentMode = .ScaleAspectFit
                    }, completion: nil)
            default:
                UIView.animateWithDuration(0.15, animations: { self.loserImage.center.x += 50 }) { _ in
                    UIView.animateWithDuration(0.15, animations: { self.loserImage.center.x -= 100 }) { _ in
                        UIView.animateWithDuration(0.15, animations: { self.loserImage.center.x += 100 }) { _ in
                            UIView.animateWithDuration(0.15) { self.loserImage.center.x -= 50 }
                        }
                    }
                }
            }
        }
    }
}

