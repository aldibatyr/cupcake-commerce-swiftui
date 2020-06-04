//
//  Order.swift
//  CupcakeCorner-SwiftUI
//
//  Created by Aldiyar B on 6/3/20.
//  Copyright © 2020 Aldiyar B. All rights reserved.
//

import Foundation

//enum Flavor: CaseIterable, Codable {
//    case vanilla, strawberry, chocolate, rainbow
//}


/// Why is this so much easier with struct

// TODO: - Find out why it is easier doing shit with struct
struct OrderStruct: Codable {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type: Int = 0
    var quantity: Int = 3
    var specialRequestEnabled: Bool = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting: Bool = false
    var addSprinkles: Bool = false
    var name: String = ""
    var streetAddress: String = ""
    var city: String = ""
    var zip: String = ""
    
    var hasValidAddress: Bool {
        
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || streetAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || zip.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return false
        }
        return true
    }
    
    var cost: Double {
        var cost = Double(quantity) * 2
        cost += Double(type) / 2
        
        if extraFrosting {
            cost += Double(quantity)
        }
        if addSprinkles {
            cost += Double(quantity) / 2
        }
        
        return cost
    }
    
}

class OrderWrapper: ObservableObject {
    @Published var order = OrderStruct()
}

class Order: ObservableObject, Codable {
    
    enum CodingKeys: CodingKey {
        case type, quantity, extraFrosting, addSprinkles, name, streetAddress, city, zip
    }
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    @Published var type = 0
    @Published var quantity = 3
    @Published var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    @Published var extraFrosting = false
    @Published var addSprinkles = false
    
    @Published var name = ""
    @Published var streetAddress = ""
    @Published var zip = ""
    @Published var city = ""
    
    var hasValidAddress: Bool {
        
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || streetAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || zip.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return false
        }
        return true
    }
    
    var cost: Double {
        var cost = Double(quantity) * 2
        cost += Double(type) / 2
        
        if extraFrosting {
            cost += Double(quantity)
        }
        if addSprinkles {
            cost += Double(quantity) / 2
        }
        
        return cost
    }
    
    init() {}
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        type = try container.decode(Int.self, forKey: .type)
        quantity = try container.decode(Int.self, forKey: .quantity)
        extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
        addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)
        name = try container.decode(String.self, forKey: .name)
        streetAddress = try container.decode(String.self, forKey: .streetAddress)
        city = try container.decode(String.self, forKey: .city)
        zip = try container.decode(String.self, forKey: .zip)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(extraFrosting, forKey: .extraFrosting)
        try container.encode(addSprinkles, forKey: .addSprinkles)
        try container.encode(name, forKey: .name)
        try container.encode(streetAddress, forKey: .streetAddress)
        try container.encode(city, forKey: .city)
        try container.encode(zip, forKey: .zip)
    }
}
