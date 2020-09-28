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
