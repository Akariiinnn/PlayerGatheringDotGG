//
//  ContentView.swift
//  PlayerGathering.gg
//
//  Created by SDV Bordeaux on 18/01/2024.
//

import SwiftUI

struct SingleView: View {
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
        HStack {
            NavigationLink(destination: DetailView(win: player?.win ?? false, matchId: matchId, playerPuuid: playerPuuid)) {
                Rectangle()
                    .fill(player?.win == true ? .green : .red)
                    .frame(width: 40, height: 120)
                VStack(alignment: .leading) {
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
                            
                        }
                        VStack {
                            AsyncImage(url: URL(string: playerSummonerSpell1Url)) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 30, height: 30)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(.rect(cornerRadii: .init(topLeading: 8, bottomLeading: 8, bottomTrailing: 8, topTrailing: 8)))
                            AsyncImage(url: URL(string: playerSummonerSpell2Url)) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 30, height: 30)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(.rect(cornerRadii: .init(topLeading: 8, bottomLeading: 8, bottomTrailing: 8, topTrailing: 8)))
                        }
                        VStack {
                            AsyncImage(url: URL(string: primaryUrl)) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 30, height: 30)
                            .aspectRatio(contentMode: .fit)
                            .shadow(radius: 30)
                            .clipShape(Circle())
                            AsyncImage(url: URL(string: secondaryUrl)) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 20, height: 20)
                            .aspectRatio(contentMode: .fit)
                            .shadow(radius: 30)
                            .clipShape(Circle())
                        }//:VStack
                        VStack(alignment:.leading) {
                            
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
                                .font(.title)
                                Text("Participations aux frags")
                                    .foregroundStyle(.gray)
                            } else {
                                Text("N/A")
                            }
                        }
                    }
                    
                    HStack {
                        ForEach(playerItems, id: \.self) { item in
                            AsyncImage(url: URL(string: "https://ddragon.leagueoflegends.com/cdn/14.4.1/img/item/\(item?.description ?? "0").png")) { image in
                                image.resizable()
                            } placeholder: {
                                Rectangle()
                                    .fill(.gray)
                            }
                            .frame(width: 30, height: 30)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(.rect(cornerRadii: .init(topLeading: 8, bottomLeading: 8, bottomTrailing: 8, topTrailing: 8)))
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
            }
        }
    }//:ForEach
}//:List

#Preview {
    SingleView(playerPuuid: "mIuioPf36Oy2gr1BOHEzbxO0qS3f9Rn0JMKkE3e1Y1UNVMIZxfFv_nWZVtSF2Q-n9D9YRxMqnjlFFQ", playerName: "Akarin", matchId: "EUW1_6842921570")
}
