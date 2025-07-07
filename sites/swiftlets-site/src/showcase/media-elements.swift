import Swiftlets

@main
struct MediaElementsShowcase: SwiftletMain {
    var title = "Media Elements - Swiftlets Showcase"
    
    var body: some HTMLElement {
        Fragment {
            showcaseStyles()
            mediaStyles()
            navigation()
            header()
            mainContent()
        }
    }
    
    @HTMLBuilder
    func mediaStyles() -> some HTMLElement {
        Style("""
        /* Media-specific styles */
        .media-container {
            margin: 1rem 0;
            padding: 1rem;
            background: #f8f9fa;
            border-radius: 0.5rem;
        }
        
        .img-rounded {
            border-radius: 0.5rem;
        }
        
        .img-shadow {
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .img-thumbnail {
            border: 2px solid #e9ecef;
            border-radius: 0.375rem;
            padding: 0.25rem;
            background: white;
        }
        
        .video-container {
            position: relative;
            background: #000;
            border-radius: 0.5rem;
            overflow: hidden;
        }
        
        .audio-player {
            width: 100%;
            max-width: 400px;
        }
        
        video, iframe {
            max-width: 100%;
            height: auto;
        }
        
        /* Responsive iframe wrapper */
        .responsive-iframe {
            position: relative;
            padding-bottom: 56.25%; /* 16:9 aspect ratio */
            height: 0;
            overflow: hidden;
        }
        
        .responsive-iframe iframe {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
        }
        """)
    }
    
    @HTMLBuilder
    func navigation() -> some HTMLElement {
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
    }
    
    @HTMLBuilder
    func header() -> some HTMLElement {
        Div {
            Div {
                H1("Media Elements")
                P("Images, videos, audio, and embedded content with modern styling")
            }
            .class("showcase-container")
        }
        .class("showcase-header")
    }
    
    @HTMLBuilder
    func mainContent() -> some HTMLElement {
        Div {
            // Breadcrumb
            Div {
                Link(href: "/showcase", "← Back to Showcase")
            }
            .style("margin-bottom", "2rem")
            
            imagesSection()
            pictureSection()
            videoSection()
            audioSection()
            iframeSection()
            
            // Navigation links
            Div {
                Link(href: "/showcase/forms", "Forms")
                    .class("nav-button")
                Link(href: "/showcase/layout-components", "Layout Components")
                    .class("nav-button nav-button-next")
            }
            .class("navigation-links")
        }
        .class("showcase-container")
    }
    
