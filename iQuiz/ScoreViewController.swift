//
//  ScoreViewController.swift
//  iQuiz
//
//  Created by Christy Lu on 2/22/18.
//  Copyright © 2018 Christy Lu. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var appdata = AppData.shared
    @IBOutlet weak var tableView: UITableView!
    /*@IBAction func btnClose(_ sender: Any) {
        performSegue(withIdentifier: "popover", sender: nil)
    }*/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appdata.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        NSLog("\(indexPath)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "scoreCell", for: indexPath) as! TableViewCell
        let topic = appdata.categories[indexPath.row]
        let s = appdata.score[topic]
        print(appdata.score)
        NSLog(topic)
        let total = appdata.questions[topic]?.count
        cell.topicScore.text = "\(topic ?? ""): \(s ?? 0) out of \(total ?? 0)"
        NSLog("Score: \(s ?? 0), Topic: \(appdata.currentTopic)")
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
