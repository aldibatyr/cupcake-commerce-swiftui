//
//  ContentView.swift
//  CupcakeCorner-SwiftUI
//
//  Created by Aldiyar B on 6/3/20.
//  Copyright © 2020 Aldiyar B. All rights reserved.
//

import SwiftUI

// validating and disabling forms

struct ValidatingAndDisablingFormsView: View {
    @State var username = ""
    @State var email = ""
    var disabledForm: Bool {
        username.count < 5 || email.count < 5
    }
    var body: some View {
        Form {
            Section {
                TextField("Username", text: $username)
                TextField("Email", text: $email)
            }
            
            Section {
                Button(action: {
                    print("creating account")
                }, label: {
                    Text("Create account...")
                })
            }
            .disabled(disabledForm)
        }
    }
}

/// sending and receiving Codable data with URLSession and SwiftUi

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}

struct FetchingURLView: View {
    @State var results = [Result]()
    var body: some View {
        List(results, id: \.trackId) {item in
            VStack(alignment: .leading, spacing: 0, content: {
                Text(item.trackName)
                    .font(.headline)
                
                Text(item.collectionName)
            })
        }
    .onAppear(perform: loadData)
    }
    
    // LOGIC
    
    func loadData() {
        // loading data
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
            print("Invalid url")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                    DispatchQueue.main.async {
                        self.results = decodedResponse.results
                    }
                    
                    return
                }
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }
}

/// adding Codable conformance for @Published properties

class User: ObservableObject, Codable {
    enum CodingKeys: CodingKey {
        case name
    }
    @Published var name = "Aldiyar Batyrbekov"
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
    }
}


struct OverviewView: View {
    var body: some View {
        ValidatingAndDisablingFormsView()
    }
}

struct OverviewView_Previews: PreviewProvider {
    static var previews: some View {
        OverviewView()
    }
}
