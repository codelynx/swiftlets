import XCTest
@testable import SwiftletsHTML

final class LayoutTests: XCTestCase {
    
    func testHStack() {
        let stack = HStack {
            Text("Item 1")
            Text("Item 2")
            Text("Item 3")
        }
        
        let html = stack.render()
        XCTAssertTrue(html.contains("display: flex"))
        XCTAssertTrue(html.contains("flex-direction: row"))
        XCTAssertTrue(html.contains("align-items: center"))
        XCTAssertTrue(html.contains("Item 1"))
        XCTAssertTrue(html.contains("Item 2"))
        XCTAssertTrue(html.contains("Item 3"))
    }
    
    func testHStackWithSpacing() {
        let stack = HStack(spacing: 20) {
            Text("A")
            Text("B")
        }
        
        let html = stack.render()
        XCTAssertTrue(html.contains("gap: 20px"))
    }
    
    func testHStackAlignment() {
        let stackTop = HStack(alignment: .top) {
            Text("Top")
        }
        XCTAssertTrue(stackTop.render().contains("align-items: flex-start"))
        
        let stackBottom = HStack(alignment: .bottom) {
            Text("Bottom")
        }
        XCTAssertTrue(stackBottom.render().contains("align-items: flex-end"))
        
        let stackStretch = HStack(alignment: .stretch) {
            Text("Stretch")
        }
        XCTAssertTrue(stackStretch.render().contains("align-items: stretch"))
    }
    
    func testVStack() {
        let stack = VStack {
            Text("Row 1")
            Text("Row 2")
            Text("Row 3")
        }
        
        let html = stack.render()
        XCTAssertTrue(html.contains("display: flex"))
        XCTAssertTrue(html.contains("flex-direction: column"))
        XCTAssertTrue(html.contains("align-items: stretch"))
        XCTAssertTrue(html.contains("Row 1"))
        XCTAssertTrue(html.contains("Row 2"))
        XCTAssertTrue(html.contains("Row 3"))
    }
    
    func testVStackAlignment() {
        let stackLeading = VStack(alignment: .leading) {
            Text("Leading")
        }
        XCTAssertTrue(stackLeading.render().contains("align-items: flex-start"))
        
        let stackCenter = VStack(alignment: .center) {
            Text("Center")
        }
        XCTAssertTrue(stackCenter.render().contains("align-items: center"))
        
        let stackTrailing = VStack(alignment: .trailing) {
            Text("Trailing")
        }
        XCTAssertTrue(stackTrailing.render().contains("align-items: flex-end"))
    }
    
    func testZStack() {
        let stack = ZStack {
            Text("Background")
            Text("Foreground")
        }
        
        let html = stack.render()
        XCTAssertTrue(html.contains("position: relative"))
        XCTAssertTrue(html.contains("display: flex"))
        XCTAssertTrue(html.contains("justify-content: center"))
        XCTAssertTrue(html.contains("align-items: center"))
    }
    
    func testZStackAlignment() {
        let stackTopLeading = ZStack(alignment: .topLeading) {
            Text("TL")
        }
        let html = stackTopLeading.render()
        XCTAssertTrue(html.contains("justify-content: flex-start"))
        XCTAssertTrue(html.contains("align-items: flex-start"))
        
        let stackBottomTrailing = ZStack(alignment: .bottomTrailing) {
            Text("BR")
        }
        let html2 = stackBottomTrailing.render()
        XCTAssertTrue(html2.contains("justify-content: flex-end"))
        XCTAssertTrue(html2.contains("align-items: flex-end"))
    }
    
    func testSpacer() {
        let spacer = Spacer()
        let html = spacer.render()
        XCTAssertTrue(html.contains("flex-grow: 1"))
        XCTAssertTrue(html.contains("<div"))
        XCTAssertTrue(html.contains("></div>"))
    }
    
    func testSpacerWithMinLength() {
        let spacer = Spacer(minLength: 50)
        let html = spacer.render()
        XCTAssertTrue(html.contains("flex-grow: 1"))
        XCTAssertTrue(html.contains("min-width: 50px"))
        XCTAssertTrue(html.contains("min-height: 50px"))
    }
    
