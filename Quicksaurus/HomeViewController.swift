//
//  HomeViewController.swift
//  Quicksaurus
//
//  Created by Nguyen Do on 7/30/17.
//  Copyright © 2017 Nguyen Do. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var searchTextField: UITextField! // text field, enter word to find synonyms
    @IBOutlet var searchButton: UIButton! // search button, press to move views to top, display list of synonyms
    @IBOutlet var searchStackView: UIStackView! // search stackview containing button and text field
    @IBOutlet var searchStackVerticalConstraint: NSLayoutConstraint! // vertical constraint temporarily keeping stackview centered
    @IBOutlet var titleLabel: UILabel! // title label, used to flag intended location for stackview, dissapears after search
    @IBOutlet var tableView: UITableView!
    @IBOutlet var activityIndicator: NVActivityIndicatorView!
    @IBOutlet var noResultsLabel: UILabel!
    
    // model variables
    private var word = Word()
    private var firstSearch = true
    
    // text field search button pressed
    @IBAction func textFieldSearchPressed(_ sender: UITextField) {
        search()
        tableView.reloadData()
        showList()
    }
    
    // search button pressed
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        search()
        tableView.reloadData()
        //showList()
    }
    
    // move stackview to top, fade out title, display list
    private func search() {
        
        
        if firstSearch {
            searchStackVerticalConstraint.constant = (searchStackView.center.y - titleLabel.center.y) * -1
            firstSearch = false
        }
        
        print(searchStackVerticalConstraint.constant)
        if let wordString = searchTextField.text {
            
            let trimmedWordString = wordString.trimmingCharacters(in: .whitespacesAndNewlines)
            
            UIView.animate(withDuration: 0.55, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
                self.tableView.alpha = 0
                self.activityIndicator.startAnimating()
                self.titleLabel.alpha = 0
                self.searchStackView.center.y = self.titleLabel.center.y
            }) { (true) in
                self.getData(wordString: trimmedWordString)
                self.tableView.reloadData()
            }
        }
        
        
    }
    
    // get data from GET request
    private func getData(wordString: String) {
        //word = Word(word: "The Word", wordTypes: ["adj", "noun", "verb"], synonyms: [["adj", "adj"], ["noun", "noun"], ["verb", "verb"]])
        
        //word = Word(word: "", wordTypes: [], synonyms: [[]])
        
        let apiKey = "2469cf3d9f267d07063b9b8c5482cd04"
        let urlString = URL(string: "http://words.bighugelabs.com/api/2/\(apiKey)/\(wordString)/json")
        
        
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error)
                } else {
                    
                    /*DispatchQueue.global(qos: .default).async {*/
                        if let usableData = data {
                            if let json = try? JSONSerialization.jsonObject(with: usableData, options: []) {
                                print(json)
                                if let jsonDict = json as? [String: Any] {
                                    
                                    var localWordTypes: [String]!
                                    var localSynonyms: [[String]]!
                                    for(key, value) in jsonDict {
                                        if let wordTypeDict = value as? [String: Any] {
                                            for(lKey, lValue) in wordTypeDict {
                                                if lKey == "syn" {
                                                    if localSynonyms != nil {
                                                        localSynonyms!.append(wordTypeDict["syn"] as! [String])
                                                        localWordTypes.append(key)
                                                    } else {
                                                        localSynonyms = [wordTypeDict["syn"] as! [String]]
                                                        localWordTypes = [key]
                                                    }
                                                    // return                                               CHANGED
                                                }
                                            }
                                        }
                                    }
                                    
                                    if let wordTypes = localWordTypes {
                                        self.word = Word(word: wordString, wordTypes: wordTypes, synonyms: localSynonyms)
                                    }
                                    
                                } else {
                                    
                                }
                                print("done")
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    self.showList()
                                    //self.activityIndicator.stopAnimating()
                                }
                                
                            } else {
                                DispatchQueue.main.async {
                                    self.word = Word()
                                    self.tableView.reloadData()
                                    self.showList()
                                }
                    
                            }
                        }
                    /*}*/
                    
                }
            })
            task.resume()
        }
    }
    
    private func showList() {
        /*
        UIView.animate(withDuration: 0.5) {
            self.tableView.alpha = 1.0
        }*/
        
        
        UIView.animate(withDuration: 0.5, animations: {
            self.tableView.alpha = 1.0
        }) { (true) in
            self.activityIndicator.stopAnimating()
            if self.word.getWordTypes()[0] == "" {
                self.noResultsLabel.alpha = 1.0
            } else {
                self.noResultsLabel.alpha = 0.0
            }
        }
        
    }
    
    // tableview fucntions
    func numberOfSections(in tableView: UITableView) -> Int {
        return word.getSectionCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return word.getWordCount(section: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderTableViewCell
        cell.headerLabel.text = word.getWordTypes()[section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return word.getWordTypes()[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wordCell", for: indexPath) as! WordTableViewCell
        cell.wordLabel.text = word.getSynonyms()[indexPath.section][indexPath.item]
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        // start with invisble views, bring to front so that flagview doesn't cover
        searchStackView.alpha = 0
        titleLabel.alpha = 0
        tableView.alpha = 0
        self.view.bringSubview(toFront: searchStackView)
        self.view.bringSubview(toFront: noResultsLabel)
        tableView.keyboardDismissMode = .onDrag
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // views fade in
        UIView.animate(withDuration: 0.7) {
            self.titleLabel.alpha = 1.0
            self.searchStackView.alpha = 1.0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
