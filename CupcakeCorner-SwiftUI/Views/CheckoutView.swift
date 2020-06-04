//
//  CheckoutView.swift
//  CupcakeCorner-SwiftUI
//
//  Created by Aldiyar B on 6/3/20.
//  Copyright © 2020 Aldiyar B. All rights reserved.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: OrderWrapper
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Image("cupcakes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)
                    Text("Your order total is $\(self.order.order.cost, specifier: "%.2f")")
                        .font(.title)
                    
                    Button("Place Order") {
                        self.placeOrder()
                    }
                .padding()
                }
            }
            .navigationBarTitle("Checkout", displayMode: .inline)
        }
    .alert(isPresented: $showingAlert, content: {
        Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("Great")))
    })
    }
    
    // LOGIC
    
    func placeOrder() {
        guard let encoded = try? JSONEncoder().encode(order.order) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                self.alertMessage = "No data in response: \(error?.localizedDescription ?? "Unknown error")"
                self.alertTitle = "Error"
                self.showingAlert = true
                return
            }
            
            if let decodedOrder = try? JSONDecoder().decode(Order.self, from: data) {
                self.alertMessage = "Your order for \(decodedOrder.quantity) x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on it's way!"
                self.showingAlert = true
            } else {
                self.alertTitle = "Error"
                self.alertMessage = "Invalid response from server"
                self.showingAlert = true
            }
        }.resume()
        
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: OrderWrapper())
    }
}
