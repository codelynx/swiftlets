// Electronics-specific shared components

func electronicsSpecTable(specs: [(String, String)]) -> some HTMLElement {
    Table {
        THead {
            TR {
                TH("Specification")
                    .style("text-align", "left")
                    .style("padding", "0.5rem")
                    .style("border-bottom", "2px solid #4CAF50")
                TH("Value")
                    .style("text-align", "left")
                    .style("padding", "0.5rem")
                    .style("border-bottom", "2px solid #4CAF50")
            }
        }
        TBody {
            ForEach(specs) { spec in
                TR {
                    TD(spec.0)
                        .style("padding", "0.5rem")
                        .style("border-bottom", "1px solid #e0e0e0")
                    TD(spec.1)
                        .style("padding", "0.5rem")
                        .style("border-bottom", "1px solid #e0e0e0")
                        .style("font-weight", "600")
                }
            }
        }
    }
    .style("width", "100%")
    .style("border-collapse", "collapse")
    .style("margin", "1rem 0")
}

func warrantyBadge(years: Int) -> some HTMLElement {
    Div {
        Text("\(years)-Year Warranty")
            .style("background", "#4CAF50")
            .style("color", "white")
            .style("padding", "0.5rem 1rem")
            .style("border-radius", "20px")
            .style("font-size", "0.875rem")
            .style("display", "inline-block")
    }
}