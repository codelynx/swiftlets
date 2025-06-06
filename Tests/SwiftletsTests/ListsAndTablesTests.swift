import XCTest
@testable import Swiftlets

final class ListsAndTablesTests: XCTestCase {
    func testUnorderedList() {
        let list = UL {
            LI("Apple")
            LI("Banana")
            LI("Orange")
        }
        
        let rendered = list.render()
        XCTAssertEqual(rendered, "<ul><li>Apple</li><li>Banana</li><li>Orange</li></ul>")
    }
    
    func testOrderedList() {
        let list = OL {
            LI("First step")
            LI("Second step")
            LI("Third step")
        }
        
        let rendered = list.render()
        XCTAssertEqual(rendered, "<ol><li>First step</li><li>Second step</li><li>Third step</li></ol>")
    }
    
    func testNestedLists() {
        let list = UL {
            LI("Fruits")
            UL {
                LI("Apple")
                LI("Banana")
            }
            LI("Vegetables")
            UL {
                LI("Carrot")
                LI("Broccoli")
            }
        }
        
        let rendered = list.render()
        XCTAssertTrue(rendered.contains("<ul><li>Fruits</li><ul><li>Apple</li>"))
    }
    
    func testDefinitionList() {
        let list = DL {
            DT("HTML")
            DD("HyperText Markup Language")
            DT("CSS")
            DD("Cascading Style Sheets")
        }
        
        let rendered = list.render()
        XCTAssertTrue(rendered.contains("<dl>"))
        XCTAssertTrue(rendered.contains("<dt>HTML</dt>"))
        XCTAssertTrue(rendered.contains("<dd>HyperText Markup Language</dd>"))
    }
    
    func testBasicTable() {
        let table = Table {
            THead {
                TR {
                    TH("Name")
                    TH("Age")
                }
            }
            TBody {
                TR {
                    TD("Alice")
                    TD("30")
                }
                TR {
                    TD("Bob")
                    TD("25")
                }
            }
        }
        
        let rendered = table.render()
        XCTAssertTrue(rendered.contains("<table>"))
        XCTAssertTrue(rendered.contains("<thead>"))
        XCTAssertTrue(rendered.contains("<tbody>"))
        XCTAssertTrue(rendered.contains("<th>Name</th>"))
        XCTAssertTrue(rendered.contains("<td>Alice</td>"))
    }
    
    func testTableWithCaption() {
        let table = Table {
            Caption("User Data")
            TR {
                TH("ID")
                TH("Name")
            }
            TR {
                TD("1")
                TD("John")
            }
        }
        
        let rendered = table.render()
        XCTAssertTrue(rendered.contains("<caption>User Data</caption>"))
    }
}