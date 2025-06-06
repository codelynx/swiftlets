import XCTest
@testable import SwiftletsHTML

final class FormElementsTests: XCTestCase {
    func testBasicForm() {
        let form = Form(action: "/submit", method: "POST") {
            Input(type: "text", name: "username", placeholder: "Enter username")
            Input(type: "password", name: "password", placeholder: "Enter password")
            Button("Submit", type: "submit")
        }
        
        let rendered = form.render()
        XCTAssertTrue(rendered.contains(#"<form action="/submit" method="POST">"#))
        XCTAssertTrue(rendered.contains(#"<input type="text" name="username" placeholder="Enter username">"#))
        XCTAssertTrue(rendered.contains(#"<button type="submit">Submit</button>"#))
    }
    
    func testFormWithLabels() {
        let form = Form(action: "/signup") {
            Label("Email:", for: "email")
            Input(type: "email", name: "email")
            
            Label("Password:", for: "password")
            Input(type: "password", name: "password")
        }
        
        let rendered = form.render()
        XCTAssertTrue(rendered.contains(#"<label for="email">Email:</label>"#))
        XCTAssertTrue(rendered.contains(#"<input type="email" name="email">"#))
    }
    
    func testTextArea() {
        let textarea = TextArea(
            name: "message",
            rows: 5,
            cols: 40,
            placeholder: "Enter your message",
            content: "Default content"
        )
        
        let rendered = textarea.render()
        XCTAssertTrue(rendered.contains(#"<textarea name="message" rows="5" cols="40" placeholder="Enter your message">Default content</textarea>"#))
    }
    
    func testSelect() {
        let select = Select(name: "country") {
            Option("United States", value: "us")
            Option("Canada", value: "ca", selected: true)
            Option("Mexico", value: "mx")
        }
        
        let rendered = select.render()
        XCTAssertTrue(rendered.contains(#"<select name="country">"#))
        XCTAssertTrue(rendered.contains(#"<option value="us">United States</option>"#))
        XCTAssertTrue(rendered.contains(#"<option value="ca" selected="selected">Canada</option>"#))
    }
    
    func testFieldSet() {
        let fieldset = FieldSet {
            Legend("Personal Information")
            Label("Name:", for: "name")
            Input(type: "text", name: "name")
            Label("Email:", for: "email")
            Input(type: "email", name: "email")
        }
        
        let rendered = fieldset.render()
        XCTAssertTrue(rendered.contains("<fieldset>"))
        XCTAssertTrue(rendered.contains("<legend>Personal Information</legend>"))
    }
    
    func testInputTypes() {
        let checkbox = Input(type: "checkbox", name: "agree", value: "yes")
        XCTAssertTrue(checkbox.render().contains(#"type="checkbox""#))
        
        let radio = Input(type: "radio", name: "color", value: "red")
        XCTAssertTrue(radio.render().contains(#"type="radio""#))
        
        let file = Input(type: "file", name: "upload")
        XCTAssertTrue(file.render().contains(#"type="file""#))
    }
}