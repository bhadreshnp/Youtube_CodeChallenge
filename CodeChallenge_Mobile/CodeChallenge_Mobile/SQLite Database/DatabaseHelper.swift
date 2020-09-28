//
//  DatabaseHelper.swift
//  CodeChallenge_Mobile
//
//  Created by Bhadresh Radadiya on 2020-09-27.
//  Copyright © 2020 abc. All rights reserved.
//

import Foundation
import SQLite3

class DatabaseHelper {
    
    let dbPath: String = "YoutubeDatabase.db"
    var db: OpaquePointer?
    
    init() {
        db = openDatabase()
        createTable()
    }
    
    func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
            return nil
        } else {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS Playlist(id INTEGER PRIMARY KEY, playlistId TEXT, videoId TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Playlist table created.")
            } else {
                print("Playlist table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
}

extension DatabaseHelper {
    
    func insert(playlistId: String, videoId: String) {
        let insertStatementString = "INSERT INTO Playlist(playlistId, videoId) VALUES (?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (playlistId as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (videoId as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
//    func read() -> [Playlist] {
//        let queryStatementString = "SELECT * FROM Playlist;"
//        var queryStatement: OpaquePointer? = nil
//        var psns : [Playlist] = []
//        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
//            while sqlite3_step(queryStatement) == SQLITE_ROW {
//                let id = sqlite3_column_int(queryStatement, 0)
//                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
//                let year = sqlite3_column_int(queryStatement, 2)
//                psns.append(Playlist(id: Int(id), name: name, age: Int(year)))
//                print("Query Result:")
//                print("\(id) | \(name) | \(year)")
//            }
//        } else {
//            print("SELECT statement could not be prepared")
//        }
//        sqlite3_finalize(queryStatement)
//        return psns
//    }
}
