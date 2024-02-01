class RunesModel: ObservableObject {

    @Published var perks = [Perks] ()

    func fetchData() async {
        guard let url = "https://ddragon.leagueoflegends.com/cdn/10.16.1/data/en_US/runesReforged.json" else {
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
}