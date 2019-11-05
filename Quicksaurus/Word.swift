//
//  Word.swift
//  Quicksaurus
//
//  Created by Nguyen Do on 7/30/17.
//  Copyright © 2017 Nguyen Do. All rights reserved.
//

import Foundation

class Word {

    // object variables
    private var word: String?
    private var wordTypes: [String]?
    private var synonyms: [[String]]?
    
    // init functions setting variables
    init(word: String, wordTypes: [String], synonyms: [[String]]) {
        self.word = word
        self.wordTypes = wordTypes
        self.synonyms = synonyms
    }
    
    init() {
        self.word = ""
        self.wordTypes = [""]
        self.synonyms = [[""]]
    }
    
    // getters for counts
    public func getSectionCount() -> Int {
        return wordTypes?.count ?? 0
    }
    
    public func getWordCount(section: Int) -> Int {
        return synonyms?[section].count ?? 0
    }
    
    // getters and setters for variables
    public func getWord() -> String {
        return word ?? ""
    }
    
    public func setWord(word: String) {
        self.word = word
    }
    
    public func getWordTypes() -> [String] {
        return wordTypes ?? [""]
    }
    
    public func setWordTypes(wordTypes: [String]) {
        self.wordTypes = wordTypes
    }
    
    public func getSynonyms() -> [[String]] {
        return synonyms ?? [[""]]
    }
    
    public func setSynonyms(synonyms: [[String]]) {
        self.synonyms = synonyms
    }

}
