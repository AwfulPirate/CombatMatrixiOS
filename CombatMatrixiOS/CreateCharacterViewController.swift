//
//  CreateCharacterViewController.swift
//  CombatMatrixiOS
//
//  Created by Paul Hebert on 6/29/18.
//  Copyright © 2018 Paul Hebert. All rights reserved.
//

import UIKit

class CreateCharacterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var CharacterField: UITextField!
    @IBOutlet weak var RollField: UITextField!
    @IBOutlet weak var AttacksField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var formFields = [UITextField]()
    var db: Database?
    var charList: [Character] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formFields = [CharacterField, RollField, AttacksField]
        
        db = Database()
        db?.connect()
        charList = db!.getAllCharacters()
        //db?.readValues()
        
        tableView.dataSource = self
        tableView.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CreateCharacter(_ sender: UIButton) {
        checkFields()
    }
    
    func isError(fieldName: UITextField) -> Bool {
        if trimField(fieldName).isEmpty  {
            fieldName.layer.borderColor = UIColor.red.cgColor
            fieldName.layer.borderWidth = 1.0
            return true
        } else {
            fieldName.layer.borderWidth = 0
            return false
        }
    }
    
    func trimField(_ field: UITextField) -> String {
        return field.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func checkFields(){
        var isFormValid: Bool = false
        for field in formFields {
            if isError(fieldName: field) {
                isFormValid = false
            } else {
                isFormValid = true
            }
        }
        
        if isFormValid {
            //db?.clearTable()
            db?.insert(name: trimField(CharacterField), roll: Int(trimField(RollField))!, attack: Int(trimField(AttacksField))!)
            charList = db!.getAllCharacters()
            tableView.reloadData()
        }
    }//checkFields()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CharacterList" {
            let destination = segue.destination as! CharacterTableViewController
            destination.characters = (db?.getAllCharacters())!
        } else if segue.identifier == "Detail" {
            let tableViewCell = sender as! UITableViewCell
            let destination = segue.destination as! DetailTableViewController
            let selectedChar = tableViewCell.textLabel?.text
            destination.selectedCharName = selectedChar!
        } else if segue.identifier == "BeginCombat" {
            //let destination = segue.destination as! CombatViewController
            // destination.characterList = charList
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if charList.count == 0 {
            return false
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharName", for: indexPath)
        cell.textLabel?.text = charList[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charList.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if (db?.delete(id: charList[indexPath.row].id))! {
            self.charList.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Current Characters"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        charList = db!.getAllCharacters()
        tableView.reloadData()
    }

}
