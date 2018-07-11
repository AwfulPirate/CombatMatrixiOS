//
//  Character.swift
//  CombatMatrixiOS
//
//  Created by Paul Hebert on 6/29/18.
//  Copyright © 2018 Paul Hebert. All rights reserved.
//

class Character {
    var id: Int
    var name: String?
    var roll: Int
    var attacks: Int
    var turns: [Int] = []
    var remainingTurns: Int = 0
    
    init(id: Int, name: String, roll: Int, attacks: Int) {
        self.id = id
        self.name = name
        self.roll = roll
        self.attacks = attacks
        
        self.calculateTurns()
    }
    
    func calculateTurns() {
        turns = []
        var roll = self.roll
        if roll > 0 && attacks > 0 {
            if roll < attacks {
                roll = attacks
            }
            var deviation = (roll + attacks - 1) / attacks
            print("   Attack deviation: \(deviation)")

            turns.append(roll)
            var i = 1
            var nextAttack = roll - deviation
            while(i <= attacks - 1 && i > 0) {
                turns.append(nextAttack)
                let remainingAtt = attacks - i
                if remainingAtt > nextAttack - 1 {
                    deviation = (nextAttack + remainingAtt - 1) / remainingAtt
                }
                
                if (nextAttack <= deviation) {
                    nextAttack = nextAttack - 1
                } else {
                    nextAttack = nextAttack - deviation
                }
                i += 1;
            }//end while
            print("Calculated turns for \(self.name!)")
            for turn in turns {
                print("   \(turn)", terminator: " ")
            }//end for
            print("")
        }//if roll && attacks
    }
}
