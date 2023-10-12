//
//  MyCustomCell.swift
//  hw2-datadisplayintable
//
//  Created by Runwei Wang on 9/27/23.
//

import UIKit

class WeatherCell: UITableViewCell {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.clear
        cityLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        cityLabel.textColor = UIColor.label

        temperatureLabel.font = UIFont.systemFont(ofSize: 30)
        temperatureLabel.textColor = UIColor.label

        conditionLabel.font = UIFont.systemFont(ofSize: 16)
        conditionLabel.textColor = UIColor.tertiaryLabel
        
        conditionImageView.layer.cornerRadius = 5
        conditionImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            self.contentView.backgroundColor = UIColor.systemGray5
        } else {
            self.contentView.backgroundColor = UIColor.systemGray6
        }
    }

}
