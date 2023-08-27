//
//  JokeCell.swift
//  SampleApp
//
//  Created by Prashant Bashishth on 27/08/23.
//

import UIKit

class JokeCell: UITableViewCell {
    @IBOutlet weak var content: UILabel!
   
    static var identifier: String { return String(describing: self) }
    static var nib: UINib { return UINib(nibName: identifier, bundle: nil) }

    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }

    func initView() {
        backgroundColor = .clear
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        content.text = nil
    }
}
