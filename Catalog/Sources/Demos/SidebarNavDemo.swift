import BeautifulUI
import SwiftUI

/// `-state collapsed`, `-state workspace` and `-state search` open in those states.
struct SidebarNavDemo: View {
    @Environment(\.demoState) private var demoState

    var body: some View {
        SidebarNav(
            workspace: "Creamery Ops",
            items: [
                SidebarItem(id: "home", label: "Home", symbol: "house"),
                SidebarItem(id: "invite", label: "Invite users", symbol: "person.badge.plus", count: "3/10"),
            ],
            recents: [
                SidebarRecent(id: "suppliers", label: "Supplier records"),
                SidebarRecent(id: "todos", label: "Urgent to-dos this morning"),
                SidebarRecent(id: "flavor", label: "Flavor page ticket"),
                SidebarRecent(id: "workload", label: "Workload summary"),
                SidebarRecent(id: "offboarding", label: "Off-board a supplier"),
                SidebarRecent(id: "restock", label: "Batch restock function"),
                SidebarRecent(id: "edits", label: "Propose flavor edits"),
                SidebarRecent(id: "subway", label: "Subway surfing"),
            ],
            collapsed: demoState == "collapsed",
            showsWorkspaceMenu: demoState == "workspace",
            showsSearch: demoState == "search"
        )
        .frame(height: 600)
    }
}
