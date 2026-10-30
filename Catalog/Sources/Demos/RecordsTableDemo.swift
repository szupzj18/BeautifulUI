import BeautifulUI
import SwiftUI

/// The original's 60 ice-cream suppliers. "+" adds an AI "Competitors" column that resolves
/// row by row; `-state ai` opens with it already filled in.
struct RecordsTableDemo: View {
    @Environment(\.demoState) private var demoState

    static let tagTints: [String: Color] = {
        let amber = Color(hex: 0xE5A14B), lime = Color(hex: 0xA3C33F), yellow = Color(hex: 0xD3C037)
        let purple = Color(hex: 0x8D6BE7), orange = Color(hex: 0xEF7E3C), cyan = Color(hex: 0x52B3D1)
        let red = Color(hex: 0xE95048), magenta = Color(hex: 0xCC5BDB), green = Color(hex: 0x3FB785), pink = Color(hex: 0xEE578A)
        return [
            "B2B": amber, "B2C": lime, "Cafe": red, "Catering": magenta, "Dairy-free": cyan, "Gelato": purple,
            "Imports": orange, "Local": green, "Seasonal": yellow, "Sorbet": pink, "Vegan": lime, "Wholesale": amber,
        ]
    }()

    static let competitors = ["Frost & Ladle", "Polar Pint Co.", "Meltwater Creamery", "Cirrus Scoops", "Golden Churn", "Velvet Freeze", "North Cone Collective", "Sundae Syndicate"]