    @HTMLBuilder
    func imagesSection() -> some HTMLElement {
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
                VStack(spacing: 20) {
                    Div {
                        P("Basic image:")
                            .style("margin-bottom", "0.5rem")
                            .style("font-weight", "500")
                        Img(src: "https://via.placeholder.com/150x50/667eea/ffffff?text=Logo", alt: "Swiftlets Logo")
                    }
                    
                    Div {
                        P("Styled image with gradient background:")
                            .style("margin-bottom", "0.5rem")
                            .style("font-weight", "500")
                        Img(src: "https://via.placeholder.com/600x300/667eea/ffffff?text=Hero+Image", alt: "Hero Image")
                            .class("img-rounded img-shadow")
                            .style("width", "100%")
                            .style("max-width", "400px")
                            .style("display", "block")
                    }
                    
                    Div {
                        P("Thumbnail with attributes:")
                            .style("margin-bottom", "0.5rem")
                            .style("font-weight", "500")
                        Img(src: "https://via.placeholder.com/300x200/764ba2/ffffff?text=Product", alt: "Product")
                            .attribute("loading", "lazy")
                            .attribute("width", "300")
                            .attribute("height", "200")
                            .class("img-thumbnail")
                    }
                }
            },
            description: "The Img element embeds images with support for alt text, lazy loading, and responsive sizing."
        ).render()
    }
    
    @HTMLBuilder
    func pictureSection() -> some HTMLElement {
        CodeExample(
            title: "Picture Element - Responsive Images",
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
                Div {
                    P("Resize your browser to see different images:")
                        .style("margin-bottom", "1rem")
                        .style("color", "#6c757d")
                        .style("font-style", "italic")
                    Picture {
                        Source(
                            srcset: "https://via.placeholder.com/400x300/2196F3/ffffff?text=Mobile+WebP",
                            media: "(max-width: 768px)",
                            type: "image/webp"
                        )
                        Source(
                            srcset: "https://via.placeholder.com/800x400/4CAF50/ffffff?text=Desktop+WebP",
                            media: "(min-width: 769px)",
                            type: "image/webp"
                        )
                        Img(
                            src: "https://via.placeholder.com/600x300/FF9800/ffffff?text=Fallback+JPEG",
                            alt: "Responsive Image"
                        )
                        .class("img-rounded img-shadow")
                        .style("width", "100%")
                        .style("display", "block")
                    }
                }
            },
            description: "Picture element provides art direction and format selection for responsive images."
        ).render()
    }
    
    @HTMLBuilder
    func videoSection() -> some HTMLElement {
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
            <video src="movie.mp4" controls width="320" height="240">
                <p>Your browser does not support the video tag.</p>
            </video>
            
            <!-- With multiple sources and poster -->
            <video controls poster="poster.jpg">
                <source type="video/mp4" src="movie.mp4">
                <source type="video/ogg" src="movie.ogg">
                <p>Your browser does not support the video tag.</p>
            </video>
            """,
            preview: {
                VStack(spacing: 20) {
                    Div {
                        P("Sample video with controls:")
                            .style("margin-bottom", "0.5rem")
                            .style("font-weight", "500")
                        Video(src: "https://www.w3schools.com/html/mov_bbb.mp4", controls: true) {
                            P("Your browser does not support the video tag.")
                        }
                        .attribute("width", "100%")
                        .attribute("height", "auto")
                        .style("max-width", "400px")
                        .style("border-radius", "0.5rem")
                        .style("box-shadow", "0 4px 6px rgba(0,0,0,0.1)")
                    }
                    
                    Div {
                        P("💡 Video features: play/pause, volume control, fullscreen")
                            .style("color", "#6c757d")
                            .style("font-size", "0.875rem")
                            .style("background", "#f0f4f8")
                            .style("padding", "0.75rem")
                            .style("border-radius", "0.375rem")
                    }
                }
            },
            description: "Video element embeds video content with playback controls and multiple source support."
        ).render()
    }
    
    @HTMLBuilder
    func audioSection() -> some HTMLElement {
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
            <audio src="audio.mp3" controls>
                <p>Your browser does not support the audio element.</p>
            </audio>
            
            <!-- With multiple sources -->
            <audio controls class="audio-player">
                <source type="audio/ogg" src="audio.ogg">
                <source type="audio/mpeg" src="audio.mp3">
                <p>Your browser does not support the audio element.</p>
            </audio>
            """,
            preview: {
                VStack(spacing: 20) {
                    Div {
                        P("Audio player with controls:")
                            .style("margin-bottom", "0.5rem")
                            .style("font-weight", "500")
                        Audio(src: "https://www.w3schools.com/html/horse.mp3", controls: true) {
                            P("Your browser does not support the audio element.")
                        }
                        .class("audio-player")
                    }
                    
                    Div {
                        P("🎵 Features: play/pause, seek bar, volume control")
                            .style("color", "#6c757d")
                            .style("font-size", "0.875rem")
                            .style("background", "#f0f4f8")
                            .style("padding", "0.75rem")
                            .style("border-radius", "0.375rem")
                    }
                }
            },
            description: "Audio element embeds sound content with playback controls."
        ).render()
    }
    
    @HTMLBuilder
    func iframeSection() -> some HTMLElement {
        CodeExample(
            title: "IFrame Element - Embedded Content",
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
            <iframe src="https://www.youtube.com/embed/dQw4w9WgXcQ" title="YouTube video player" frameborder="0" allowfullscreen></iframe>
            """,
            preview: {
                VStack(spacing: 20) {
                    Div {
                        P("Embedded OpenStreetMap:")
                            .style("margin-bottom", "0.5rem")
                            .style("font-weight", "500")
                        Div {
                            IFrame(
                                src: "https://www.openstreetmap.org/export/embed.html?bbox=-74.0060%2C40.7128%2C-73.9352%2C40.7614&layer=mapnik",
                                title: "OpenStreetMap of New York"
                            )
                            .style("width", "100%")
                            .style("height", "300px")
                            .style("border", "none")
                            .style("border-radius", "0.5rem")
                            .style("box-shadow", "0 4px 6px rgba(0,0,0,0.1)")
                        }
                    }
                    
                    Div {
                        P("🌐 IFrames can embed maps, videos, documents, and other web content")
                            .style("color", "#6c757d")
                            .style("font-size", "0.875rem")
                            .style("background", "#f0f4f8")
                            .style("padding", "0.75rem")
                            .style("border-radius", "0.375rem")
                    }
                }
            },
            description: "IFrame element embeds external content within your page."
        ).render()
    }
}