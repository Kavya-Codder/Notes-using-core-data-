//
//  MyNotesTVC.swift
//  Notes
//
//  Created by Sunil Developer on 08/01/23.
//

import UIKit

class MyNotesTVC: UITableViewCell {
static let identifier = "MyNotesTVC"
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewCount: UIView!
    @IBOutlet weak var lblCountNumber: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPriority: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    var obj: Notes? {
        didSet {
            
            lblTitle.text = obj?.title
            lblDate.text = obj?.date
            lblStatus.text = "Status: \(obj?.status ?? "")"
            lblDescription.text = "Body: \(obj?.descraption ?? "")"
            lblPriority.text = "Priority: \(obj?.priority ?? "")"
            if obj?.priority == "Urgent" {
                viewContainer.backgroundColor = UIColor(named: "red-1")
                lblTitle.textColor = UIColor.white
                lblPriority.textColor = UIColor.white
                lblDate.textColor = UIColor.white
                lblDescription.textColor = UIColor.white
                lblStatus.textColor = UIColor.white
                btnEdit.tintColor = UIColor.white
                btnDelete.tintColor = UIColor.white
            }
        }
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetUp()
       
    }
    
    var deleteNotes:(()->Void)?
    @IBAction func onClickDelete(_ sender: Any) {
        deleteNotes?()
    }
    var editNotes:(()->Void)?
    @IBAction func onClickEdit(_ sender: Any) {
        editNotes?()
    }
    
    func initialSetUp() {
        viewCount.clipsToBounds = true
        viewCount.layer.cornerRadius = 12.5
        viewContainer.clipsToBounds = true
        viewContainer.layer.cornerRadius = 10
        
        viewContainer.layer.shadowColor = UIColor.white.cgColor
        viewContainer.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        viewContainer.layer.shadowRadius = 1.0
        viewContainer.layer.shadowOpacity = 1
        viewContainer.layer.masksToBounds = false
    }
}