    static let records: [RecordItem] = [
        RecordItem(id: "aurora", name: "Aurora Scoops — Reykjavík", tags: ["Gelato", "Seasonal"], lastInteraction: "9 days ago", strength: .strong, website: "aurora-scoops.example.com"),
        RecordItem(id: "kumo", name: "Kumo Creamery — Tokyo", tags: ["B2C", "Cafe", "Vegan"], lastInteraction: "3 weeks ago", strength: .strong, website: "kumo-creamery.example.com"),
        RecordItem(id: "sol-nieve", name: "Sol y Nieve — Buenos Aires", tags: ["Gelato", "Local"], lastInteraction: "2 months ago", strength: .weak, website: "sol-y-nieve.example.com"),
        RecordItem(id: "maple-orbit", name: "Maple Orbit — Montréal", tags: ["B2B", "Wholesale", "Seasonal"], lastInteraction: "15 days ago", strength: .weak, website: "maple-orbit.example.com"),
        RecordItem(id: "blue-fig", name: "Blue Fig Gelato — Florence", tags: ["Gelato", "Cafe"], lastInteraction: "over 1 year ago", strength: .veryWeak, website: "blue-fig.example.com"),
        RecordItem(id: "sahara-swirl", name: "Sahara Swirl — Marrakech", tags: ["Sorbet", "Local"], lastInteraction: "5 months ago", strength: .veryWeak),
        RecordItem(id: "cloudberry", name: "Cloudberry Cone — Helsinki", tags: ["Dairy-free", "Seasonal"], lastInteraction: "No contact", strength: .none, website: "cloudberry-cone.example.com"),
        RecordItem(id: "palm-sugar", name: "Palm Sugar Creamery — Bangkok", tags: ["B2C", "Vegan"], lastInteraction: "3 months ago", strength: .veryWeak, website: "palm-sugar.example.com"),
        RecordItem(id: "cape-vanilla", name: "Cape Vanilla Co. — Cape Town", tags: ["Wholesale", "Imports"], lastInteraction: "over 1 year ago", strength: .veryWeak, website: "cape-vanilla.example.com"),
        RecordItem(id: "andes-snow", name: "Andes Snow Creamery — Quito", tags: ["Gelato", "Catering"], lastInteraction: "almost 2 years ago", strength: .veryWeak),
        RecordItem(id: "tasman-sea", name: "Tasman Sea Gelato — Hobart", tags: ["Gelato", "Local"], lastInteraction: "2 months ago", strength: .weak, website: "tasman-sea.example.com"),
        RecordItem(id: "silk-road", name: "Silk Road Sorbet — Tbilisi", tags: ["Sorbet", "Imports"], lastInteraction: "about 1 month ago", strength: .weak, website: "silk-road.example.com"),
        RecordItem(id: "rosewater", name: "Rosewater Kulfi — Jaipur", tags: ["B2C", "Seasonal"], lastInteraction: "2 months ago", strength: .veryWeak),
        RecordItem(id: "lumen", name: "Lumen Soft Serve — Copenhagen", tags: ["Dairy-free", "Cafe"], lastInteraction: "8 months ago", strength: .weak, website: "lumen-soft-serve.example.com"),
        RecordItem(id: "cacao-norte", name: "Cacao Norte — Oaxaca", tags: ["B2B", "Local", "Wholesale"], lastInteraction: "about 2 years ago", strength: .none, website: "cacao-norte.example.com"),
        RecordItem(id: "pine-pistachio", name: "Pine & Pistachio — Istanbul", tags: ["Gelato", "Catering"], lastInteraction: "about 1 month ago", strength: .veryWeak),
        RecordItem(id: "ember-cone", name: "Ember Cone Company — Seoul", tags: ["B2C", "Vegan"], lastInteraction: "15 days ago", strength: .weak, website: "ember-cone.example.com"),
        RecordItem(id: "coral-coast", name: "Coral Coast Sorbet — Honolulu", tags: ["Sorbet", "Local"], lastInteraction: "9 days ago", strength: .strong, website: "coral-coast.example.com"),
        RecordItem(id: "sunbird", name: "Sunbird Gelateria — Lisbon", tags: ["Gelato", "Cafe"], lastInteraction: "over 2 years ago", strength: .none, website: "sunbird.example.com"),
        RecordItem(id: "mooncake", name: "Mooncake Ice Cream — Singapore", tags: ["B2B", "Wholesale"], lastInteraction: "about 1 month ago", strength: .veryWeak, website: "mooncake-ice-cream.example.com"),
        RecordItem(id: "juniper", name: "Juniper & Cream — Vancouver", tags: ["Dairy-free", "Catering"], lastInteraction: "No contact", strength: .none),
        RecordItem(id: "mango-moon", name: "Mango Moon Gelato — Nairobi", tags: ["Sorbet", "Vegan"], lastInteraction: "almost 2 years ago", strength: .veryWeak, website: "mango-moon.example.com"),
        RecordItem(id: "fjord-fizz", name: "Fjord Fizz Ice — Oslo", tags: ["Dairy-free", "Seasonal"], lastInteraction: "No contact", strength: .none),
        RecordItem(id: "pampa", name: "Pampa Creamery — Córdoba", tags: ["B2C", "Local"], lastInteraction: "12 months ago", strength: .veryWeak, website: "pampa-creamery.example.com"),
        RecordItem(id: "lotus-leaf", name: "Lotus Leaf Scoops — Hanoi", tags: ["Vegan", "Cafe"], lastInteraction: "15 days ago", strength: .weak),
        RecordItem(id: "saffron-sky", name: "Saffron Sky Kulfi — Dubai", tags: ["Imports", "Catering"], lastInteraction: "almost 2 years ago", strength: .veryWeak, website: "saffron-sky.example.com"),
        RecordItem(id: "alpine-churn", name: "Alpine Churn — Zürich", tags: ["B2B", "Gelato", "Wholesale"], lastInteraction: "4 days ago", strength: .strong, website: "alpine-churn.example.com"),
        RecordItem(id: "monsoon-mango", name: "Monsoon Mango — Mumbai", tags: ["Sorbet", "Vegan", "Catering"], lastInteraction: "18 days ago", strength: .weak, website: "monsoon-mango.example.com"),
        RecordItem(id: "cedar-spoon", name: "Cedar Spoon — Beirut", tags: ["Cafe", "Local", "Seasonal"], lastInteraction: "6 days ago", strength: .strong, website: "cedar-spoon.example.com"),
        RecordItem(id: "baltic-berry", name: "Baltic Berry — Tallinn", tags: ["Dairy-free", "Seasonal", "B2C"], lastInteraction: "5 weeks ago", strength: .weak, website: "baltic-berry.example.com"),
        RecordItem(id: "delta-dairy", name: "Delta Dairy Works — New Orleans", tags: ["B2B", "Wholesale", "Local"], lastInteraction: "2 days ago", strength: .strong, website: "delta-dairy.example.com"),
        RecordItem(id: "yuzu-yard", name: "Yuzu Yard — Kyoto", tags: ["Sorbet", "Cafe", "Seasonal"], lastInteraction: "11 days ago", strength: .strong, website: "yuzu-yard.example.com"),
        RecordItem(id: "copper-cone", name: "Copper Cone — Melbourne", tags: ["Gelato", "Cafe", "B2C"], lastInteraction: "about 1 month ago", strength: .weak, website: "copper-cone.example.com"),
        RecordItem(id: "mint-medina", name: "Mint Medina — Tunis", tags: ["Dairy-free", "Vegan", "Local"], lastInteraction: "No contact", strength: .none),
        RecordItem(id: "glacier-grove", name: "Glacier Grove — Anchorage", tags: ["Seasonal", "Local", "Catering"], lastInteraction: "7 weeks ago", strength: .weak, website: "glacier-grove.example.com"),
        RecordItem(id: "orchard-cloud", name: "Orchard Cloud — Lyon", tags: ["Gelato", "Seasonal", "Cafe"], lastInteraction: "5 days ago", strength: .strong, website: "orchard-cloud.example.com"),
        RecordItem(id: "tamarind-tide", name: "Tamarind Tide — Chennai", tags: ["Vegan", "Sorbet", "B2C"], lastInteraction: "9 months ago", strength: .veryWeak, website: "tamarind-tide.example.com"),
        RecordItem(id: "amber-scoop", name: "Amber Scoop — Prague", tags: ["Gelato", "B2B"], lastInteraction: "over 1 year ago", strength: .none),
        RecordItem(id: "boreal-batch", name: "Boreal Batch — Yellowknife", tags: ["Dairy-free", "Local", "Seasonal"], lastInteraction: "8 days ago", strength: .strong, website: "boreal-batch.example.com"),
        RecordItem(id: "coconut-commons", name: "Coconut Commons — Manila", tags: ["Vegan", "B2C", "Cafe"], lastInteraction: "24 days ago", strength: .weak, website: "coconut-commons.example.com"),
        RecordItem(id: "dolomite-dairy", name: "Dolomite Dairy — Bolzano", tags: ["Gelato", "Wholesale"], lastInteraction: "3 days ago", strength: .strong, website: "dolomite-dairy.example.com"),
        RecordItem(id: "equator-cream", name: "Equator Cream — Kampala", tags: ["B2B", "Catering", "Local"], lastInteraction: "10 months ago", strength: .veryWeak, website: "equator-cream.example.com"),
        RecordItem(id: "hibiscus-house", name: "Hibiscus House — Accra", tags: ["Sorbet", "Cafe"], lastInteraction: "6 weeks ago", strength: .weak, website: "hibiscus-house.example.com"),
        RecordItem(id: "lagoon-ladle", name: "Lagoon Ladle — Venice", tags: ["Gelato", "Seasonal", "Catering"], lastInteraction: "7 days ago", strength: .strong, website: "lagoon-ladle.example.com"),
        RecordItem(id: "midnight-milk", name: "Midnight Milk — Tromsø", tags: ["Dairy-free", "Vegan", "Wholesale"], lastInteraction: "No contact", strength: .none),
        RecordItem(id: "nomad-nougat", name: "Nomad Nougat — Ulaanbaatar", tags: ["Imports", "B2B"], lastInteraction: "almost 2 years ago", strength: .none, website: "nomad-nougat.example.com"),
        RecordItem(id: "olive-snow", name: "Olive Snow — Athens", tags: ["Gelato", "Cafe", "Local"], lastInteraction: "4 days ago", strength: .strong, website: "olive-snow.example.com"),
        RecordItem(id: "pacific-pear", name: "Pacific Pear — Valparaíso", tags: ["Sorbet", "Seasonal"], lastInteraction: "2 months ago", strength: .weak, website: "pacific-pear.example.com"),
        RecordItem(id: "quartz-cone", name: "Quartz Cone — Denver", tags: ["B2C", "Wholesale"], lastInteraction: "10 days ago", strength: .strong, website: "quartz-cone.example.com"),
        RecordItem(id: "red-lantern", name: "Red Lantern Creamery — Taipei", tags: ["Cafe", "Vegan"], lastInteraction: "about 1 month ago", strength: .weak, website: "red-lantern.example.com"),
        RecordItem(id: "salt-silk", name: "Salt & Silk — Muscat", tags: ["Imports", "Catering", "Gelato"], lastInteraction: "8 months ago", strength: .veryWeak, website: "salt-and-silk.example.com"),
        RecordItem(id: "tropic-churn", name: "Tropic Churn — San Juan", tags: ["Sorbet", "Local", "B2C"], lastInteraction: "6 days ago", strength: .strong, website: "tropic-churn.example.com"),
        RecordItem(id: "umber-cream", name: "Umber Cream — Warsaw", tags: ["B2B", "Wholesale", "Cafe"], lastInteraction: "5 weeks ago", strength: .weak, website: "umber-cream.example.com"),
        RecordItem(id: "vanilla-vale", name: "Vanilla Vale — Antananarivo", tags: ["Imports", "Local"], lastInteraction: "No contact", strength: .none),
        RecordItem(id: "willow-whip", name: "Willow Whip — Portland", tags: ["Dairy-free", "Vegan", "Cafe"], lastInteraction: "3 days ago", strength: .strong, website: "willow-whip.example.com"),
        RecordItem(id: "zenith-gelato", name: "Zenith Gelato — Auckland", tags: ["Gelato", "Seasonal"], lastInteraction: "3 weeks ago", strength: .weak, website: "zenith-gelato.example.com"),
        RecordItem(id: "apricot-atlas", name: "Apricot Atlas — Algiers", tags: ["Sorbet", "Imports"], lastInteraction: "11 months ago", strength: .veryWeak, website: "apricot-atlas.example.com"),
        RecordItem(id: "black-sesame", name: "Black Sesame Social — Bandung", tags: ["Vegan", "Cafe", "B2C"], lastInteraction: "9 days ago", strength: .strong, website: "black-sesame.example.com"),
        RecordItem(id: "crimson-clover", name: "Crimson Clover — Brussels", tags: ["Gelato", "Wholesale", "Catering"], lastInteraction: "2 months ago", strength: .weak, website: "crimson-clover.example.com"),
        RecordItem(id: "dragonfruit-dock", name: "Dragonfruit Dock — Shenzhen", tags: ["Sorbet", "B2B", "Wholesale"], lastInteraction: "No contact", strength: .none),
    ]

    var body: some View {
        RecordsTable(
            records: Self.records,
            tagTints: Self.tagTints,
            aiColumn: RecordsAIColumn(title: "Competitors", prompt: "Find competitors for Company.") { _, index in
                "\(Self.competitors[index % 8]), \(Self.competitors[(index + 3) % 8])"
            },
            showsAIColumn: demoState == "ai"
        )
    }
}
