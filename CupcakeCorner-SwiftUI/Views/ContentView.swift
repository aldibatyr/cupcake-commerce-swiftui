//
//  ContentView.swift
//  CupcakeCorner-SwiftUI
//
//  Created by Aldiyar B on 6/3/20.
//  Copyright © 2020 Aldiyar B. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var order = OrderWrapper()
    var body: some View {
        NavigationView{
            Form {
                Section {
                    Picker(selection: $order.order.type, label: Text("Select your cake type")) {
                        ForEach(0..<OrderStruct.types.count, id: \.self) {
                            Text(OrderStruct.types[$0])
                        }
                    }
                    Stepper(value: $order.order.quantity, in: 3...20) {
                        Text("Number of cakes: \(order.order.quantity)")
                    }
                }
                Section {
                    Toggle(isOn: $order.order.specialRequestEnabled.animation()) {
                        Text("Any special request?")
                    }
                    if order.order.specialRequestEnabled {
                        Toggle(isOn: $order.order.extraFrosting, label: {
                            Text("Add extra frosting")
                        })
                        
                        Toggle(isOn: $order.order.addSprinkles, label: {
                            Text("Add extra sprinkles")
                        })
                    }
                }
                
                Section {
                    NavigationLink(destination: AddressView(order: order), label: {
                        Text("Delivery details")
                    })
                }
            }.navigationBarTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
