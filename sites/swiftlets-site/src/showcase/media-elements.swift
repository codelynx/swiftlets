import Swiftlets

@main
struct MediaElementsShowcase: SwiftletMain {
    var title = "Media Elements - Swiftlets Showcase"
    
    var body: some HTMLElement {
        Fragment {
            Nav {
            Div {
            Link(href: "/", "Swiftlets")
                .class("nav-brand")
            
            Div {
                Link(href: "/", "Home")
                Link(href: "/docs", "Docs")
                Link(href: "/showcase", "Showcase")
                    .class("active")
            }
            .class("nav-links")
            }
            .class("nav-content")
            }
            .class("nav-container")
            
            Div {
            H1("Media Elements")
            
            Div {
            Link(href: "/showcase", "← Back to Showcase")
                .style("display", "inline-block")
                .style("margin-bottom", "1rem")
                .style("color", "#007bff")
            }
            
            P("Media elements for embedding images, videos, audio, and other content.")
            
            // Images
            Section {
            CodeExample(
                title: "Images",
                swift: """
// Basic image
Img(src: "logo.png", alt: "Company Logo")

// Styled image  
Img(src: "hero.jpg", alt: "Hero Image")
    .class("img-rounded img-shadow")
    .style("width", "100%")
    .style("max-width", "600px")

// Image with loading optimization
Img(src: "product.jpg", alt: "Product")
    .attribute("loading", "lazy")
    .attribute("width", "300")
    .attribute("height", "200")
""",
                html: """
<!-- Basic image -->
<img src="logo.png" alt="Company Logo">

<!-- Styled image -->
<img src="hero.jpg" alt="Hero Image" class="img-rounded img-shadow" style="width: 100%; max-width: 600px;">

<!-- Image with loading optimization -->
<img src="product.jpg" alt="Product" loading="lazy" width="300" height="200">
""",
                preview: {
                    Fragment {
                        Div {
                            P("Basic image:")
                            Img(src: "https://via.placeholder.com/150x50/007bff/ffffff?text=Logo", alt: "Swiftlets Logo")
                        }
                        .class("media-container")
                        
                        Div {
                            P("Styled image:")
                            Img(src: "https://via.placeholder.com/600x300/4caf50/ffffff?text=Hero+Image", alt: "Hero Image")
                                .class("img-rounded img-shadow")
                                .style("width", "100%")
                                .style("max-width", "400px")
                        }
                        .class("media-container")
                        
                        Div {
                            P("Image with attributes:")
                            Img(src: "https://via.placeholder.com/300x200/ff9800/ffffff?text=Product", alt: "Product")
                                .attribute("loading", "lazy")
                                .attribute("width", "300")
                                .attribute("height", "200")
                                .class("img-thumbnail")
                        }
                        .class("media-container")
                    }
                },
                description: "The Img element embeds images with support for alt text and various attributes."
            ).render()
            }
            
            // Picture Element
            Section {
            CodeExample(
                title: "Picture Element",
                swift: """
Picture {
    Source(srcset: "hero-mobile.webp", media: "(max-width: 768px)", type: "image/webp")
    Source(srcset: "hero-desktop.webp", media: "(min-width: 769px)", type: "image/webp")
    Source(srcset: "hero-mobile.jpg", media: "(max-width: 768px)", type: "image/jpeg")
    Source(srcset: "hero-desktop.jpg", media: "(min-width: 769px)", type: "image/jpeg")
    Img(src: "hero-fallback.jpg", alt: "Hero Image")
}
""",
                html: """
<picture>
    <source srcset="hero-mobile.webp" media="(max-width: 768px)" type="image/webp">
    <source srcset="hero-desktop.webp" media="(min-width: 769px)" type="image/webp">
    <source srcset="hero-mobile.jpg" media="(max-width: 768px)" type="image/jpeg">
    <source srcset="hero-desktop.jpg" media="(min-width: 769px)" type="image/jpeg">
    <img src="hero-fallback.jpg" alt="Hero Image">
</picture>
""",
                preview: {
                    Picture {
                        Source(
                            srcset: "https://via.placeholder.com/400x300/2196F3/ffffff?text=Mobile",
                            media: "(max-width: 768px)"
                        )
                        Source(
                            srcset: "https://via.placeholder.com/800x400/4CAF50/ffffff?text=Desktop",
                            media: "(min-width: 769px)"
                        )
                        Img(
                            src: "https://via.placeholder.com/600x300/FF9800/ffffff?text=Fallback",
                            alt: "Responsive Image"
                        )
                    }
                    .class("media-container")
                },
                description: "The Picture element provides responsive images with multiple sources based on media queries."
            ).render()
            }
            
            // Video Element
            Section {
            CodeExample(
                title: "Video Element",
                swift: """
Video(src: "movie.mp4", controls: true) {
    P("Your browser does not support the video tag.")
}
.attribute("width", "320")
.attribute("height", "240")

// With multiple sources and poster
Video(controls: true, autoplay: false, loop: false, muted: true) {
    Source(type: "video/mp4", src: "movie.mp4")
    Source(type: "video/ogg", src: "movie.ogg")
    P("Your browser does not support the video tag.")
}
.attribute("poster", "poster.jpg")
""",
                html: """
<video src="movie.mp4" controls="controls" width="320" height="240">
    <p>Your browser does not support the video tag.</p>
</video>

<!-- With multiple sources and poster -->
<video controls="controls" poster="poster.jpg">
    <source type="video/mp4" src="movie.mp4">
    <source type="video/ogg" src="movie.ogg">
    <p>Your browser does not support the video tag.</p>
</video>
""",
                preview: {
                    Fragment {
                        Div {
                            P("Video with controls:")
                            Video(src: "https://www.w3schools.com/html/mov_bbb.mp4", controls: true) {
                                P("Your browser does not support the video tag.")
                            }
                            .attribute("width", "320")
                            .attribute("height", "240")
                        }
                        .class("media-container")
                        
                        Div {
                            P("Note: Video playback may be blocked by browser policies.")
                                .style("color", "#6c757d")
                                .style("font-style", "italic")
                        }
                    }
                },
                description: "The Video element embeds video content with support for multiple sources and playback controls."
            ).render()
            }
            
            // Audio Element
            Section {
            CodeExample(
                title: "Audio Element",
                swift: """
Audio(src: "audio.mp3", controls: true) {
    P("Your browser does not support the audio element.")
}

// With multiple sources
Audio(controls: true) {
    Source(type: "audio/ogg", src: "audio.ogg")
    Source(type: "audio/mpeg", src: "audio.mp3")
    P("Your browser does not support the audio element.")
}
.class("audio-player")
""",
                html: """
<audio src="audio.mp3" controls="controls">
    <p>Your browser does not support the audio element.</p>
</audio>

<!-- With multiple sources -->
<audio controls="controls" class="audio-player">
    <source type="audio/ogg" src="audio.ogg">
    <source type="audio/mpeg" src="audio.mp3">
    <p>Your browser does not support the audio element.</p>
</audio>
""",
                preview: {
                    Fragment {
                        Div {
                            P("Audio player:")
                            Audio(src: "https://www.w3schools.com/html/horse.mp3", controls: true) {
                                P("Your browser does not support the audio element.")
                            }
                            .class("audio-player")
                        }
                        .class("media-container")
                        
                        Div {
                            P("Note: Audio playback may be blocked by browser policies.")
                                .style("color", "#6c757d")
                                .style("font-style", "italic")
                        }
                    }
                },
                description: "The Audio element embeds sound content with support for multiple sources and playback controls."
            ).render()
            }
            
            // IFrame Element
            Section {
            CodeExample(
                title: "IFrame Element",
                swift: """
// Basic iframe
IFrame(src: "https://example.com", title: "Example Website")
    .style("width", "100%")
    .style("height", "400px")

// YouTube embed
IFrame(
    src: "https://www.youtube.com/embed/dQw4w9WgXcQ",
    title: "YouTube video player"
)
    .attribute("frameborder", "0")
    .attribute("allowfullscreen", "true")
""",
                html: """
<!-- Basic iframe -->
<iframe src="https://example.com" title="Example Website" style="width: 100%; height: 400px;"></iframe>

<!-- YouTube embed -->
<iframe src="https://www.youtube.com/embed/dQw4w9WgXcQ" title="YouTube video player" frameborder="0" allowfullscreen="true"></iframe>
""",
                preview: {
                    Fragment {
                        Div {
                            P("Embedded map:")
                            Div {
                                IFrame(
                                    src: "https://www.openstreetmap.org/export/embed.html?bbox=-74.0060%2C40.7128%2C-73.9352%2C40.7614",
                                    title: "OpenStreetMap"
                                )
                                .style("width", "100%")
                                .style("height", "300px")
                                .attribute("frameborder", "0")
                            }
                            .class("video-container")
                        }
                        
                        Div {
                            P("Note: Some content may be blocked by security policies.")
                                .style("color", "#6c757d")
                                .style("font-style", "italic")
                        }
                    }
                },
                description: "The IFrame element embeds another HTML page within the current page."
            ).render()
            }
            
            Div {
            Link(href: "/showcase/forms", "Forms")
                .class("nav-button")
            Link(href: "/showcase/semantic", "Semantic Elements")
                .class("nav-button nav-button-next")
            }
            .class("navigation-links")
            }
            .class("showcase-container")
            
        }
    }
}