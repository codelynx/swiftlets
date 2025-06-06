import XCTest
@testable import SwiftletsHTML

final class BasicElementsTests: XCTestCase {
    func testTextElement() {
        let text = Text("Hello, World!")
        XCTAssertEqual(text.render(), "Hello, World!")
        
        let textWithSpecialChars = Text("<script>alert('xss')</script>")
        XCTAssertEqual(textWithSpecialChars.render(), "&lt;script&gt;alert('xss')&lt;/script&gt;")
    }
    
    func testDivElement() {
        let div = Div {
            Text("Content")
        }
        XCTAssertEqual(div.render(), "<div>Content</div>")
    }
    
    func testHeadingElements() {
        let h1 = H1("Title")
        XCTAssertEqual(h1.render(), "<h1>Title</h1>")
        
        let h2 = H2 {
            Text("Subtitle with ")
            Text("multiple parts")
        }
        XCTAssertEqual(h2.render(), "<h2>Subtitle with multiple parts</h2>")
    }
    
    func testParagraph() {
        let p = P("This is a paragraph.")
        XCTAssertEqual(p.render(), "<p>This is a paragraph.</p>")
    }
    
    func testLink() {
        let link = A(href: "https://example.com", "Click here")
        XCTAssertEqual(link.render(), #"<a href="https://example.com">Click here</a>"#)
    }
    
    func testModifiers() {
        let styledDiv = Div {
            Text("Styled content")
        }
        .id("main")
        .class("container")
        .padding(20)
        .background("#f0f0f0")
        
        let rendered = styledDiv.render()
        XCTAssertTrue(rendered.contains(#"id="main""#))
        XCTAssertTrue(rendered.contains(#"class="container""#))
        XCTAssertTrue(rendered.contains(#"style=""#))
        XCTAssertTrue(rendered.contains("padding: 20px"))
        XCTAssertTrue(rendered.contains("background-color: #f0f0f0"))
    }
    
    func testConditionalRendering() {
        let showContent = true
        let div = Div {
            H1("Title")
            if showContent {
                P("This content is shown")
            } else {
                P("This content is hidden")
            }
        }
        
        let rendered = div.render()
        XCTAssertTrue(rendered.contains("This content is shown"))
        XCTAssertFalse(rendered.contains("This content is hidden"))
    }
    
    func testArrayRendering() {
        let items = ["Apple", "Banana", "Orange"]
        let list = Div {
            for item in items {
                P(item)
            }
        }
        
        let rendered = list.render()
        XCTAssertEqual(rendered, "<div><p>Apple</p><p>Banana</p><p>Orange</p></div>")
    }
    
    func testCompleteDocument() {
        let page = Html {
            Head {
                Meta(charset: "utf-8")
                Title("My Page")
            }
            Body {
                Div {
                    H1("Welcome")
                        .class("title")
                    P("This is a test page using SwiftletsHTML DSL.")
                        .foregroundColor("#333")
                }
                .class("container")
                .padding(40)
            }
        }
        
        let rendered = page.render()
        XCTAssertTrue(rendered.contains("<!DOCTYPE html>"))
        XCTAssertTrue(rendered.contains("<html>"))
        XCTAssertTrue(rendered.contains("<head>"))
        XCTAssertTrue(rendered.contains(#"<meta charset="utf-8">"#))
        XCTAssertTrue(rendered.contains("<title>My Page</title>"))
        XCTAssertTrue(rendered.contains("<body>"))
        XCTAssertTrue(rendered.contains(#"class="container""#))
    }
}