//
//  MyNotesListVC.swift
//  Notes
//
//  Created by Sunil Developer on 08/01/23.
//

import UIKit

class MyNotesListVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var lblNotesNotFound: UILabel!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var notesListTV: UITableView!
    var dbobject: DBHelper = DBHelper()
   // var obj: Notes?
    
    var notesArray: [Notes] = []
    var notesBackUpArray: [Notes] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
        notesArray = dbobject.fetchStoredData()
        lblNotesNotFound.isHidden = true
        self.notesBackUpArray = notesArray
        notesNotFound()
        notesListTV.delegate = self
        notesListTV.dataSource = self
        notesListTV.register(UINib(nibName: MyNotesTVC.identifier, bundle: nil), forCellReuseIdentifier: MyNotesTVC.identifier)
        
        // SearchBar addTarget
        
        txtSearch.addTarget(self, action: #selector(textSearchChange(_:)), for: .editingChanged)
      }
    
    //    @IBAction func searchHendler(_ sender: UITextField) {
//        if let searchText = sender.text {
//            notesArray = notesBackUpArray.filter({ note in
//                return (note.description).lowercased().contains(searchText.lowercased())
//            })
//        }
//        self.notesListTV.reloadData()
//    }
    
    @objc func textSearchChange(_ sender: UITextField){
        print(sender.text ?? "")
        if (sender.text?.isEmpty ?? false){
            self.notesArray = notesBackUpArray
        } else {
            notesArray = notesBackUpArray.filter({ note in
                return (note.description).lowercased().contains((sender.text ?? "").lowercased())
            })
            self.notesListTV.reloadData()
        }
        self.notesListTV.reloadData()
    }
    
    @IBAction func onClickAddBtn(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddNotesViewController") as! AddNotesViewController
        navigationController?.pushViewController(vc, animated: true)
}
    override func viewWillAppear(_ animated: Bool) {
        notesArray = dbobject.fetchStoredData()
        self.notesListTV.reloadData()
        notesNotFound()
    }
}
// Extension
// Tableview Delegate
extension MyNotesListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notesListTV.dequeueReusableCell(withIdentifier: MyNotesTVC.identifier, for: indexPath) as! MyNotesTVC
        cell.obj = notesArray[indexPath.row]
        cell.lblCountNumber.text = "\(indexPath.row + 1)"
       
        // Delete item
        cell.deleteNotes = {
            let alertVC = UIAlertController(title: "Delete", message: "Are you sure?", preferredStyle: .alert)
            let yesBtn = UIAlertAction(title: "YES", style: .destructive) { (alert) in
             let obj = self.notesArray[indexPath.row]
                
                self.dbobject.deleteRecord(id: Int32(obj.id ), index: indexPath.row)
                self.notesArray.remove(at: indexPath.row)
                self.notesListTV.reloadData()
                self.notesNotFound()
            }
            let noBtn = UIAlertAction(title: "NO", style: .default) { (alert) in
                self.dismiss(animated: true, completion: nil)
            }
            alertVC.addAction(yesBtn)
            alertVC.addAction(noBtn)
            self.present(alertVC, animated: true, completion: nil)
        }
        // edit item
        cell.editNotes = {
            let editVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AddNotesViewController") as! AddNotesViewController
            editVC.obj = self.notesArray[indexPath.row]
            self.navigationController?.pushViewController(editVC, animated: false)

        }
        
        return cell
    }

    func notesNotFound() {
        if notesArray.count == 0 {
            lblNotesNotFound.isHidden = false
        } else {
            lblNotesNotFound.isHidden = true
        }
    }
    
    func initialSetUp() {
        searchView.clipsToBounds = true
        searchView.layer.cornerRadius = 15
        searchView.layer.borderWidth = 1.0
        searchView.layer.borderColor = UIColor.black.cgColor
    }
    
    
}
