//
//  CardView.swift
//  BootcampCase
//
//  Created by Muhammet  on 22.07.2023.
//

import Foundation
import UIKit

final class CardView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }
    private func initialSetup() {
        layer.backgroundColor = .init(red: 255, green: 255, blue: 255, alpha: 1)
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.6
        layer.cornerRadius = 5

    }
}
