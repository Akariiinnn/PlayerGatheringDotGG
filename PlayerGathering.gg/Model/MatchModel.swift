////
////  MatchModel.swift
////  PlayerGathering.gg
////
////  Created by SDV Bordeaux on 18/01/2024.
////
//
import Foundation

class MatchModel: ObservableObject {
    
    @Published var match = [Match] ()
    
    func fetchData(matchID: String) async {
        guard let url = URL(string: "https://europe.api.riotgames.com/lol/match/v5/matches/\(matchID)?api_key=RGAPI-d4b7f805-fcf6-4bc6-acb5-054eda647f95") else {
            print("URL Invalide")
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    let decodeResponse = try JSONDecoder().decode([Match].self, from: data)
                    DispatchQueue.main.async {
                        self.match = decodeResponse
                    }//:async
                }//:do
                catch {
                    print("JSON Decoding error: \(error) + ratio")
                }//:catch
            }
            else {
                print("HTTP Error: Status code is not 200")
            }
        }//:do
        catch {
            print("Network Request error: \(error)")
        }
    }
}
