//
//  Helper.swift
//  MyCloset
//
//  Created by SEONGJUN on 2020/09/05.
//  Copyright © 2020 pandaman. All rights reserved.
//

import UIKit

enum CategoryButtonType: Int {
    case categorySelectBtn1 = 1
    case categorySelectBtn2
    case categorySelectBtn3
    case categorySelectBtn4
    case categorySelectBtn5
    case categorySelectBtn6
    case categorySelectBtn7
    case categorySelectBtn8
    
    var name: String {
        switch self.rawValue {
        case 1:
            return "top"
        case 2:
            return "bottom"
        case 3:
            return "outer"
        case 4:
            return "shoes"
        case 5:
            return "cap"
        case 6:
            return "socks"
        case 7:
            return "bag"
        case 8:
            return "acc"
        default:
            break
        }
        return ""
    }
    
    var fileCount: Int {
        switch self.rawValue {
        case 1:
            return DataManager.shared.top.count
        case 2:
            return DataManager.shared.bottom.count
        case 3:
            return DataManager.shared.outer.count
        case 4:
            return DataManager.shared.shoes.count
        case 5:
            return DataManager.shared.cap.count
        case 6:
            return DataManager.shared.socks.count
        case 7:
            return DataManager.shared.bag.count
        case 8:
            return DataManager.shared.acc.count
        default:
            break
        }
        return -0
    }
    
}

enum CategoryCellType: Int, CaseIterable {
    case top
    case bottom
    case outer
    case shoes
    case cap
    case socks
    case bag
    case acc
    
    var cellID: String {
        switch self {
        case .top:
            return TopCell.identifier
        case .bottom:
            return BottomCell.identifier
        case .outer:
            return OuterCell.identifier
        case .shoes:
            return ShoesCell.identifier
        case .cap:
            return CapCell.identifier
        case .socks:
            return SocksCell.identifier
        case .bag:
            return BagCell.identifier
        case .acc:
            return AccCollectionViewCell.identifier
        }
    }
    
    func typeCasting(contoller: MyClosetViewController, cell: UICollectionViewCell) -> UICollectionViewCell {
        switch self {
        case .top:
            let casted = cell as! TopCell
            contoller.delegates[self.rawValue] = casted
            return casted
        case .bottom:
            let casted = cell as! BottomCell
            contoller.delegates[self.rawValue] = casted
            return casted
        case .outer:
            let casted = cell as! OuterCell
            contoller.delegates[self.rawValue] = casted
            return casted
        case .shoes:
            let casted = cell as! ShoesCell
            contoller.delegates[self.rawValue] = casted
            return casted
        case .cap:
            let casted = cell as! CapCell
            contoller.delegates[self.rawValue] = casted
            return casted
        case .socks:
            let casted = cell as! SocksCell
            contoller.delegates[self.rawValue] = casted
            return casted
        case .bag:
            let casted = cell as! BagCell
            contoller.delegates[self.rawValue] = casted
            return casted
        case .acc:
            let casted = cell as! AccCollectionViewCell
            contoller.delegates[self.rawValue] = casted
            return casted
        }
    }
}
