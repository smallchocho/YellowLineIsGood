//
//  SearchTableController.swift
//  YellowLineIsGood
//
//  Created by Justin Huang on 2017/3/13.
//  Copyright © 2017年 Justin Huang. All rights reserved.
//

import UIKit

class SearchResultTableController: UIViewController{
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBAction func cacelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    var searchResult:[String] = ["2","1","3","4"]
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
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
        
    }
}
// MARK:UITableView
extension SearchResultTableController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResult.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell")!
        cell.textLabel?.text = self.searchResult[indexPath.row]
        return cell
    }
}
