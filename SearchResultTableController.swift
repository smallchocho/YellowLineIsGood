//
//  SearchTableController.swift
//  YellowLineIsGood
//
//  Created by Justin Huang on 2017/3/13.
//  Copyright © 2017年 Justin Huang. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

class SearchResultTableController: UIViewController,PassValue{
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBAction func cacelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    var searchResults:[String:[[String:Any]]] = [
        "result":[
            [
                "name":"",
                "address":"",
                "latitude":0.0,
                "longitude":0.0
            ]
        ]
    ]
    var tapResult:[String:Any] =
        [
        "name":"",
        "address":"",
        "latitude":0.0,
        "longitude":0.0
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor(colorLiteralRed: 243/255, green: 178/255, blue: 3/255, alpha: 1.0).cgColor
        resultTableView.delegate = self
        resultTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
// MARK:UISerchBar
extension SearchResultTableController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            searchResults = ["result":[[:]]]
            self.resultTableView.reloadData()
            return
        }
        GooglePlaceApi.getSearchResult(name:searchText,keyWord:"") { (result) in
            self.searchResults = result
            self.resultTableView.reloadData()
        }
    }
}
// MARK:UITableView
extension SearchResultTableController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults["result"]!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell")!
        cell.textLabel?.text = self.searchResults["result"]?[indexPath.row]["name"] as? String
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let result = self.searchResults["result"]?[indexPath.row] else{
            print("self.searchResults[\"result\"]?[indexPath.row] is nil")
            return
        }
        tapResult = result
        dismiss(animated: true, completion: nil)
    }
}
protocol PassValue {
    var tapResult:[String:Any]{get set}
}
