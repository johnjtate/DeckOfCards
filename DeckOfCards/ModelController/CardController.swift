//
//  CardController.swift
//  DeckOfCards
//
//  Created by John Tate on 9/3/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

import UIKit

// How to build your URL
// 1) Components are /
// 2) Query items are [:]
// 3) Extensions are .

class CardController {
    
    static let shared = CardController()
    
    // This makes a true singleton.  That way you can only have ONE instance of this class.
    private init() {}
    
    // https://deckofcardsapi.com/api/deck/<<deck_id>>/draw/?count=1
    
    private let baseURLString = "https://deckofcardsapi.com/api/deck"
    

    func fetchCard(count: Int, completion: @escaping ([Card]?) -> Void) {
        guard let baseURL = URL(string: baseURLString) else {
            // Break our code and don't continue.  Error message to the developer
            fatalError("Bad base URL")
        }
        
        // This is ow you add a component ("/"
        let newURL = baseURL.appendingPathComponent("new").appendingPathComponent("draw")
        
        // BUILD your url
        var components = URLComponents(url: newURL, resolvingAgainstBaseURL: true)
        
        // This is the dictionary of the user's search term.  When they hit the draw button
        let queryItems = URLQueryItem(name: "count", value: "\(count)")
        // If you want more query items, this is where you would add them
        components?.queryItems = [queryItems]
        
        // THIS is the final Request URL
        guard let url = components?.url else { completion([]);  return }
        
        print("🎃 \(Thread.isMainThread)")
        // dataTask with URL has the HTTP protocol GET built within it
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            print(Thread.isMainThread)
            // 1) Handle your error
            if let error = error {
                print("There was an error fetching from dataTask \(#function) \(error) \(error.localizedDescription)")
                completion([]); return
            }
            
            // We don't have to do this
//            if let respondeCode = response {
//                print(respondeCode)
//                completion([]); return
//            }
            
            // 2) Handle your data
            guard let dataThatCameBack = data else { print("no data returned"); completion([]); return }
            
            // 3) Use JSONDecoder to decode your object
            do {
                let cards = try JSONDecoder().decode(DeckDictionary.self, from: dataThatCameBack).cards
                completion(cards)
            } catch let error {
                print("There was an error decoding our object \(error) \(error.localizedDescription)")
                completion([]); return
            }
    
        }.resume()
        
    }
    
    func fetchCardImage(card: Card, completion: @escaping (UIImage?) -> Void) {
        
          // these shouldn't be used because they are not asynchronous
//        let data = Data(contentsOf: <#T##URL#>)
//        let image = UIImage(contentsOfFile: <#T##String#>)
        
        guard let url = URL(string: card.image) else { return }
        
        // on the main thread here
        print("Are you on dahhh main thread \(Thread.isMainThread)")
        // goes off the main thread for the dataTask
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            print("🤠 Are you on the main \(Thread.isMainThread)")
            if let error = error {
                print("Error with fetching image data task \(error) \(error.localizedDescription)")
                // Complete with nothing and return out of this function.
                completion(nil); return
            }
            
            guard let data = data else { completion(nil); return }
            
            guard let image = UIImage(data: data) else { completion(nil); return }
            
            // If it does work, complete with an image coming from the data.
            completion(image)
            
        }.resume()
    }
    
}
