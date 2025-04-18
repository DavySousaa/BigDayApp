//
//  Theme.swift
//  Big Day App
//
//  Created by Davy Sousa on 17/04/25.
//

import Foundation
import UIKit

class Theme: Codable {
    var colorOne: UIColor
    var colorTwo: UIColor
    var titleColor: String

    enum CodingKeys: String, CodingKey {
        case colorOne, colorTwo, titleColor
    }

    init(colorOne: UIColor, colorTwo: UIColor, titleColor: String) {
        self.colorOne = colorOne
        self.colorTwo = colorTwo
        self.titleColor = titleColor
    }

    // Encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(colorOne.toHexString(), forKey: .colorOne)
        try container.encode(colorTwo.toHexString(), forKey: .colorTwo)
        try container.encode(titleColor, forKey: .titleColor)
    }

    // Decoding
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let colorOneHex = try container.decode(String.self, forKey: .colorOne)
        let colorTwoHex = try container.decode(String.self, forKey: .colorTwo)
        self.colorOne = UIColor(hex: colorOneHex)
        self.colorTwo = UIColor(hex: colorTwoHex)
        self.titleColor = try container.decode(String.self, forKey: .titleColor)
    }
}


