//
//  ContentView.swift
//  PlayerGathering.gg
//
//  Created by SDV Bordeaux on 18/01/2024.
//

import SwiftUI

struct ProfileView: View {
    //MARK: PROPERTIES
    @StateObject var lastMatchesModel = LastMatchesModel()
    @StateObject var matchModel = MatchModel()
    
    
    @State private var matchData: [String: (Metadata?, Info?)] = [:]
    let playerPuuid : String
    let playerName : String
    
    @State var playerProfileIcon: String = "https://raw.communitydragon.org/latest/game/assets/ux/summonericons/profileicon0.png"
    
    func findParticipant(byPuuid puuid: String, in participants: [Info.Participants]) -> Info.Participants? {
        return participants.first { $0.puuid == puuid }
    }
    
    var body: some View {
        //MARK: BODY
        NavigationStack {
            VStack {
                AsyncImage(url: URL(string: playerProfileIcon)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 200, height: 200)
                .aspectRatio(contentMode: .fit)
                .shadow(radius: 30)
                .clipShape(Circle())
                Text(playerName)
                    .font(.largeTitle)
            }//:VStack
            
            
            List{
                ForEach(lastMatchesModel.matches, id: \.self) { matchID in
                    
                    let participants = matchData[matchID]?.1?.participants ?? []
                    let player = findParticipant(byPuuid: playerPuuid, in: participants)
                    let playerChampId = player?.championId
                    let playerChampUrl = "https://raw.communitydragon.org/latest/plugins/rcp-be-lol-game-data/global/default/v1/champion-icons/\(playerChampId ?? -1).png"
                    let playerProfileIcon = "https://raw.communitydragon.org/latest/game/assets/ux/summonericons/profileicon\(player?.profileIcon ?? 0).png"
                    let group1 = Array(participants.prefix(5))
                    let group2 = Array(participants.dropFirst(5))
                    
                    HStack {
                        VStack {
                            AsyncImage(url: URL(string: playerChampUrl)) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 70, height: 70)
                            .aspectRatio(contentMode: .fit)
                            .shadow(radius: 30)
                            .clipShape(Circle())
                            HStack {
                                Image("flash")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .aspectRatio(contentMode: .fit)
                                Image("ignite")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .aspectRatio(contentMode: .fit)
                            }
                        }
                        VStack {
                            Image("Conqueror")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .aspectRatio(contentMode: .fit)
                                .shadow(radius: 30)
                                .clipShape(Circle())
                            Image("inspiration")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .aspectRatio(contentMode: .fit)
                                .shadow(radius: 30)
                                .clipShape(Circle())
                        }//:VStack
                        VStack {
                            
                            if let playerKills = player?.kills,
                               let playerDeaths = player?.deaths,
                               let playerAssists = player?.assists {
                                Text("\(playerKills)/\(playerDeaths)/\(playerAssists)")
                                if playerDeaths != 0 {
                                    let kdaRatio = (Double(playerKills) + Double(playerAssists)) / Double(playerDeaths)
                                    
                                    Text("KDA \(String(format: "%.3f", round(kdaRatio * 1000) / 1000 ))")
                                } else {
                                    Text("Perfect KDA!")
                                }
                            } else {
                                Text("N/A")
                            }
                            if let visionScore = player?.visionScore {
                                Text("\(visionScore) Vision")
                            } else {
                                Text("N/A")
                            }
                        }
                        .font(.caption)
                        
                        HStack {
                            
                            VStack {
                                
                                // First group of participants
                                ForEach(group1, id: \.puuid) { participant in
                                    Text(participant.riotIdGameName)
                                        .font(.caption2)
                                    // Add more Text views for other participant information as needed
                                }
                            }
                            
                            // Spacer for better spacing
                            Spacer()
                            
                            VStack {
                                // Second group of participants
                                ForEach(group2, id: \.puuid) { participant in
                                    Text(participant.riotIdGameName)
                                        .font(.caption2)
                                    // Add more Text views for other participant information as needed
                                }
                            }
                        }
                        
                        
                    }//:HStack
                    .task {
                        matchData[matchID] = await matchModel.fetchData(matchID: matchID)
                        
                        if let player = matchData[matchID]?.1?.participants.first(where: { $0.puuid == playerPuuid }) {
                            let playerProfileIcon = "https://raw.communitydragon.org/latest/game/assets/ux/summonericons/profileicon\(player.profileIcon).png"
                            
                            // Update the state variable
                            self.playerProfileIcon = playerProfileIcon
                        }
                    }
                    
                }//:ForEach
            }//:List
            
        }//:NavigationStack
        .task {
            await lastMatchesModel.fetchData(riotpuuid: playerPuuid)
            
            
        }
    }
    
}

#Preview {
    ProfileView(playerPuuid: "mIuioPf36Oy2gr1BOHEzbxO0qS3f9Rn0JMKkE3e1Y1UNVMIZxfFv_nWZVtSF2Q-n9D9YRxMqnjlFFQ", playerName: "Akarin")
}