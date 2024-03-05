//
//  ContentView.swift
//  PlayerGathering.gg
//
//  Created by SDV Bordeaux on 18/01/2024.
//

import SwiftUI

struct DetailedSinglePlayer: View {
    //MARK: PROPERTIES
    @StateObject var lastMatchesModel = LastMatchesModel()
    @StateObject var matchModel = MatchModel()
    @StateObject var runesModel = RunesModel()
    
    
    @State private var matchData: [String: (Metadata?, Info?)] = [:]
    let playerPuuid : String
    let playerName : String
    let matchId: String
    let summonerSpells = SummonerSpells()
    
    @State var playerProfileIcon: String = "https://raw.communitydragon.org/latest/game/assets/ux/summonericons/profileicon0.png"
    
    func findParticipant(byPuuid puuid: String, in participants: [Info.Participants]) -> Info.Participants? {
        return participants.first { $0.puuid == puuid }
    }
    
    var body: some View {
        let participants = matchData[matchId]?.1?.participants ?? []
        let player = findParticipant(byPuuid: playerPuuid, in: participants)
        let playerChampId = player?.championId
        let playerChampUrl = "https://raw.communitydragon.org/latest/plugins/rcp-be-lol-game-data/global/default/v1/champion-icons/\(playerChampId ?? -1).png"
        let playerProfileIcon = "https://raw.communitydragon.org/latest/game/assets/ux/summonericons/profileicon\(player?.profileIcon ?? 0).png"
        let playerSummonerSpell1 = player?.summoner1Id
        let playerSummonerSpell2 = player?.summoner2Id
        let playerSummonerSpell1Url = "https://raw.communitydragon.org/latest/game/data/spells/icons2d/\(summonerSpells.spells[playerSummonerSpell1 ?? 0] ?? "summoner_avatar2.png")"
        let playerSummonerSpell2Url = "https://raw.communitydragon.org/latest/game/data/spells/icons2d/\(summonerSpells.spells[playerSummonerSpell2 ?? 0] ?? "summoner_avatar3.png")"
        
        let primary = runesModel.primaryRune(for: player)
        let secondary = runesModel.secondaryRune(for: player)
        
        let primaryIconUrl = runesModel.fetchPrimaryRuneIcon(for: primary.1, for: primary.0)
        let secondaryIconUrl = runesModel.fetchSecondaryRuneIcon(for: secondary)
        
        let primaryUrl = "https://ddragon.canisback.com/img/" + (primaryIconUrl ?? "perk-images/Styles/7200_Domination.png")
        let secondaryUrl = "https://ddragon.canisback.com/img/" + (secondaryIconUrl ?? "perk-images/Styles/7200_Domination.png")
        
        let playerItems: [Int?] = [
            player?.item0,
            player?.item1,
            player?.item2,
            player?.item3,
            player?.item4,
            player?.item5,
            player?.item6
        ]
        VStack(alignment: .leading) {
            HStack {
                VStack {
                    AsyncImage(url: URL(string: playerChampUrl)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 35, height: 35)
                    .aspectRatio(contentMode: .fit)
                    .shadow(radius: 30)
                    .clipShape(Circle())
                    
                }
                HStack (spacing: 1){
                    VStack (spacing: 1){
                        AsyncImage(url: URL(string: playerSummonerSpell1Url)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 15, height: 15)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(.rect(cornerRadii: .init(topLeading: 3, bottomLeading: 3, bottomTrailing: 3, topTrailing: 3)))
                        AsyncImage(url: URL(string: playerSummonerSpell2Url)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 15, height: 15)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(.rect(cornerRadii: .init(topLeading: 3, bottomLeading: 3, bottomTrailing: 3, topTrailing: 3)))
                    }
                    VStack (spacing: 1){
                        AsyncImage(url: URL(string: primaryUrl)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 15, height: 15)
                        .aspectRatio(contentMode: .fit)
                        .shadow(radius: 30)
                        .clipShape(Circle())
                        AsyncImage(url: URL(string: secondaryUrl)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 15, height: 15)
                        .aspectRatio(contentMode: .fit)
                        .shadow(radius: 30)
                        .clipShape(Circle())
                    }//:VStack
                }
                VStack(alignment:.leading) {
                    
                    HStack {
                        Text(player?.riotIdGameName ?? "")
                        Text("#\(player?.riotIdTagline ?? "")")
                        .foregroundStyle(.gray)
                    }
                    .font(.caption)
                    .fontWidth(Font.Width.compressed)
                    if let playerKills = player?.kills,
                       let playerDeaths = player?.deaths,
                       let playerAssists = player?.assists {
                        HStack {
                            Text("\(playerKills)")
                            Text("/")
                            Text("\(playerDeaths)")
                                .foregroundStyle(.red)
                            Text("/")
                            Text("\(playerAssists)")
                        }
                        .font(.caption)
                    } else {
                        Text("N/A")
                    }
                }
                VStack {
                    HStack (spacing: 1){
                        ForEach(playerItems, id: \.self) { item in
                            AsyncImage(url: URL(string: "https://ddragon.leagueoflegends.com/cdn/14.4.1/img/item/\(item?.description ?? "0").png")) { image in
                                image.resizable()
                            } placeholder: {
                                Rectangle()
                                    .fill(.gray)
                            }
                            .frame(width: 15, height: 15)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(.rect(cornerRadii: .init(topLeading: 2, bottomLeading: 2, bottomTrailing: 2, topTrailing: 2)))
                            .padding(0)
                        }
                        .padding(0)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing) // Align the player items to the right
                        .padding(.top, 5) // Add some top padding for spacing
                        .padding(.trailing, 20) // Add trailing padding for spacing
                    Text("\(player?.totalMinionsKilled ?? 0)CS")
                }
            }
            
        }//:VStack
        .task {
            matchData[matchId] = await matchModel.fetchData(matchID: matchId)
            await runesModel.fetchData()
            
            if let player = matchData[matchId]?.1?.participants.first(where: { $0.puuid == playerPuuid }) {
                let playerProfileIcon = "https://raw.communitydragon.org/latest/game/assets/ux/summonericons/profileicon\(player.profileIcon).png"
                
                // Update the state variable
                self.playerProfileIcon = playerProfileIcon
            }
        }
        
    }//:ForEach
}//:List

#Preview {
    DetailedSinglePlayer(playerPuuid: "mIuioPf36Oy2gr1BOHEzbxO0qS3f9Rn0JMKkE3e1Y1UNVMIZxfFv_nWZVtSF2Q-n9D9YRxMqnjlFFQ", playerName: "Akarin", matchId: "EUW1_6842921570")
}
