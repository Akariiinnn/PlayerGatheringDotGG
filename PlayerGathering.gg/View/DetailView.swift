//
//  DetailView.swift
//  PlayerGathering.gg
//
//  Created by SDV Bordeaux on 05/03/2024.
//

import SwiftUI

struct DetailView: View {
    @StateObject var matchModel = MatchModel()
    @StateObject var runesModel = RunesModel()
    
    @State private var matchData: [String: (Metadata?, Info?)] = [:]
    let win: Bool
    let matchId: String
    let playerPuuid: String
    var body: some View {
        let players = matchData[matchId]?.1?.participants ?? []
        let group1 = Array(players.prefix(5))
        let group2 = Array(players.dropFirst(5))
        let group1win = group1.contains(where: {$0.puuid == playerPuuid}) ? win : !win
        let group2win = group1.contains(where: {$0.puuid == playerPuuid}) ? !win : win
            
            
        
        VStack {
//            Rectangle()
//                .fill(win ? .green : .red)
//                .frame(height: 234)
//                .edgesIgnoringSafeArea(.all)
//            
//            Spacer()
            
            HStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(group1win ? "Victoire" : "Défaite")
                        ForEach(group1, id: \.puuid) { participant in
                            DetailedSinglePlayer(playerPuuid: participant.puuid, playerName: participant.riotIdGameName, matchId: matchId)
                        }
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(group2win ? "Victoire" : "Défaite")
                        ForEach(group2, id: \.puuid) { participant in
                            DetailedSinglePlayer(playerPuuid: participant.puuid, playerName: participant.riotIdGameName, matchId: matchId)
                        }
                    }
                }
            }
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)) // Add padding to the HStack
        }
        .task {
            matchData[matchId] = await matchModel.fetchData(matchID: matchId)
        }
    }
    
}


#Preview {
    DetailView(win: false, matchId: "EUW1_6842921570", playerPuuid: "mIuioPf36Oy2gr1BOHEzbxO0qS3f9Rn0JMKkE3e1Y1UNVMIZxfFv_nWZVtSF2Q-n9D9YRxMqnjlFFQ")
}
