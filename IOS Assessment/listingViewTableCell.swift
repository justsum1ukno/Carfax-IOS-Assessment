//
//  listingViewCellTableViewCell.swift
//  IOS Assessment
//
//  Created by Justin Edwards on 8/7/19.
//  Copyright © 2019 apps. All rights reserved.
//

import UIKit
protocol CellDelegate: class {

    
}

class listingViewTableCell: UITableViewCell, UITextFieldDelegate {
   
   weak  var delegate:CellDelegate?
    @IBOutlet weak var listingPhoto: UIImageView!
    @IBOutlet weak var listingYear_Label: UILabel!
    @IBOutlet weak var listingMake_Label: UILabel!
    @IBOutlet weak var listingModel_Label: UILabel!
    @IBOutlet weak var listingPrice_Label: UILabel!
    @IBOutlet weak var listingMileage_Label: UILabel!
    @IBOutlet weak var listingLocation_Label: UILabel!
    @IBOutlet weak var divider: UIView!
    @IBOutlet weak var phoneButton: UIButton!
    
   
    override init(style:UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "listingTableViewCell")
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //   fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
   /* override init(style:UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "ListingTableViewCell")*/
    
     
    /*
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //   fatalError("init(coder:) has not been implemented")
    }
*/
    
}


//
//  BillTableViewCell.swift
//  bill_payone
//
//  Created by Justin Edwards on 11/7/17.
//  Copyright © 2017 apps. All rights reserved.
//




    
    // func textFieldDidBeginEditing(_ textField: UITextField) { // 2
    //self.delegate?.fieldDidBeginEditing(field: field)
    //}
    




