//
//  CombatViewController.swift
//  CombatMatrixiOS
//
//  Created by Paul Hebert on 7/3/18.
//  Copyright © 2018 Paul Hebert. All rights reserved.
//

import UIKit

class CombatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var db: Database = Database()
    var characterList: [Character] = []
    var turnList: [Int: [Character]] = [Int: [Character]]()
    var sortedTurnList: [(key: Int, value:[Character])] = []
    var currentTurn: Int = 30
    var currentTurnIndex: Int = 0

    @IBOutlet weak var turnTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db.connect()
        characterList = db.getAllCharacters()
        
        print("********** Begin Combat! *********")
        
        for character in characterList {
            character.remainingTurns = character.attacks + 1
            for turn in character.turns {
                if turnList[turn] != nil {
                    turnList[turn]!.append(character)
                } else {
                    let cList: [Character] = [character]
                    turnList[turn] = cList
                }
            }
            
        }
        
        //test turnlist
        print("turnList size: \(turnList.count)")
        sortedTurnList = turnList.sorted(by: {$0.key > $1.key})
        reduceTurns()
        
        print("******** Sorted Turn List ********")
        for turn in sortedTurnList {
            print("\(turn.key)")
            for char in turn.value{
                print("\(char.name!)")
            }
        }
        
        for (turn, charList) in turnList {
            print("  \(turn) - \(charList.count)")
            for char in charList {
                print("\(char.name!)")
            }
        }
        
        turnTitle.text = "Turn \(sortedTurnList.first!.key)"
        currentTurn = sortedTurnList.first!.key
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    /***
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharName", for: indexPath)
        //cell.textLabel?.text = charList[indexPath.row].name
        let character = sortedTurnList[currentTurnIndex].value[indexPath.row]
        let charString = "\(character.name!) - (\(character.attacks)/\(character.remainingTurns))"
        //cell.textLabel?.text = character.name
        cell.textLabel?.text = charString
        //let textLabel = UILabel(frame: CGRect(x: 5 ,y: 0 ,width: 98, height: 44))
        //textLabel.text = String(character.attacks)
        //cell.viewWithTag(1)!.addSubview(textLabel)
        //cell.addSubview(textLabel)
        return cell
    }**/
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharName", for: indexPath) as! CombatViewCell
        
        let character = sortedTurnList[currentTurnIndex].value[indexPath.row]
        
        cell.name.text = character.name!
        cell.totalAttacks.text = String(character.attacks)
        cell.remainingAttacks.text = String(character.remainingTurns)

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //print("Count of 'first' key from sortedTurnList: \(sortedTurnList.first!.value.count)")
        //print("0 key is \(sortedTurnList[0].key) - Value is: \(sortedTurnList[0].value[0].name!)")
        //return sortedTurnList[currentTurn].value.count
        return (sortedTurnList[currentTurnIndex].value.count)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Characters this turn"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexPath: \(indexPath.row)")
        let selectedName = sortedTurnList[currentTurnIndex].value[indexPath.row].name
        print("Selected Name: \(selectedName!)")
        
        let selectedChar = sortedTurnList[currentTurnIndex].value[indexPath.row]
        selectedChar.remainingTurns = selectedChar.remainingTurns - 1
        if selectedChar.remainingTurns < 0 {
            selectedChar.remainingTurns = selectedChar.attacks
        }
        tableView.reloadData()
    }
    
    func reduceTurns() {
        for character in sortedTurnList[currentTurnIndex].value {
            if character.remainingTurns > 0 {
                character.remainingTurns = character.remainingTurns - 1
                print("Reducing remaining turns: \(character.remainingTurns)")
            }
        }
    }
    
    func increaseTurns() {
        for character in sortedTurnList[currentTurnIndex].value {
            character.remainingTurns = character.remainingTurns + 1
        }
    }
    
    @IBAction func nextTurn(_ sender: Any) {
        if currentTurnIndex + 1 <= (sortedTurnList.count - 1) {
            currentTurnIndex = currentTurnIndex + 1
            reduceTurns()
            turnTitle.text = "Turn \(sortedTurnList[currentTurnIndex].key)"
            currentTurn = sortedTurnList[currentTurnIndex].key
            tableView.reloadData()
        }
    }
    
    @IBAction func prevTurn(_ sender: UIButton) {
        if currentTurnIndex  - 1 >= 0 {
            increaseTurns()
            currentTurnIndex = currentTurnIndex - 1
            turnTitle.text = "Turn \(sortedTurnList[currentTurnIndex].key)"
            currentTurn = sortedTurnList[currentTurnIndex].key
            tableView.reloadData()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