    func testGrid() {
        let grid = Grid(columns: .count(3)) {
            Text("Cell 1")
            Text("Cell 2")
            Text("Cell 3")
        }
        
        let html = grid.render()
        XCTAssertTrue(html.contains("display: grid"))
        XCTAssertTrue(html.contains("grid-template-columns: repeat(3, 1fr)"))
    }
    
    func testGridWithRowsAndSpacing() {
        let grid = Grid(
            columns: .count(2),
            rows: .fixed(100),
            spacing: 10
        ) {
            Text("A")
            Text("B")
        }
        
        let html = grid.render()
        XCTAssertTrue(html.contains("grid-template-columns: repeat(2, 1fr)"))
        XCTAssertTrue(html.contains("grid-template-rows: 100px"))
        XCTAssertTrue(html.contains("gap: 10px"))
    }
    
    func testGridTrackTypes() {
        XCTAssertEqual(GridTrack.count(4).cssValue, "repeat(4, 1fr)")
        XCTAssertEqual(GridTrack.fixed(200).cssValue, "200px")
        XCTAssertEqual(GridTrack.flexible(min: 100, max: 300).cssValue, "minmax(100px, 300px)")
        XCTAssertEqual(GridTrack.fractional(2).cssValue, "2fr")
        XCTAssertEqual(GridTrack.auto.cssValue, "auto")
        XCTAssertEqual(GridTrack.custom("1fr 2fr").cssValue, "1fr 2fr")
    }
    
    func testGridTrackHelpers() {
        let columns = GridTrack.columns(.fixed(100), .fractional(1), .auto)
        XCTAssertEqual(columns.cssValue, "100px 1fr auto")
        
        let rows = GridTrack.rows(.count(3), .fixed(50))
        XCTAssertEqual(rows.cssValue, "repeat(3, 1fr) 50px")
    }
    
    func testContainer() {
        let container = Container {
            Text("Content")
        }
        
        let html = container.render()
        XCTAssertTrue(html.contains("max-width: 1024px"))
        XCTAssertTrue(html.contains("margin-left: auto"))
        XCTAssertTrue(html.contains("margin-right: auto"))
        XCTAssertTrue(html.contains("width: 100%"))
    }
    
    func testContainerWidths() {
        let small = Container(maxWidth: .small) { Text("S") }
        XCTAssertTrue(small.render().contains("max-width: 640px"))
        
        let medium = Container(maxWidth: .medium) { Text("M") }
        XCTAssertTrue(medium.render().contains("max-width: 768px"))
        
        let xl = Container(maxWidth: .xl) { Text("XL") }
        XCTAssertTrue(xl.render().contains("max-width: 1280px"))
        
        let full = Container(maxWidth: .full) { Text("Full") }
        XCTAssertTrue(full.render().contains("max-width: 100%"))
        
        let custom = Container(maxWidth: .custom(900)) { Text("Custom") }
        XCTAssertTrue(custom.render().contains("max-width: 900px"))
    }
    
    func testContainerWithPadding() {
        let container = Container(padding: 24) {
            Text("Padded content")
        }
        
        let html = container.render()
        XCTAssertTrue(html.contains("padding-left: 24px"))
        XCTAssertTrue(html.contains("padding-right: 24px"))
    }
    
    func testComplexLayout() {
        let layout = Container(maxWidth: .large, padding: 20) {
            VStack(spacing: 16) {
                Text("Header")
                
                HStack(alignment: .top, spacing: 24) {
                    Text("Left")
                    Spacer()
                    Text("Right")
                }
                
                Grid(columns: .count(3), spacing: 12) {
                    ForEach(1...6) { i in
                        Text("Item \(i)")
                    }
                }
            }
        }
        
        let html = layout.render()
        XCTAssertTrue(html.contains("max-width: 1024px"))
        XCTAssertTrue(html.contains("gap: 16px"))
        XCTAssertTrue(html.contains("gap: 24px"))
        XCTAssertTrue(html.contains("flex-grow: 1"))
        XCTAssertTrue(html.contains("grid-template-columns: repeat(3, 1fr)"))
    }
}