import Foundation

@main
struct Benchmark {
    static func main() async throws {
        let _ = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        
        let startTime = Date()
        
        // Generate a large table
        let rows = (1...1000).map { i in
            TR {
                TD("Row \(i), Col 1")
                TD("Row \(i), Col 2") 
                TD("Row \(i), Col 3")
                TD("Row \(i), Col 4")
                TD("Row \(i), Col 5")
            }
        }
        
        let html = Html {
            Head { 
                Title("Benchmark Test")
                Meta(name: "charset", content: "utf-8")
            }
            Body {
                H1("Performance Benchmark")
                P("Rendering 1000 table rows")
                
                Table {
                    THead {
                        TR {
                            TH("Column 1")
                            TH("Column 2")
                            TH("Column 3")
                            TH("Column 4")
                            TH("Column 5")
                        }
                    }
                    TBody {
                        ForEach(rows) { row in
                            row
                        }
                    }
                }
                
                P("Render time: \(Date().timeIntervalSince(startTime)) seconds")
            }
        }
        
        let response = Response(html: html.render())
        let jsonData = try JSONEncoder().encode(response)
        FileHandle.standardOutput.write(jsonData)
    }
}