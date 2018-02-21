//
//  tableTableViewController.swift
//  iQuiz
//
//  Created by Christy Lu on 2/11/18.
//  Copyright © 2018 Christy Lu. All rights reserved.
//

import UIKit

class tableTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var appdata = AppData.shared
    
    //let topic = ["Mathematics", "Marvel Super Heroes", "Science"]
    
    var valueToPass: String!
    //@IBOutlet weak var btnSetting: UIBarButtonItem!
    @IBAction func btnSetting(_ sender: Any) {
        let alertVC = UIAlertController(title: "Settings",
                                        message: "Get quiz data from web",
                                        preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            alertVC.dismiss(animated: true)
        })
        let checkButton = UIAlertAction(title: "Check Now", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            print("you pressed check button")
            if(self.checkInternet()) {
                self.getHttp()
            } else {
                let alertVC = UIAlertController(title: "Network",
                                                message: "Network is not available. Using local storage data",
                                                preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    alertVC.dismiss(animated: true)
                })
                self.present(alertVC, animated: true)

                let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                
                let fileURL = DocumentDirURL.appendingPathComponent("quiz")
                
                do {
                    // Read the file contents
                    let d = try NSArray(contentsOf: fileURL) as! NSArray
                    print(d)
                    self.processData(jsonObj: d)
                } catch let error as NSError {
                    print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
                }
            
            }
            
            
            // call method whatever u need
        })
        alertVC.addAction(checkButton)
        self.present(alertVC, animated: true)

    }
    
    func checkInternet() -> Bool {
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            return true
        }
        print("Internet Connection not Available!")
        return false
        
    }
    
    func getHttp() {
        let url = URL(string: "https://tednewardsandbox.site44.com/questions.json")
        let urlSession = URLSession(configuration: .default)
        
        let task = urlSession.dataTask(with: url!) {(data, response, error) in
            //print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue))
            do {
                if let jsonObj = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSArray {
                    //print(jsonObj)
                    //print(jsonObj[0])
                    if jsonObj.write(toFile: NSHomeDirectory() + "/Documents/quiz", atomically: true) {
                        NSLog(NSHomeDirectory())
                        NSLog("Quiz written")
                    } else {
                        NSLog("Quiz write failed")
                    }

                    self.processData(jsonObj: jsonObj)
                    
                    DispatchQueue.main.async{
                        self.tableView.reloadData()
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
                let alertVC = UIAlertController(title: "Download",
                                                message: "Download Failed",
                                                preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    alertVC.dismiss(animated: true)
                })
                self.present(alertVC, animated: true)
                
            }
        }
        task.resume()
    }
    
    func processData(jsonObj : NSArray) {
        for topic in jsonObj {
            let topicDict = topic as? NSDictionary
            //print(topicDict!["title"] as! NSString)
            self.appdata.categories.append(topicDict!["title"] as! String)
            self.appdata.descriptions.append(topicDict!["desc"] as! String)
            //print(self.appdata.categories)
            let topicQs = topicDict!["questions"] as? NSArray
            var temp = [String]()
            for question in topicQs! {
                
                let questionDict = question as? NSDictionary
                temp.append(questionDict!["text"] as! String)
                self.appdata.potentialAns[questionDict!["text"] as! String] = (questionDict!["answers"] as! [String])
                let ind = Int(questionDict!["answer"] as! String)
                self.appdata.correctAns[questionDict!["text"] as! String] = self.appdata.potentialAns[questionDict!["text"] as! String]?[ind!]
            }
            self.appdata.questions[topicDict!["title"] as! String] = temp
        }
    }
    
    
    override func viewDidLoad() {

        OperationQueue.main.addOperation({
            //calling another function after fetching the json
            //it will show the names to label
            self.after()
        })


        // Do any additional setup after loading the view.
    }
    
    func after() {
        //appdata.categories.append("haha")
        super.viewDidLoad()
        print(appdata.categories)
        tableView.dataSource = self
        tableView.delegate = self
        print(appdata.bingo)
        appdata.bingo = 0
        appdata.currentQIndex = 0
        //print(DocumentDirURL.appendingPathComponent("quiz"))
        //print(NSHomeDirectory())
        
        
        // testing DELETE IT LATER

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appdata.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! TableViewCell
        let topic = appdata.categories[indexPath.row]
        let descr = appdata.descriptions[indexPath.row]
        cell.title.text = topic
        cell.descr.text = descr
        cell.img.image = UIImage(named: topic)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topic = appdata.categories[indexPath.row]
        NSLog("User selected row at \(topic)")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        /*let talkView = segue.destination as! ViewController
        talkView.history = history*/
        let selectedRow = tableView.indexPathForSelectedRow!.row
        appdata.currentTopic = appdata.categories[selectedRow]
        
        if (segue.identifier == "qseg") {
            let viewController = segue.destination as! questionTableViewController

            viewController.stringPassed = appdata.categories[selectedRow]
            viewController.questionIndex = 0
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
