//
//  LastMatchesModel.swift
//  PlayerGathering.gg
//
//  Created by SDV Bordeaux on 18/01/2024.
//

import Foundation

class PlayerModel: ObservableObject {
    
    @Published var player = String ()
    @Published var statusCode = Int ()
    @Published var playerName = String ()
    
    
    func fetchData(tagLine: String, gameName: String) async {
        guard let url = URL(string: "https://europe.api.riotgames.com/riot/account/v1/accounts/by-riot-id/\(gameName)/\(tagLine)?api_key=RGAPI-d4b7f805-fcf6-4bc6-acb5-054eda647f95") else {
            print("URL Invalide")
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    let decodeResponse = try JSONDecoder().decode(Player.self, from: data)
                    DispatchQueue.main.async {
                        self.player = decodeResponse.puuid
                        self.statusCode = httpResponse.statusCode
                        self.playerName = decodeResponse.gameName
                    }//:async
                }//:do
                catch {
                    print("JSON Decoding error: \(error)")
                }//:catch
            }
            else {
                print("HTTP Error: Status code is not 200")
                print(url)
            }
        }//:do
        catch {
            print("Network Request error: \(error)")
        }
    }
}
