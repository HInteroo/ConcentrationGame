//
//  ViewController.swift
//  Concentration
//
//  Created by Admin on 9/19/18.
//  Copyright © 2018 Max. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    lazy var game = Concentration(numberOfPairsOfCards: (cardBttns.count + 1)/2)
    
    @IBOutlet var cardBttns: [UIButton]!
    @IBOutlet weak var fCountLabel: UILabel!
    @IBOutlet weak var sCountLabel: UILabel!
    @IBAction func NewGameButton(_ sender: UIButton) {
        reset()
    }
    @IBAction func touchCard(_ sender: UIButton) {
        Flips+=1
        if let cardNumber = cardBttns.index(of:sender){
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("Chosen card was not in the collection")
        }
    }
    private var emoji = [Int: String]()
    private var EmojiIndex = 1                                  //Index to use for ThemeEmojis array
    private var Flips = 0{
        didSet{
            fCountLabel.text = "Flips: \(Flips)"
        }
    }
    private var Score = 0{
        didSet{
            sCountLabel.text = "Score: \(Score)"
        }
    }
    private var BackGroundColor = [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),#colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1),#colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1),#colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1),#colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1),#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)]               //BackGround colors of themes
    private var CardsColor = [#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1),#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1),#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1),#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1),#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)]                    //Card's color
    private var emojiChoices = ["👻", "🎃", "😈", "☠️", "🧟‍♂️", "🍎", "🍬", "🍭", "🍫","👹"] //default Emoji choice
    private let ThemeEmojis = [
        ["👻","🎃","😈","☠️","🧟‍♂️","🍎","🍬","🍭","🍫","👹"],
        ["🌑","🌒","🌓","🌔","🌕","🌖","🌗","🌘","🌙","🌚"],
        ["😆","😁","🤣","🙃","😉","😍","😙","😝","🤔","😏"],
        ["🖤","💜","💙","💚","💛","🧡","❤️","💔","💓","💟"],
        ["👌","👊","🤞","🤟","🤘","🤙","👎","👍","👏","💪"],
        ["🐢","🐋","🐬","🐓","🐖","🐄","🐆","🐅","🦓","🦍"]]
    
    
    
    private func reset(){
        Flips = 0                                                           //Flips is set to 0
        game = Concentration(numberOfPairsOfCards: (cardBttns.count + 1)/2) //Making a new deck of cards with (20)
        if (EmojiIndex >= 0),(EmojiIndex < 6){                               //Making Sure EmojiIndex (1) >= 0 and less than 6
            emojiChoices = ThemeEmojis[EmojiIndex]
            self.view.backgroundColor = BackGroundColor[EmojiIndex]          //Setting the background of my UIViewController to the colors
            EmojiIndex+=1                                                    //Depending on the theme
        }
        else if (EmojiIndex == 6){                                           //Making sure the EmojiIndex doesn't goes out of range.
            EmojiIndex = 0                                                   //If EmojiIndex = 6 (out of range) then make it to 0
            emojiChoices = ThemeEmojis[EmojiIndex]                           //EmojiIndex right here = 0 which is the default emojis/theme
            self.view.backgroundColor = BackGroundColor[EmojiIndex]
            EmojiIndex+=1
        }
        for index in cardBttns.indices{
            cardBttns[index].isEnabled = true
        }
        updateViewFromModel()
    }
    
    private func emoji (for card: Card) -> String{
        if emoji[card.identifier] == nil , emojiChoices.count > 0{
            let randomIndex = Int (arc4random_uniform(UInt32(emojiChoices.count)))
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }
    
    private func updateViewFromModel(){
            for index in cardBttns.indices{
                let button = cardBttns[index]
                let card = game.cards[index]
                if card.isFaceUp{
                    button.setTitle(emoji(for:card), for: UIControlState.normal)
                    button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                }
                else {
                    button.setTitle("", for: UIControlState.normal)
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : CardsColor[EmojiIndex-1] //CardsColor is the color of the cards using an array of Color Literal
                    if card.isMatched{           //disables button from being touched flip is counted when cards are matched regardless of invisible.
                        button.isEnabled = false;
                    }
                }
        }
        Score = game.Score                         //The Score of Concentration.swift is needed to change the sCountLabel
    }
}
