//
//  ViewController.swift
//  HashBrown
//
//  Created by YoSeob Lee on 2017. 4. 17..
//  Copyright © 2017년 YoSeob Lee. All rights reserved.
//

import UIKit
import CoreData
import NotificationCenter

extension Notification.Name {
    static let NotificationTest = Notification.Name("test")
}

class ViewController: UIViewController {
    
    let dao = DataAccessObject()
    let cAlbum = CustomPhotoAlbum.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dao.fetch(callback: testCB)
    }
    
    func clickImage(sender: Any){
        print(sender)
    }
    
    func testCB(hashs: [String] ){
        
        var y = 100.0
        for index in 0..<hashs.count {
            let label = UILabel(frame: CGRect(x: 10.0, y: y, width: Double(self.view.frame.size.width/2), height: 40.0))
            let hash = hashs[index]
            label.text = hash as? String
            label.backgroundColor = UIColor.red
            self.view.addSubview(label)
            y += (10 + 40)
        }
    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func clickAddButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "New Name",
                                      message: "Add a new name",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) {
                                        [unowned self] action in
                                        
                                        guard let textField = alert.textFields?.first,
                                            let nameToSave = textField.text else {
                                                return
                                        }
                                    
                                        self.cAlbum.createAlbum(name: nameToSave)
                                        self.dao.save(name: nameToSave)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func test() {
        print("test")
    }

}


