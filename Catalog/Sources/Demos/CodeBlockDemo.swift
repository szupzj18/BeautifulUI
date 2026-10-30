import BeautifulUI
import SwiftUI

struct CodeBlockDemo: View {
    static let variants = ["Code", "Diff"]
    let variant: String

    var body: some View {
        if variant == "Diff" {
            CodeBlock(filename: "churn.ts", diff: [
                DiffRow(old: 1, new: 1, kind: .context, "export async function churnBatch() {"),
                DiffRow(old: 2, new: 2, kind: .context, "  const flavor = await getFlavor(\"pistachio\");"),
                DiffRow(old: 3, new: 3, kind: .context, "  const base = await dairy.fetch({ flavor });"),
                DiffRow(old: 4, new: nil, kind: .removed, pieces: [.init("  await freezer.store(base, { temp: "), .init("\"-14C\"", change: .removed), .init(" });")]),
                DiffRow(old: nil, new: 4, kind: .added, pieces: [.init("  await freezer.store(base, { temp: "), .init("\"-16C\"", change: .added), .init(" });")]),
                DiffRow(old: nil, new: 5, kind: .added, "  if (!base.approved) return null;"),
                DiffRow(old: 5, new: 6, kind: .context, "  return base.gallons;"),
                DiffRow(old: 6, new: 7, kind: .context, "}"),
            ])
        } else {
            CodeBlock(filename: "churn.ts", lines: [
                "export async function churnBatch() {",
                "  const flavor = await getFlavor(\"pistachio\");",
                "  const base = await dairy.fetch({ flavor });",
                "  await freezer.store(base, { temp: \"-16C\" });",
                "  if (!base.approved) return null;",
                "  return base.gallons;",
                "}",
            ])
        }
    }
}
