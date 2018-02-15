//
//  questionTableViewController.swift
//  iQuiz
//
//  Created by Christy Lu on 2/12/18.
//  Copyright © 2018 Christy Lu. All rights reserved.
//

import UIKit

class questionTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var stringPassed = String()
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var q: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    var appdata = AppData.shared
    var currentTopic = String()
    var selected = String()
    var questionIndex: Int?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NSLog("count")
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        NSLog("\(indexPath)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "potentialCell", for: indexPath) as! TableViewCell
        let potential = appdata.potentialAns[appdata.currentQuestion]![indexPath.row]
        cell.potentialA.text = potential
        NSLog("\(potential)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected = appdata.potentialAns[appdata.currentQuestion]![indexPath.row]
        NSLog("User selected row at \(selected)")
    }
    
    
    /*@IBAction func btnSubmut(_ sender: Any) {
    }*/
    
    @IBAction func btnSubmit(_ sender: Any) {
        
    }
    
    /*override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
       return false
    }*/
    
    override func viewWillAppear(_ animated: Bool) {
        //question.text = stringPassed
        question.text = appdata.currentTopic
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        appdata.currentQuestion = appdata.questions[appdata.currentTopic]![appdata.currentQIndex]
        //q.text = appdata.questions[stringPassed]?[0]
        q.text = appdata.currentQuestion
        //currentQ = (appdata.questions[stringPassed]?[0])!
        //NSLog("\(appdata.potentialAns[currentQ]![0])")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        /*let talkView = segue.destination as! ViewController
         talkView.history = history*/
        if (segue.identifier == "showAnswer") {
            let viewController = segue.destination as! AnswerViewController
            
            viewController.userAnswer = selected
            //viewController.currentQuestion = currentQ
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
