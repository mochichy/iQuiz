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
            self.getHttp()
            
            // call method whatever u need
        })
        alertVC.addAction(checkButton)
        self.present(alertVC, animated: true)

    }
    
    func getHttp() {
        let url = URL(string: "https://tednewardsandbox.site44.com/qu")
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
    
    
    override func viewDidLoad() {
        //appdata.makeHTTPGetRequest()
        /*let url = URL(string: "https://tednewardsandbox.site44.com/questions.json")
        let urlSession = URLSession(configuration: .default)
        let task = urlSession.dataTask(with: url!) {(data, response, error) in
            //print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue))
            do {
                if let jsonObj = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSArray {
                    //print(jsonObj)
                    //print(jsonObj[0])
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
                    
                    DispatchQueue.main.async{
                        self.tableView.reloadData()
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        task.resume()*/

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
        //let myVC = storyboard?.instantiateViewController(withIdentifier: "questionVC") as! questionTableViewController
        
       /* let myVC = questionTableViewController()
        print(myVC)
        myVC.stringPassed = "?"
        navigationController?.pushViewController(myVC, animated: true)
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = Storyboard.instantiateViewController(withIdentifier: "questionVC") as! questionTableViewController
        let destinationVC = questionTableViewController()
        destinationVC.stringPassed = "?"
        self.performSegue(withIdentifier: "qseg", sender: self)
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        
        valueToPass = currentCell.textLabel?.text
        performSegue(withIdentifier: "qseg", sender: self)*/
        
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
