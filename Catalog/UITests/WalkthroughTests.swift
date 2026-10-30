import XCTest

/// Drives the Catalog for the recorded walkthrough (demo/walkthrough.mp4): every component in
/// dark with its main interactions, then three headline ones again in light.
final class WalkthroughTests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = true
    }

    @MainActor
    func testWalkthrough() {
        launch(theme: "dark")
        // The layout choice persists between launches; start the intro on the gallery.
        let gallery = app.buttons["Gallery"].firstMatch
        if gallery.waitForExistence(timeout: 2) { gallery.tap() }
        hold(2.0)
        app.swipeUp()
        hold(1.0)
        showList()

        open("Loading State") { hold(1.0); tap("Surfer"); hold(1.2) }
        next { hold(4.2) }                                   // Thinking
        next { hold(2.8); tap("10 sources"); hold(1.0) }      // Streaming Text
        next { approvalSteps() }                              // Approval Card
        next {                                                // Tool Chips
            hold(3.2); tap("Write 204 lines"); hold(0.8); tap("Show diff for ChurnSchedule.tsx"); hold(1.3)
        }
        next { hold(4.0) }                                    // Task Rows
        next {                                                // Chat
            hold(0.5)
            let field = app.textFields["Chat prompt"]
            field.tap(); field.typeText("Which flavors win in winter?")
            tap("Send"); hold(3.2)
        }
        next { hold(7.0) }                                    // Prompt Bar
        next { hold(0.6); tap("Alternatives"); hold(1.0) }    // Recommendation Card
        next { hold(1.3) }                                    // Context Cards
        next { hold(0.8); tap("Rocky Road"); hold(0.8) }      // Diff Table
        next { hold(0.8); app.scrollViews.element(boundBy: 1).swipeLeft(); hold(0.8) } // Records Table
        next { hold(0.6); tap("In Progress"); hold(0.8) }     // Filter Table
        next { hold(0.6); tap("Collapse sidebar"); hold(0.8) } // Sidebar Nav
        next { hold(1.1) }                                    // Search
        next { hold(0.6); tap("New order created"); hold(0.8) } // Flowchart
        next { hold(1.0); tap("Next insight"); hold(1.0) }    // Insight Cards
        next { hold(0.8); tap("Diff"); hold(1.0) }            // Code Block
        next { hold(0.6); tap("Select type"); hold(0.4); tap("Seasonal"); hold(0.7) } // Fine-tune Card
        next { hold(0.7); tap("Improve"); hold(2.8); tap("Keep"); hold(0.6) }         // Selection Actions
        next {                                                // Agent Screen
            hold(0.8); tap("Open Agent's screen"); hold(0.8); tap("Teach a task"); hold(1.5)
            tap("End"); hold(0.4); tap("Collapse"); hold(0.6)
        }

        app.terminate()
        launch(theme: "light", component: "thinking-state")
        hold(4.2)
        next { hold(0.3) }                                    // Streaming Text (passing through)
        next { approvalSteps() }                              // Approval Card
        app.terminate()
        launch(theme: "light", component: "prompt-bar")
        hold(10.8)
    }

    // MARK: Steps

    @MainActor
    private func approvalSteps() {
        hold(0.6)
        tap("Three (core line)"); hold(0.9)
        tap("Chocolate chips"); hold(0.2)
        tap("Sprinkles"); hold(0.3)
        tap("Continue"); hold(0.7)
        tap("Food trucks"); hold(1.3)
    }

    // MARK: Helpers

    @MainActor
    private func launch(theme: String, component: String? = nil) {
        app = XCUIApplication()
        app.launchArguments = ["-theme", theme] + (component.map { ["-component", $0] } ?? [])
        app.launch()
    }

    @MainActor
    private func showList() {
        let list = app.buttons["List"].firstMatch
        if list.waitForExistence(timeout: 2) { list.tap() }
        app.swipeDown()
        hold(0.5)
    }

    /// Opens a component from the list (scrolling it into view) and runs `steps`.
    @MainActor
    private func open(_ title: String, _ steps: () -> Void) {
        let row = app.staticTexts[title].firstMatch
        var tries = 0
        while !row.isHittable && tries < 8 {
            app.swipeUp(velocity: .slow)
            tries += 1
        }
        row.tap()
        steps()
    }

    /// Flips to the next component with the page's Next button and runs `steps`.
    @MainActor
    private func next(_ steps: () -> Void) {
        app.buttons["Next component"].firstMatch.tap()
        steps()
    }

    @MainActor
    private func tap(_ label: String) {
        // Many rows merge their texts into one button label, so fall back to the text
        // without waiting out a timeout first.
        let button = app.buttons[label].firstMatch
        let text = app.staticTexts[label].firstMatch
        if button.exists {
            button.tap()
        } else if text.exists {
            text.tap()
        } else if button.waitForExistence(timeout: 2) {
            button.tap()
        } else {
            text.tap()
        }
    }

    private func hold(_ seconds: Double) {
        Thread.sleep(forTimeInterval: seconds)
    }
}
