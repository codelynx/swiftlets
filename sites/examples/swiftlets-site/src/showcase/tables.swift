import Foundation
import Swiftlets

@main
struct TablesShowcase {
    static func main() async throws {
        let request = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        
        let html = Html {
            Head {
                Title("Tables - Swiftlets Showcase")
                LinkElement(rel: "stylesheet", href: "/styles/main.css")
            }
            Body {
                // Navigation
                Div {
                    Div {
                        Link(href: "/", "Swiftlets")
                            .class("nav-brand")
                        Div {
                            Link(href: "/docs", "Documentation")
                            Link(href: "/showcase", "Showcase")
                                .class("active")
                            Link(href: "/about", "About")
                        }
                        .class("nav-links")
                    }
                    .class("nav-content")
                }
                .class("nav-container")
                
                // Header
                Div {
                    Div {
                        H1("Tables")
                        P("Data tables with various styles and structures")
                            .style("font-size", "1.25rem")
                            .style("color", "#6c757d")
                    }
                    .class("showcase-container")
                }
                .class("showcase-header")
                
                // Main content
                Div {
                    // Breadcrumb
                    Div {
                        Link(href: "/showcase", "← Back to Showcase")
                            .style("color", "#007bff")
                    }
                    .style("margin-bottom", "2rem")
                    
                    // Basic Table
                    CodeExample(
                        title: "Basic Table",
                        swift: """
Table {
    THead {
        TR {
            TH("Name")
            TH("Role")
            TH("Department")
        }
    }
    TBody {
        TR {
            TD("Alice Johnson")
            TD("Developer")
            TD("Engineering")
        }
        TR {
            TD("Bob Smith")
            TD("Designer")
            TD("Creative")
        }
        TR {
            TD("Carol White")
            TD("Manager")
            TD("Operations")
        }
    }
}
.class("table")
""",
                        html: """
<table class="table">
    <thead>
        <tr>
            <th>Name</th>
            <th>Role</th>
            <th>Department</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Alice Johnson</td>
            <td>Developer</td>
            <td>Engineering</td>
        </tr>
        <tr>
            <td>Bob Smith</td>
            <td>Designer</td>
            <td>Creative</td>
        </tr>
        <tr>
            <td>Carol White</td>
            <td>Manager</td>
            <td>Operations</td>
        </tr>
    </tbody>
</table>
""",
                        preview: {
                            Table {
                                THead {
                                    TR {
                                        TH("Name")
                                        TH("Role")
                                        TH("Department")
                                    }
                                }
                                TBody {
                                    TR {
                                        TD("Alice Johnson")
                                        TD("Developer")
                                        TD("Engineering")
                                    }
                                    TR {
                                        TD("Bob Smith")
                                        TD("Designer")
                                        TD("Creative")
                                    }
                                    TR {
                                        TD("Carol White")
                                        TD("Manager")
                                        TD("Operations")
                                    }
                                }
                            }
                            .class("table")
                        },
                        description: "Basic table structure with header and body."
                    ).render()
                    
                    // Table with Caption and Footer
                    CodeExample(
                        title: "Table with Caption and Footer",
                        swift: """
Table {
    Caption("Q4 2024 Sales Report")
    THead {
        TR {
            TH("Product")
            TH("Units Sold")
            TH("Revenue")
        }
    }
    TBody {
        TR {
            TD("Widget A")
            TD("1,234")
            TD("$12,340")
        }
        TR {
            TD("Widget B")
            TD("2,567")
            TD("$38,505")
        }
        TR {
            TD("Widget C")
            TD("892")
            TD("$17,840")
        }
    }
    TFoot {
        TR {
            TH("Total")
            TH("4,693")
            TH("$68,685")
        }
    }
}
.class("table")
""",
                        html: """
<table class="table">
    <caption>Q4 2024 Sales Report</caption>
    <thead>
        <tr>
            <th>Product</th>
            <th>Units Sold</th>
            <th>Revenue</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Widget A</td>
            <td>1,234</td>
            <td>$12,340</td>
        </tr>
        <tr>
            <td>Widget B</td>
            <td>2,567</td>
            <td>$38,505</td>
        </tr>
        <tr>
            <td>Widget C</td>
            <td>892</td>
            <td>$17,840</td>
        </tr>
    </tbody>
    <tfoot>
        <tr>
            <th>Total</th>
            <th>4,693</th>
            <th>$68,685</th>
        </tr>
    </tfoot>
</table>
""",
                        preview: {
                            Table {
                                Caption("Q4 2024 Sales Report")
                                THead {
                                    TR {
                                        TH("Product")
                                        TH("Units Sold")
                                        TH("Revenue")
                                    }
                                }
                                TBody {
                                    TR {
                                        TD("Widget A")
                                        TD("1,234")
                                        TD("$12,340")
                                    }
                                    TR {
                                        TD("Widget B")
                                        TD("2,567")
                                        TD("$38,505")
                                    }
                                    TR {
                                        TD("Widget C")
                                        TD("892")
                                        TD("$17,840")
                                    }
                                }
                                TFoot {
                                    TR {
                                        TH("Total")
                                        TH("4,693")
                                        TH("$68,685")
                                    }
                                }
                            }
                            .class("table")
                        },
                        description: "Table with caption for context and footer for summaries."
                    ).render()
                    
                    // Styled Table
                    CodeExample(
                        title: "Styled Table",
                        swift: """
Table {
    THead {
        TR {
            TH("Framework")
            TH("Language")
            TH("Type")
            TH("Status")
        }
    }
    TBody {
        TR {
            TD("Swiftlets")
            TD("Swift")
            TD("Server-side")
            TD {
                Span("Active")
                    .class("status-active")
            }
        }
        TR {
            TD("React")
            TD("JavaScript")
            TD("Frontend")
            TD {
                Span("Active")
                    .class("status-active")
            }
        }
        TR {
            TD("Django")
            TD("Python")
            TD("Full-stack")
            TD {
                Span("Active")
                    .class("status-active")
            }
        }
        TR {
            TD("Rails")
            TD("Ruby")
            TD("Full-stack")
            TD {
                Span("Pending")
                    .class("status-pending")
            }
        }
    }
}
.class("table-styled")

// Striped table variant
Table {
    THead {
        TR {
            TH("Name")
            TH("Email")
            TH("Role")
        }
    }
    TBody {
        TR {
            TD("John Doe")
            TD("john@example.com")
            TD("Admin")
        }
        TR {
            TD("Jane Smith")
            TD("jane@example.com")
            TD("Editor")
        }
        TR {
            TD("Bob Johnson")
            TD("bob@example.com")
            TD("Viewer")
        }
    }
}
.class("table table-striped")
""",
                        html: """
<table class="table-styled">
    <thead>
        <tr>
            <th>Framework</th>
            <th>Language</th>
            <th>Type</th>
            <th>Status</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Swiftlets</td>
            <td>Swift</td>
            <td>Server-side</td>
            <td><span class="status-active">Active</span></td>
        </tr>
        <tr>
            <td>React</td>
            <td>JavaScript</td>
            <td>Frontend</td>
            <td><span class="status-active">Active</span></td>
        </tr>
        <tr>
            <td>Django</td>
            <td>Python</td>
            <td>Full-stack</td>
            <td><span class="status-active">Active</span></td>
        </tr>
        <tr>
            <td>Rails</td>
            <td>Ruby</td>
            <td>Full-stack</td>
            <td><span class="status-pending">Pending</span></td>
        </tr>
    </tbody>
</table>

<table class="table table-striped">
    <thead>
        <tr>
            <th>Name</th>
            <th>Email</th>
            <th>Role</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>John Doe</td>
            <td>john@example.com</td>
            <td>Admin</td>
        </tr>
        <tr>
            <td>Jane Smith</td>
            <td>jane@example.com</td>
            <td>Editor</td>
        </tr>
        <tr>
            <td>Bob Johnson</td>
            <td>bob@example.com</td>
            <td>Viewer</td>
        </tr>
    </tbody>
</table>
""",
                        preview: {
                            Fragment {
                                Table {
                                    THead {
                                        TR {
                                            TH("Framework")
                                            TH("Language")
                                            TH("Type")
                                            TH("Status")
                                        }
                                    }
                                    TBody {
                                        TR {
                                            TD("Swiftlets")
                                            TD("Swift")
                                            TD("Server-side")
                                            TD {
                                                Span("Active")
                                                    .class("status-active")
                                            }
                                        }
                                        TR {
                                            TD("React")
                                            TD("JavaScript")
                                            TD("Frontend")
                                            TD {
                                                Span("Active")
                                                    .class("status-active")
                                            }
                                        }
                                        TR {
                                            TD("Django")
                                            TD("Python")
                                            TD("Full-stack")
                                            TD {
                                                Span("Active")
                                                    .class("status-active")
                                            }
                                        }
                                        TR {
                                            TD("Rails")
                                            TD("Ruby")
                                            TD("Full-stack")
                                            TD {
                                                Span("Pending")
                                                    .class("status-pending")
                                            }
                                        }
                                    }
                                }
                                .class("table-styled")
                                
                                Table {
                                    THead {
                                        TR {
                                            TH("Name")
                                            TH("Email")
                                            TH("Role")
                                        }
                                    }
                                    TBody {
                                        TR {
                                            TD("John Doe")
                                            TD("john@example.com")
                                            TD("Admin")
                                        }
                                        TR {
                                            TD("Jane Smith")
                                            TD("jane@example.com")
                                            TD("Editor")
                                        }
                                        TR {
                                            TD("Bob Johnson")
                                            TD("bob@example.com")
                                            TD("Viewer")
                                        }
                                    }
                                }
                                .class("table table-striped")
                            }
                        },
                        description: "Tables with custom styling for enhanced visual appeal."
                    ).render()
                    
                    // Responsive Table
                    CodeExample(
                        title: "Responsive Table",
                        swift: """
// Wrap table in responsive container
Div {
    Table {
        THead {
            TR {
                TH("Order ID")
                TH("Customer")
                TH("Product")
                TH("Quantity")
                TH("Price")
                TH("Total")
                TH("Status")
                TH("Date")
            }
        }
        TBody {
            TR {
                TD("#12345")
                TD("Alice Brown")
                TD("Premium Widget")
                TD("3")
                TD("$49.99")
                TD("$149.97")
                TD {
                    Span("Shipped")
                        .class("status-active")
                }
                TD("2025-01-15")
            }
            TR {
                TD("#12346")
                TD("Bob Green")
                TD("Standard Widget")
                TD("5")
                TD("$29.99")
                TD("$149.95")
                TD {
                    Span("Processing")
                        .class("status-pending")
                }
                TD("2025-01-16")
            }
        }
    }
    .class("table")
}
.class("table-responsive")
""",
                        html: """
<div class="table-responsive">
    <table class="table">
        <thead>
            <tr>
                <th>Order ID</th>
                <th>Customer</th>
                <th>Product</th>
                <th>Quantity</th>
                <th>Price</th>
                <th>Total</th>
                <th>Status</th>
                <th>Date</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>#12345</td>
                <td>Alice Brown</td>
                <td>Premium Widget</td>
                <td>3</td>
                <td>$49.99</td>
                <td>$149.97</td>
                <td><span class="status-active">Shipped</span></td>
                <td>2025-01-15</td>
            </tr>
            <tr>
                <td>#12346</td>
                <td>Bob Green</td>
                <td>Standard Widget</td>
                <td>5</td>
                <td>$29.99</td>
                <td>$149.95</td>
                <td><span class="status-pending">Processing</span></td>
                <td>2025-01-16</td>
            </tr>
        </tbody>
    </table>
</div>
""",
                        preview: {
                            Div {
                                Table {
                                    THead {
                                        TR {
                                            TH("Order ID")
                                            TH("Customer")
                                            TH("Product")
                                            TH("Quantity")
                                            TH("Price")
                                            TH("Total")
                                            TH("Status")
                                            TH("Date")
                                        }
                                    }
                                    TBody {
                                        TR {
                                            TD("#12345")
                                            TD("Alice Brown")
                                            TD("Premium Widget")
                                            TD("3")
                                            TD("$49.99")
                                            TD("$149.97")
                                            TD {
                                                Span("Shipped")
                                                    .class("status-active")
                                            }
                                            TD("2025-01-15")
                                        }
                                        TR {
                                            TD("#12346")
                                            TD("Bob Green")
                                            TD("Standard Widget")
                                            TD("5")
                                            TD("$29.99")
                                            TD("$149.95")
                                            TD {
                                                Span("Processing")
                                                    .class("status-pending")
                                            }
                                            TD("2025-01-16")
                                        }
                                    }
                                }
                                .class("table")
                            }
                            .class("table-responsive")
                        },
                        description: "Responsive table that scrolls horizontally on small screens."
                    ).render()
                    
                    // Complex Table with Spanning Cells
                    CodeExample(
                        title: "Table with Spanning Cells",
                        swift: """
Table {
    Caption("Performance Metrics by Quarter")
    THead {
        TR {
            TH("")
            TH("Q1")
                .attribute("colspan", "2")
                .style("background-color", "#e8f4f8")
            TH("Q2")
                .attribute("colspan", "2")
                .style("background-color", "#f8e8e8")
        }
        TR {
            TH("Metric")
                .style("background-color", "#f0f0f0")
            TH("Target")
                .style("background-color", "#e8f4f8")
            TH("Actual")
                .style("background-color", "#e8f4f8")
            TH("Target")
                .style("background-color", "#f8e8e8")
            TH("Actual")
                .style("background-color", "#f8e8e8")
        }
    }
    TBody {
        TR {
            TH("Revenue")
                .style("background-color", "#f0f0f0")
            TD("$100K")
            TD("$95K")
            TD("$110K")
            TD("$125K")
        }
        TR {
            TH("Users")
                .style("background-color", "#f0f0f0")
            TD("1,000")
            TD("1,200")
            TD("1,500")
            TD("1,800")
        }
        TR {
            TH("Conversion")
                .style("background-color", "#f0f0f0")
            TD("2.5%")
            TD("2.3%")
            TD("3.0%")
            TD("3.5%")
        }
    }
}
.class("table")
.style("border", "1px solid #ddd")
""",
                        html: """
<table class="table" style="border: 1px solid #ddd;">
    <caption>Performance Metrics by Quarter</caption>
    <thead>
        <tr>
            <th></th>
            <th colspan="2" style="background-color: #e8f4f8;">Q1</th>
            <th colspan="2" style="background-color: #f8e8e8;">Q2</th>
        </tr>
        <tr>
            <th style="background-color: #f0f0f0;">Metric</th>
            <th style="background-color: #e8f4f8;">Target</th>
            <th style="background-color: #e8f4f8;">Actual</th>
            <th style="background-color: #f8e8e8;">Target</th>
            <th style="background-color: #f8e8e8;">Actual</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <th style="background-color: #f0f0f0;">Revenue</th>
            <td>$100K</td>
            <td>$95K</td>
            <td>$110K</td>
            <td>$125K</td>
        </tr>
        <tr>
            <th style="background-color: #f0f0f0;">Users</th>
            <td>1,000</td>
            <td>1,200</td>
            <td>1,500</td>
            <td>1,800</td>
        </tr>
        <tr>
            <th style="background-color: #f0f0f0;">Conversion</th>
            <td>2.5%</td>
            <td>2.3%</td>
            <td>3.0%</td>
            <td>3.5%</td>
        </tr>
    </tbody>
</table>
""",
                        preview: {
                            Table {
                                Caption("Performance Metrics by Quarter")
                                THead {
                                    TR {
                                        TH("")
                                        TH("Q1")
                                            .attribute("colspan", "2")
                                            .style("background-color", "#e8f4f8")
                                        TH("Q2")
                                            .attribute("colspan", "2")
                                            .style("background-color", "#f8e8e8")
                                    }
                                    TR {
                                        TH("Metric")
                                            .style("background-color", "#f0f0f0")
                                        TH("Target")
                                            .style("background-color", "#e8f4f8")
                                        TH("Actual")
                                            .style("background-color", "#e8f4f8")
                                        TH("Target")
                                            .style("background-color", "#f8e8e8")
                                        TH("Actual")
                                            .style("background-color", "#f8e8e8")
                                    }
                                }
                                TBody {
                                    TR {
                                        TH("Revenue")
                                            .style("background-color", "#f0f0f0")
                                        TD("$100K")
                                        TD("$95K")
                                        TD("$110K")
                                        TD("$125K")
                                    }
                                    TR {
                                        TH("Users")
                                            .style("background-color", "#f0f0f0")
                                        TD("1,000")
                                        TD("1,200")
                                        TD("1,500")
                                        TD("1,800")
                                    }
                                    TR {
                                        TH("Conversion")
                                            .style("background-color", "#f0f0f0")
                                        TD("2.5%")
                                        TD("2.3%")
                                        TD("3.0%")
                                        TD("3.5%")
                                    }
                                }
                            }
                            .class("table")
                            .style("border", "1px solid #ddd")
                        },
                        description: "Advanced table with spanning cells and styled columns."
                    ).render()
                }
                .class("showcase-container")
            }
        }
        
        let response = Response(
            status: 200,
            headers: ["Content-Type": "text/html; charset=utf-8"],
            body: html.render()
        )
        
        print(try JSONEncoder().encode(response).base64EncodedString())
    }
}