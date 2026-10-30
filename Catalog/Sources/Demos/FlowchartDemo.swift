import BeautifulUI
import SwiftUI

/// `-state selected` selects the trigger.
struct FlowchartDemo: View {
    @Environment(\.demoState) private var demoState

    static let properties = ["flavor", "topping", "size", "scoops"].map { FlowChoice.Option($0) }

    var body: some View {
        Flowchart(nodes: [
            FlowNode(id: "trigger", kind: "Trigger", hue: Color(hex: 0x9A5CFF), width: 300,
                     body: .step(title: "New order created", caption: "Trigger when a new order is created")),
            FlowNode(id: "cond", kind: "If / Else", hue: Color(hex: 0xF09A2F), width: 356, body: .condition([
                FlowClause(
                    id: "1", conjunction: "If", source: "order",
                    property: FlowChoice(Self.properties, selected: "flavor"),
                    value: FlowChoice([.init("Rocky Road", tag: "Classic"), .init("Mint Chip", tag: "Classic"), .init("Pistachio", tag: "Seasonal"), .init("Bubblegum", tag: "Retro")],
                                      selected: "Rocky Road", dotted: true, menuWidth: 176, alignsTrailing: true)
                ),
                FlowClause(
                    id: "2", conjunction: "and", source: "order",
                    property: FlowChoice(Self.properties, selected: "topping"),
                    value: FlowChoice([.init("Brown butter bourbon brittle crunch"), .init("Rainbow sprinkles"), .init("Hot fudge"), .init("Candied pecans")],
                                      selected: "Brown butter bourbon brittle crunch", dotted: true, menuWidth: 256),
                    valueWraps: true
                ),
            ])),
        ], selected: demoState == "selected" ? "trigger" : nil)
    }
}
