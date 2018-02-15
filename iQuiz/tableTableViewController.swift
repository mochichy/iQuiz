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
                                        message: "Settings go here",
                                        preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            alertVC.dismiss(animated: true)
        })
        self.present(alertVC, animated: true)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(appdata.categories)
        tableView.dataSource = self
        tableView.delegate = self
        print(appdata.bingo)

        // Do any additional setup after loading the view.
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
