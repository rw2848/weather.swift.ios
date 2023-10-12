//
//  File.swift
//  hw3-liveapidata
//
//  Created by Runwei Wang on 10/11/23.
//

import UIKit

class ForecastCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.clear
        dateLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        dateLabel.textColor = UIColor.white

        temperatureLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        temperatureLabel.textColor = UIColor.white
        
        conditionImageView.layer.cornerRadius = 4
        conditionImageView.clipsToBounds = true
    }

}
