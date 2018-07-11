//
//  Database.swift
//  CombatMatrixiOS
//
//  Created by Paul Hebert on 6/29/18.
//  Copyright © 2018 Paul Hebert. All rights reserved.
//

import UIKit
import SQLite3

class Database: NSObject {
    let dbName = "Characters"
    var db: OpaquePointer?
    
    func connect() {
        print(" - Connected to Database - ")
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("CharactersDB.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
        }//end if
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Characters (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, roll INTEGER, attacks INTEGER)", nil, nil, nil) != SQLITE_OK {
            printError(preMsg: "Error creating table")
        }//end if
    }//connect()
    
    func insert(name: String, roll: Int, attack: Int) {
        var stmt: OpaquePointer?

        let queryString = "INSERT INTO Characters (name, roll, attacks) VALUES (?, ?, ?)"
        
        //Prepare the query string
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            printError(preMsg: "Error preparing insert")
        }
        
        //Bind parameters to the query string
        if sqlite3_bind_text(stmt, 1, name, -1, nil) != SQLITE_OK {
            printError(preMsg: "Failure to bind")
            return
        }
        
        if sqlite3_bind_int(stmt, 2, Int32(roll)) != SQLITE_OK {
            printError(preMsg: "Failure to bind")
            return
        }

        if sqlite3_bind_int(stmt, 3, Int32(attack)) != SQLITE_OK {
            printError(preMsg: "Failure to bind")
            return
        }
        
        //Executing the query to insert data
        if sqlite3_step(stmt) != SQLITE_DONE {
            printError(preMsg: "Failure inserting character")
            return
        }
        
        print("Character inserted!")
        
        readValues()
        
    }
    
    func readValues() {
        let sql = "SELECT id, name, roll, attacks FROM Characters"
        
        var stmt: OpaquePointer?
        
        if sqlite3_prepare(db, sql, -1, &stmt, nil) != SQLITE_OK {
            printError(preMsg: "Error preparing insert")
            return
        }
        
        while(sqlite3_step(stmt)==SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let roll = sqlite3_column_int(stmt, 2)
            let attacks = sqlite3_column_int(stmt, 3)
            print("id:\(id) name:\(name) roll:\(roll) attacks: \(attacks) ")
        }
    }
    
    func getAllCharacters() -> [Character] {
        var characters = [Character]()
        let sql = "SELECT id, name, roll, attacks FROM Characters ORDER BY roll DESC"
        
        var stmt: OpaquePointer?
        
        if sqlite3_prepare(db, sql, -1, &stmt, nil) != SQLITE_OK {
            printError(preMsg: "Error preparing insert")
        }
        
        while(sqlite3_step(stmt)==SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let roll = sqlite3_column_int(stmt, 2)
            let attacks = sqlite3_column_int(stmt, 3)
            characters.append(Character.init(id: Int(id), name: name, roll: Int(roll), attacks: Int(attacks)))
        }
        
        return characters
    }
    
    func getCharacterByName(name : String) -> Character{
        let sql = "SELECT id, name, roll, attacks FROM Characters WHERE name = ?"
        var stmt: OpaquePointer?
        var character: Character?
        
        if sqlite3_prepare(db, sql, -1, &stmt, nil) != SQLITE_OK {
            printError(preMsg: "Error preparing getCharacterByName statement")
        }
        
        if sqlite3_bind_text(stmt, 1, name, -1, nil) != SQLITE_OK {
            printError(preMsg: "Failure to bind")
        }
        
        while(sqlite3_step(stmt)==SQLITE_ROW) {
            character = Character.init(id: Int(sqlite3_column_int(stmt, 0)), name: String(cString: sqlite3_column_text(stmt, 1)), roll: Int(sqlite3_column_int(stmt, 2)), attacks: Int(sqlite3_column_int(stmt, 3)))
        }
        
        print("getCharacterByName: \(name)")
        
        return character!
    }
    
    func updateCharacter(character: Character) {
        let sql  = "UPDATE Characters SET name = '\(character.name!)', roll = \(character.roll), attacks = \(character.attacks) WHERE id = \(character.id)"
        print (sql)
        var stmt: OpaquePointer?
        
        if sqlite3_prepare(db, sql, -1, &stmt, nil) != SQLITE_OK {
            printError(preMsg: "Error preparing updateCharacter statement")
        }
        
        /***
        //Bind to update statement
        // Name
        if sqlite3_bind_text(stmt, 1, String(character.name!), -1, nil) != SQLITE_OK {
            printError(preMsg: "Failure to bind \(character.name!)")
        }
        
        //Roll
        if sqlite3_bind_int(stmt, 2, Int32(character.roll)) != SQLITE_OK {
            printError(preMsg: "Failure to bind \(character.roll)")
        }
        
        //Attacks
        if sqlite3_bind_int(stmt, 3, Int32(character.attacks)) != SQLITE_OK {
            printError(preMsg: "Failure to bind \(character.attacks)")
        }
        
        //ID for where clause
        if sqlite3_bind_int(stmt, 4, Int32(character.id)) != SQLITE_OK {
            printError(preMsg: "Failture to bind \(character.id)")
        }
 ***/
        
        //Run update statement
        if sqlite3_step(stmt) == SQLITE_DONE {
            print("Updated") } else {
            printError(preMsg: "Failure updating data")
        }
    }
    
    func clearTable() {
        let sql = "DELETE FROM Characters"
        var stmt: OpaquePointer?
        
        if sqlite3_prepare(db, sql, -1, &stmt, nil) != SQLITE_OK {
            printError(preMsg: "Error preparing insert")
            return
        }
        
        //Executing the query to delete data
        if sqlite3_step(stmt) != SQLITE_DONE {
            printError(preMsg: "Failure deleting data")
            return
        }
    }
    
    func delete(id: Int) -> Bool{
        let sql = "DELETE FROM Characters WHERE id = \(id)"
        print(sql)
        var stmt: OpaquePointer?
        
        if sqlite3_prepare(db, sql, -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("Deleted \(id)")
                return true
                } else {
                printError(preMsg: "Failed to delete \(id)")
                return false
            }
        } else {
            printError(preMsg: "Error preparing delete")
        }
        return false
    }
    
    func printError(preMsg: String) {
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("\(preMsg): \(errmsg)")
    }
    
    func dropTable() {
        let sql = "DROP TABLE IF EXISTS Characters"
        var stmt: OpaquePointer?
        if sqlite3_prepare(db, sql, -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("Table dropped")
            } else {
                printError(preMsg: "Failed to drop table")
            }
        }
    }
}//end class
