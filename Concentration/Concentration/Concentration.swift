//
//  Concentration.swift
//  Concentration
//
//  Created by Admin on 9/19/18.
//  Copyright © 2018 Max. All rights reserved.
//

import Foundation

class Concentration{
    var cards = [Card]()
    var Score = 0;
    private var indexOfOneAndOnlyFaceUpCard: Int?
    private var CardsPickedOn:[Int]=[]
    
    func chooseCard( at index:Int){
        if !cards[index].isMatched{
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index{
                //Check if cards match
                if cards[matchIndex].identifier == cards[index].identifier{
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    Score+=2
                }
                if CardsPickedOn.contains(index) && !cards[index].isMatched{
                    Score-=1
                }
                CardsPickedOn.append(matchIndex)
                CardsPickedOn.append(index)
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = nil
            }else{
                //either or no cards or 2 cards are faced up
                for flipDownIndex in cards.indices{
                    cards [flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    init(numberOfPairsOfCards:Int){
        for _ in 1...numberOfPairsOfCards{
            let card = Card()
            cards += [card,card]
        }
        //shuffling the cards:
        var last = cards.count-1
        for _ in 1...cards.count{
            let randomIndex = Int (arc4random_uniform(UInt32(last)))
            cards.swapAt(last, randomIndex)
            last-=1
        } // for example: 1,2,3,4,5 -> 1,2,5,4 -> 1,4,5 -> 5,4 -> 4 -> loops goes from 1 to 10 (10xs, 10 pairs)
    }
}
