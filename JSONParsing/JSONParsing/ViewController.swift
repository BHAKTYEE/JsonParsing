//
//  ViewController.swift
//  JSONParsing
//
//  Created by Mac on 07/05/23.
//

import UIKit

class ViewController: UIViewController , UITableViewDataSource{

    @IBOutlet weak var dataTableView: UITableView?
    
    var dataArray :[ [String:Any] ] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataTableView?.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell (style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: nil)
        
        let dictionary : [String:Any] = dataArray[indexPath.row]
        
        let id:Int = dictionary["id"] as! Int
        let title:String = dictionary["title"] as! String
        let userId:Int = dictionary["userId"] as! Int
        let completed:Int = dictionary["completed"] as! Int
        
        
        
        cell.textLabel?.text = "ID - \(id), title - \(title)"
        cell.detailTextLabel!.text = "UserID-\(userId), completed - \(completed)"
        return cell
    }

    @IBAction func downloadAction(_ sender: Any) {
        
        let  strURL = "https://jsonplaceholder.typicode.com/todos"
        let myURL:URL? = URL(string: strURL)
        
        var request : URLRequest = URLRequest (url: myURL!)
        request.httpMethod = "GET"
        
        let session:URLSession = URLSession.shared
        
        let dataTask:URLSessionDataTask = session.dataTask(with: request, completionHandler: downloadHandler(urlData:response:error:))
        dataTask.resume()
    }
    
    func downloadHandler(urlData : Data?, response: URLResponse?, error: Error?) -> Void
    {
        if(urlData != nil && error==nil)
        {
            
            do{
                            // convert json data into swift data type
            
            let swiftData:Any? =  try JSONSerialization.jsonObject(with: urlData!, options:  JSONSerialization.ReadingOptions.mutableLeaves)
                

                
                if(swiftData != nil)
                {
                    dataArray = swiftData as! [ [String:Any] ]
                    print("Downloaded--" , dataArray)

                    DispatchQueue.main.async(execute: {  self.dataTableView?.reloadData()
                        
                    })
                }
                
            }catch{
                
                print("error in JSON Parsing :", error)
            }
    }
}

}
