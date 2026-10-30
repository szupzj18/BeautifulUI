import SwiftUI

/// One component in the catalog, in the same order and with the same copy as beautifului.dev.
struct CatalogEntry: Identifiable {
    let id: String
    let number: String
    let title: String
    let subtitle: String
    var variants: [String] = []
    /// The demo for a variant; `nil` until the component is ported.
    var content: ((String) -> AnyView)?
}

@MainActor
enum Catalog {
    static let entries: [CatalogEntry] = [
        CatalogEntry(
            id: "loading-state", number: "01", title: "Loading State",
            subtitle: "Pixel-grid loader with shimmer and elapsed time.",
            variants: LoadingStateDemo.variants, content: { AnyView(LoadingStateDemo(variant: $0)) }
        ),
        CatalogEntry(
            id: "thinking-state", number: "02", title: "Thinking",
            subtitle: "Expandable traces — steps, reasoning, search, coding.",
            variants: ThinkingDemo.variants, content: { AnyView(ThinkingDemo(variant: $0)) }
        ),
        CatalogEntry(
            id: "streaming-text", number: "03", title: "Streaming Text",
            subtitle: "Streamed answer with inline sources, actions, and follow-ups.",
            content: { _ in AnyView(StreamingTextDemo()) }
        ),
        CatalogEntry(
            id: "approval-card", number: "04", title: "Approval Card",
            subtitle: "Human-in-the-loop questions the agent asks before acting.",
            content: { _ in AnyView(ApprovalCardDemo()) }
        ),
        CatalogEntry(
            id: "tool-chips", number: "05", title: "Tool Chips",
            subtitle: "Code edits and tool calls as compact chips.",
            content: { _ in AnyView(ToolChipsDemo()) }
        ),
        CatalogEntry(
            id: "task-rows", number: "06", title: "Task Rows",
            subtitle: "Live agent task status — running, failed, completed.",
            variants: TaskRowsDemo.variants, content: { AnyView(TaskRowsDemo(variant: $0)) }
        ),
        CatalogEntry(
            id: "chat-composer", number: "07", title: "Chat",
            subtitle: "Tabbed chat panel with reasoning replies and a composer.",
            content: { _ in AnyView(ChatDemo()) }
        ),
        CatalogEntry(
            id: "prompt-bar", number: "08", title: "Prompt Bar",
            subtitle: "Composer with @ sources, / commands, model picker, and dictation.",
            variants: PromptBarDemo.variants, content: { AnyView(PromptBarDemo(variant: $0)) }
        ),
        CatalogEntry(
            id: "recommendation-card", number: "09", title: "Recommendation Card",
            subtitle: "Agent suggestion with a confidence meter and actions.",
            content: { _ in AnyView(RecommendationCardDemo()) }
        ),
        CatalogEntry(
            id: "context-cards", number: "10", title: "Context Cards",
            subtitle: "Retrieved knowledge chunks with their sources.",
            content: { _ in AnyView(ContextCardsDemo()) }
        ),
        CatalogEntry(
            id: "diff-table", number: "11", title: "Diff Table",
            subtitle: "AI-proposed edits sweeping through tabular data.",
            content: { _ in AnyView(DiffTableDemo()) }
        ),
        CatalogEntry(
            id: "records-table", number: "12", title: "Records Table",
            subtitle: "CRM-style grid with tags, sorting, and relationship status.",
            content: { _ in AnyView(RecordsTableDemo()) }
        ),
        CatalogEntry(
            id: "filter-table", number: "13", title: "Filter Table",
            subtitle: "Status chips that reorganize live data.",
            content: { _ in AnyView(FilterTableDemo()) }
        ),
        CatalogEntry(
            id: "sidebar-nav", number: "14", title: "Sidebar Nav",
            subtitle: "Collapsible workspace and chat navigation with gliding hover states.",
            content: { _ in AnyView(SidebarNavDemo()) }
        ),
        CatalogEntry(
            id: "search", number: "15", title: "Search",
            subtitle: "Command search with live filtering and an empty state.",
            content: { _ in AnyView(SearchDemo()) }
        ),
        CatalogEntry(
            id: "flowchart", number: "16", title: "Flowchart",
            subtitle: "Workflow trigger and condition steps on a dotted canvas.",
            content: { _ in AnyView(FlowchartDemo()) }
        ),
        CatalogEntry(
            id: "insight-cards", number: "17", title: "Insight Cards",
            subtitle: "Paged agent insights with scrub-ready live charts.",
            content: { _ in AnyView(InsightCardsDemo()) }
        ),
        CatalogEntry(
            id: "code-block", number: "18", title: "Code Block",
            subtitle: "A line-numbered listing and a unified diff.",
            variants: CodeBlockDemo.variants, content: { AnyView(CodeBlockDemo(variant: $0)) }
        ),
        CatalogEntry(
            id: "fine-tune-card", number: "19", title: "Fine-tune Card",
            subtitle: "The agent adjusts design properties in an inspector.",
            content: { _ in AnyView(FineTuneCardDemo()) }
        ),
        CatalogEntry(
            id: "selection-actions", number: "20", title: "Selection Actions",
            subtitle: "Highlight a passage and hand it to the agent to rewrite.",
            content: { _ in AnyView(SelectionActionsDemo()) }
        ),
        CatalogEntry(id: "agent-screen", number: "21", title: "Agent Screen", subtitle: "Watch an agent's screen — open, teach a task, record."),
    ]

    static var portedCount: Int { entries.filter { $0.content != nil }.count }

    static func entry(_ id: String) -> CatalogEntry? {
        entries.first { $0.id == id }
    }
}
