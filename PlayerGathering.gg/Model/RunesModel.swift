import Foundation

class RunesModel: ObservableObject {
    
    @Published var perks = [Perks] ()
    
    func primaryRune(for player: Info.Participants?) -> (Int, Int) {
        guard let player = player else { return (0, 0) }
        
        guard let primaryPerk = player.perks.styles.first?.style else { return (0, 0) }
        
        // Assuming player.perks is of type Info.Participants.Perks
        guard let primaryStyle = player.perks.styles.first?.selections.first?.perk else { return (0, 0) }
        
        // Assuming Perks.Styles has a description property
        return (primaryPerk, primaryStyle)
    }
    
    func secondaryRune(for player: Info.Participants?) -> Int {
        guard let player = player else { return 0 }
        
        // Assuming player.perks is of type Info.Participants.Perks
        let secondaryStyle = player.perks.styles[1].style
        
        // Assuming Perks.Styles has a description property
        return secondaryStyle
    }
    
    func fetchData() async {
        guard let url = URL(string: "https://ddragon.leagueoflegends.com/cdn/10.16.1/data/en_US/runesReforged.json") else {
            print("URL Invalide")
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    let decodeResponse = try JSONDecoder().decode([Perks].self, from: data)
                    DispatchQueue.main.async {
                        self.perks = decodeResponse
                    }//:async
                }//:do
                catch {
                    print("JSON Decoding error: \(error)")
                }//:catch
            } else {
                print("HTTP Error: Status code is not 200")
                print(url)
            }
        }//:do
        catch {
            print("Network Request error: \(error)")
        }
    }
    func fetchSecondaryRuneIcon(for runeID: Int) -> String? {
        // Search for the rune in the perks array
        for perk in perks {
            if(perk.id == runeID) {
                return perk.icon
            }
        }
        return nil // Return nil if rune with given ID is not found
    }
    func fetchPrimaryRuneIcon(for runeID: Int, for perkID: Int) -> String? {
        // Search for the rune in the perks array
        for perk in perks {
            print(perk.id)
            if(perk.id == perkID) {
                for slot in perk.slots {
                    for rune in slot.runes {
                        if rune.id == runeID {
                            return rune.icon
                        }
                    }
                }
            }
        }
        return nil // Return nil if rune with given ID is not found
    }
}
