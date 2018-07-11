//
//  CharacterTableViewController.swift
//  CombatMatrixiOS
//
//  Created by Paul Hebert on 6/28/18.
//  Copyright © 2018 Paul Hebert. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {
    
    var characters = [Character]()
    var selectedCharName: String = ""
    var selectedChar: Character?
    var db: Database?
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var rollField: UITextField!
    @IBOutlet weak var attacksField: UITextField!
    @IBOutlet weak var commentsField: UITextField!
    @IBOutlet weak var MessageCell: UITableViewCell!
    @IBOutlet weak var turnsField: UITextField!

    var isRollChanged: Bool = false
    var isAttacksChanged: Bool = false
    var isNameChanged: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        db = Database()
        db?.connect()
        selectedChar = db?.getCharacterByName(name: selectedCharName)
        nameField.text = selectedChar!.name
        rollField.text = String(selectedChar!.roll)
        attacksField.text = String(selectedChar!.attacks)

        turnsField.text = turnsToString(TurnsArray: selectedChar!.turns)
        
        //Debugging text
        print("Selected Character Object: ID: \(selectedChar!.id) -  \(selectedChar!.name!))")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func awakeFromNib() {
        
    }
    
    func turnsToString(TurnsArray: [Int]) -> String {
        var string:String = ""
        for turn in TurnsArray {
            string = "\(string) \(turn),"
        }
        return String(string.dropLast(1))
    }

    @IBAction func UpdateDetail(_ sender: UIButton) {
        
        self.MessageCell.isHidden = false
        self.MessageCell.alpha = 0
        
        if isRollChanged || isAttacksChanged || isNameChanged {
            selectedChar!.name = nameField.text
            selectedChar!.roll = Int(rollField.text!)!
            selectedChar!.attacks = Int(attacksField.text!)!
            selectedChar!.calculateTurns()
            turnsField.text = turnsToString(TurnsArray: selectedChar!.turns)
            
            db?.updateCharacter(character: selectedChar!)
            tableView.reloadData()
            
            UIView.animate(withDuration: 0.3, delay: 0.5, animations: {
                self.MessageCell.alpha = 1
            }, completion: nil)
            
            UIView.animate(withDuration: 0.3, delay: 1.5, animations: {
                self.MessageCell.alpha = 0
            }, completion:  { _ in
                self.navigationController?.popViewController(animated: true)
                
            })

        }
    }
    @IBAction func rollChanged(_ sender: UITextField) {
        isRollChanged = true
    }
    @IBAction func attacksChanged(_ sender: Any) {
        isAttacksChanged = true
    }
    
    @IBAction func nameChanged(_ sender: Any) {
        isNameChanged = true
    }
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    @IBAction func UpdateDetail(_ sender: UIButton) {
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 2
    }
    */

    /**
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "Roll: \(String(describing: selectedChar!.roll))"

        } else {
            cell.textLabel?.text = "Attacks: \(selectedChar!.attacks)"
        }

        return cell
    }
    **/

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(selectedCharName)'s Detail"
    }

}
