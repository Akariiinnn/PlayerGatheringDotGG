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
    @StateObject var runesModel = RunesModel()
    
    
    @State private var matchData: [String: (Metadata?, Info?)] = [:]
    let playerPuuid : String
    let playerName : String
    let summonerSpells = SummonerSpells()
    
    @State var playerProfileIcon: String = "https://raw.communitydragon.org/latest/game/assets/ux/summonericons/profileicon0.png"
    
    func findParticipant(byPuuid puuid: String, in participants: [Info.Participants]) -> Info.Participants? {
        return participants.first { $0.puuid == puuid }
    }
    
    var body: some View {
        //MARK: BODY
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
        
        NavigationView {
            ScrollView{
            ForEach(lastMatchesModel.matches, id: \.self) { matchID in
                    SingleView(playerPuuid: playerPuuid, playerName: playerName, matchId: matchID)
                }
                .buttonStyle(PlainButtonStyle())
            }//:List
            .task {
                await lastMatchesModel.fetchData(riotpuuid: playerPuuid)
            }
        }
        
    }
}

#Preview {
    ProfileView(playerPuuid: "mIuioPf36Oy2gr1BOHEzbxO0qS3f9Rn0JMKkE3e1Y1UNVMIZxfFv_nWZVtSF2Q-n9D9YRxMqnjlFFQ", playerName: "Akarin")
}
