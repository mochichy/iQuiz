//
//  tableTableViewController.swift
//  iQuiz
//
//  Created by Christy Lu on 2/11/18.
//  Copyright © 2018 Christy Lu. All rights reserved.
//

import UIKit

class tableTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var appdata = AppData.shared
    let refreshControl = UIRefreshControl()
    var valueToPass: String!
    @IBAction func btnSetting(_ sender: Any) {
        let alertVC = UIAlertController(title: "Settings",
                                        message: "Get quiz data from ",
                                        preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Back", style: .default) { _ in
            alertVC.dismiss(animated: true)
        })
        let checkButton = UIAlertAction(title: "Check Now", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.resetAppData()
            let url = alertVC.textFields![0]
            self.appdata.url = url.text!
            
            if(self.checkInternet()) {
                self.getHttp(Url: url.text!)
            } else {
                self.offline()
                let alertVC = UIAlertController(title: "Network",
                                                message: "Network is not available. Using local storage data",
                                                preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    alertVC.dismiss(animated: true)
                })
                self.present(alertVC, animated: true)
            }
            
        })
        alertVC.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Type in url"
            textField.clearButtonMode = .whileEditing
        }
        alertVC.addAction(checkButton)
        self.present(alertVC, animated: true)
    }
    

    @IBAction func btnScores(_ sender: Any) {
        performSegue(withIdentifier: "popover", sender: nil)
        /*let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "scoreVC") as! ScoreViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)*/
    }
    
    func offline() {

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
    
    func checkInternet() -> Bool {
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            return true
        }
        print("Internet Connection not Available!")
        return false
        
    }
    
    func getHttp(Url: String) {
        resetAppData()
        let url = URL(string: Url)
        let urlSession = URLSession(configuration: .default)
        
        let task = urlSession.dataTask(with: url!) {(data, response, error) in
            do {
                if let jsonObj = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSArray {

                    if jsonObj.write(toFile: NSHomeDirectory() + "/Documents/quiz", atomically: true) {
                        NSLog(NSHomeDirectory())
                        NSLog("Quiz written")
                    } else {
                        NSLog("Quiz write failed")
                    }

                    self.processData(jsonObj: jsonObj)
                    
                    /*DispatchQueue.main.async{
                        self.tableView.reloadData()
                    }*/
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
            self.appdata.categories.append(topicDict!["title"] as! String)
            self.appdata.descriptions.append(topicDict!["desc"] as! String)
            let topicQs = topicDict!["questions"] as? NSArray
            var temp = [String]()
            for question in topicQs! {
                
                let questionDict = question as? NSDictionary
                temp.append(questionDict!["text"] as! String)
                self.appdata.potentialAns[questionDict!["text"] as! String] = (questionDict!["answers"] as! [String])
                let ind = Int(questionDict!["answer"] as! String)! - 1
                self.appdata.correctAns[questionDict!["text"] as! String] = self.appdata.potentialAns[questionDict!["text"] as! String]?[ind]
            }
            self.appdata.questions[topicDict!["title"] as! String] = temp
        }
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    
        print(self.appdata.potentialAns)
        print(self.appdata.correctAns)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        // this is the replacement of implementing: "collectionView.addSubview(refreshControl)"
        tableView.refreshControl = refreshControl
        NotificationCenter.default.addObserver(self, selector:#selector(doSomething), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        doSomething()
        tableView.dataSource = self
        tableView.delegate = self
        appdata.bingo = 0
        appdata.currentQIndex = 0
        appdata.fromQuiz = false

    }
    
    @objc func refresh() {
        resetAppData()
        if(self.checkInternet()) {
            self.getHttp(Url: appdata.url)
        } else {
            self.offline()
            let alertVC = UIAlertController(title: "Network",
                                            message: "Network is not available. Using local storage data",
                                            preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.refreshControl.endRefreshing()
                alertVC.dismiss(animated: true)
            })
            self.present(alertVC, animated: true)
            self.refreshControl.endRefreshing()
        }
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
        refreshControl.endRefreshing()
    }
    
    func resetAppData() {
        appdata.categories = [String]()
        appdata.descriptions = [String]()
        
        appdata.questions = [String: [String]]()
        appdata.potentialAns =
            [String: [String]]()
        appdata.correctAns =
            [String: String]()

    }
    
    @objc func doSomething() {
        if(!appdata.fromQuiz || UserDefaults.standard.bool(forKey: "enabled_preference")) {
            if UserDefaults.standard.bool(forKey: "enabled_preference") && UserDefaults.standard.string(forKey: "url_preference") != nil && UserDefaults.standard.string(forKey: "url_preference") != "" {
                self.appdata.url = UserDefaults.standard.string(forKey: "url_preference")!
            }
            resetAppData()
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
            if UserDefaults.standard.bool(forKey: "enabled_preference") {
                if(self.checkInternet()) {
                    self.getHttp(Url: appdata.url)
                } else {
                    self.offline()
                    let alertVC = UIAlertController(title: "Network",
                                                    message: "Network is not available. Using local storage data",
                                                    preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        alertVC.dismiss(animated: true)
                    })
                    self.present(alertVC, animated: true)
                }
            }
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(!checkInternet() && self.appdata.categories.count == 0) {
            let alertVC = UIAlertController(title: "Network",
                                            message: "Network is not available. Using local storage data",
                                            preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.offline()
                alertVC.dismiss(animated: true)
            })
            self.present(alertVC, animated: true)
        }
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
        if appdata.score.index(forKey: topic) != nil && appdata.score[topic] == appdata.questions[topic]?.count  {
            cell.img.image = UIImage(named: "bingo")
        } else {
            cell.img.image = UIImage(named: topic)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topic = appdata.categories[indexPath.row]
        NSLog("User selected row at \(topic)")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {


        
        if (segue.identifier == "qseg") {
            let selectedRow = tableView.indexPathForSelectedRow!.row
            appdata.currentTopic = appdata.categories[selectedRow]
            let viewController = segue.destination as! questionTableViewController

            viewController.stringPassed = appdata.categories[selectedRow]
            viewController.questionIndex = 0
        }
        
        if(segue.identifier == "popover") {
            for t in appdata.categories {
                if appdata.score.index(forKey: t) == nil {
                    appdata.score[t] = 0
                }
            }
            let vc = segue.destination
            vc.preferredContentSize = CGSize(width: 450, height: 350)

            if vc.popoverPresentationController != nil {
                vc.popoverPresentationController?.delegate = self
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
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
