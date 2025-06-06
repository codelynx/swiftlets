import XCTest
@testable import SwiftletsHTML

final class HelpersTests: XCTestCase {
    func testForEach() {
        let items = ["Apple", "Banana", "Orange"]
        let list = UL {
            ForEach(items) { item in
                LI(item)
            }
        }
        
        let rendered = list.render()
        XCTAssertEqual(rendered, "<ul><li>Apple</li><li>Banana</li><li>Orange</li></ul>")
    }
    
    func testForEachWithIndex() {
        let items = ["First", "Second", "Third"]
        let list = OL {
            ForEachWithIndex(items) { index, item in
                LI("\(index + 1). \(item)")
            }
        }
        
        let rendered = list.render()
        XCTAssertTrue(rendered.contains("<li>1. First</li>"))
        XCTAssertTrue(rendered.contains("<li>2. Second</li>"))
        XCTAssertTrue(rendered.contains("<li>3. Third</li>"))
    }
    
    func testForEachRange() {
        let list = UL {
            ForEach(Array(1...3)) { number in
                LI("Item \(number)")
            }
        }
        
        let rendered = list.render()
        XCTAssertTrue(rendered.contains("<li>Item 1</li>"))
        XCTAssertTrue(rendered.contains("<li>Item 2</li>"))
        XCTAssertTrue(rendered.contains("<li>Item 3</li>"))
    }
    
    func testIfCondition() {
        let showContent = true
        let div = Div {
            If(showContent) {
                P("This is shown")
            }
            If(!showContent) {
                P("This is hidden")
            }
        }
        
        let rendered = div.render()
        XCTAssertTrue(rendered.contains("This is shown"))
        XCTAssertFalse(rendered.contains("This is hidden"))
    }
    
    func testIfElse() {
        let isLoggedIn = false
        let div = Div {
            If(isLoggedIn, then: {
                P("Welcome back!")
            }, else: {
                P("Please log in")
            })
        }
        
        let rendered = div.render()
        XCTAssertFalse(rendered.contains("Welcome back!"))
        XCTAssertTrue(rendered.contains("Please log in"))
    }
    
    func testFragment() {
        let fragment = Fragment {
            P("First paragraph")
            P("Second paragraph")
        }
        
        let rendered = fragment.render()
        XCTAssertEqual(rendered, "<p>First paragraph</p><p>Second paragraph</p>")
    }
    
    func testDetailsAndSummary() {
        let details = Details {
            Summary("Click to expand")
            P("Hidden content")
        }
        
        let rendered = details.render()
        XCTAssertTrue(rendered.contains("<details>"))
        XCTAssertTrue(rendered.contains("<summary>Click to expand</summary>"))
        XCTAssertTrue(rendered.contains("<p>Hidden content</p>"))
    }
    
    func testProgress() {
        let progress = Progress(value: 0.7, max: 1.0)
        let rendered = progress.render()
        XCTAssertTrue(rendered.contains(#"value="0.7""#))
        XCTAssertTrue(rendered.contains(#"max="1.0""#))
    }
    
    func testTextFormatting() {
        let text = P {
            Text("The ")
            Abbr("HTML", title: "HyperText Markup Language")
            Text(" element ")
            Kbd("Ctrl+C")
            Text(" shows ")
            Var("x")
            Text(" = 2")
            Sup("2")
            Text(" and H")
            Sub("2")
            Text("O.")
        }
        
        let rendered = text.render()
        XCTAssertTrue(rendered.contains(#"<abbr title="HyperText Markup Language">HTML</abbr>"#))
        XCTAssertTrue(rendered.contains("<kbd>Ctrl+C</kbd>"))
        XCTAssertTrue(rendered.contains("<var>x</var>"))
        XCTAssertTrue(rendered.contains("<sup>2</sup>"))
        XCTAssertTrue(rendered.contains("<sub>2</sub>"))
    }
}