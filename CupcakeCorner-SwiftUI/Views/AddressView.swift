//
//  AddressView.swift
//  CupcakeCorner-SwiftUI
//
//  Created by Aldiyar B on 6/3/20.
//  Copyright © 2020 Aldiyar B. All rights reserved.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var order: OrderWrapper
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.order.name)
                TextField("Street address", text: $order.order.streetAddress)
                TextField("City", text: $order.order.city)
                TextField("Zip", text: $order.order.zip)
            }
            
            Section {
                NavigationLink(destination: CheckoutView(order: order), label: {
                    Text("Checkout")
                })
            }
            .disabled(order.order.hasValidAddress == false)
        }
        .navigationBarTitle("Delivery details", displayMode: .inline)
    }
}
struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(order: OrderWrapper())
    }
}
