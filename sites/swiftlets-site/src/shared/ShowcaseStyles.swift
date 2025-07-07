// Shared showcase styles
@HTMLBuilder
func showcaseStyles() -> some HTMLElement {
    Style("""
    /* Reset and base styles */
    * { box-sizing: border-box; }
    body { 
        margin: 0; 
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        line-height: 1.6;
        color: #333;
    }
    
    /* Navigation */
    .nav-modern, .nav-container {
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(10px);
        box-shadow: 0 2px 4px rgba(0,0,0,0.06);
        position: sticky;
        top: 0;
        z-index: 100;
        padding: 1rem 0;
    }
    
    .nav-content {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 1rem;
        display: flex;
        align-items: center;
        justify-content: space-between;
    }
    
    .nav-brand {
        font-size: 1.25rem;
        font-weight: 700;
        color: #333;
        text-decoration: none;
    }
    
    .nav-links {
        display: flex;
        gap: 2rem;
    }
    
    .nav-links a {
        color: #666;
        text-decoration: none;
        font-weight: 500;
        transition: color 0.2s;
    }
    
    .nav-links a:hover,
    .nav-links a.active {
        color: #667eea;
    }
    
    /* Hero sections */
    .showcase-hero, .showcase-header {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 4rem 0;
        text-align: center;
    }
    
    .showcase-hero h1,
    .showcase-header h1 {
        font-size: 3rem;
        font-weight: 700;
        margin: 0 0 1rem 0;
    }
    
    .showcase-hero p,
    .showcase-header p {
        font-size: 1.25rem;
        opacity: 0.9;
        margin: 0;
    }
    
    /* Container */
    .showcase-container {
        max-width: 1000px;
        margin: 0 auto;
        padding: 2rem 1rem;
    }
    
    /* Cards */
    .showcase-card {
        background: white;
        border-radius: 0.75rem;
        padding: 2rem;
        box-shadow: 0 4px 6px rgba(0,0,0,0.07);
        transition: all 0.3s ease;
        border: 1px solid #e9ecef;
    }
    
    .showcase-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 20px 25px rgba(0,0,0,0.1);
        border-color: transparent;
    }
    
    .showcase-card-icon {
        font-size: 3rem;
        margin-bottom: 1rem;
        display: block;
    }
    
    .showcase-card h3 {
        color: #2c3e50;
        margin: 0 0 0.5rem 0;
        font-size: 1.5rem;
    }
    
    .showcase-card p {
        color: #6c757d;
        line-height: 1.6;
        margin: 0;
    }
    
    /* Code examples */
    .code-example {
        background: #f8f9fa;
        border-radius: 0.75rem;
        padding: 2rem;
        margin: 2rem 0;
        border: 1px solid #e9ecef;
    }
    
    .code-example-header {
        margin-bottom: 1rem;
    }
    
    .code-example-header h3 {
        color: #2c3e50;
        margin: 0;
        font-size: 1.75rem;
    }
    
    .code-example-description p {
        color: #6c757d;
        margin: 0.5rem 0 1.5rem 0;
    }
    
    .code-example pre {
        background: #2d3748;
        color: #e2e8f0;
        padding: 1.5rem;
        border-radius: 0.5rem;
        overflow-x: auto;
        margin: 1rem 0;
        font-family: 'SF Mono', Monaco, Consolas, monospace;
        font-size: 0.9rem;
        line-height: 1.5;
    }
    
    .code-example code {
        font-family: inherit;
    }
    
    .preview-section {
        background: white;
        border: 2px dashed #e9ecef;
        border-radius: 0.5rem;
        padding: 2rem;
        margin-top: 1.5rem;
    }
    
    .preview-section h4 {
        color: #6c757d;
        font-size: 0.875rem;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        margin: 0 0 1rem 0;
    }
    
    /* Buttons */
    .btn-modern {
        display: inline-block;
        padding: 0.75rem 2rem;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        text-decoration: none;
        border-radius: 0.5rem;
        font-weight: 500;
        transition: all 0.3s ease;
        box-shadow: 0 4px 6px rgba(0,0,0,0.07);
    }
    
    .btn-modern:hover {
        transform: translateY(-2px);
        box-shadow: 0 10px 15px rgba(0,0,0,0.1);
        opacity: 1;
    }
    
    /* Navigation buttons */
    .navigation-links {
        display: flex;
        justify-content: space-between;
        margin-top: 4rem;
        padding-top: 2rem;
        border-top: 1px solid #e9ecef;
    }
    
    .nav-button {
        padding: 0.75rem 1.5rem;
        background: #f8f9fa;
        color: #667eea;
        text-decoration: none;
        border-radius: 0.5rem;
        font-weight: 500;
        transition: all 0.2s;
    }
    
    .nav-button:hover {
        background: #667eea;
        color: white;
    }
    
    .nav-button-next {
        margin-left: auto;
    }
    
    /* Typography */
    h1, h2, h3, h4, h5, h6 {
        margin-top: 0;
        line-height: 1.3;
    }
    
    a {
        color: #667eea;
        text-decoration: none;
    }
    
    a:hover {
        text-decoration: underline;
    }
    
    /* Code styling */
    code {
        background: #f3f4f6;
        padding: 0.2rem 0.4rem;
        border-radius: 0.25rem;
        font-size: 0.875em;
        font-family: 'SF Mono', Monaco, Consolas, monospace;
    }
    
    pre code {
        background: none;
        padding: 0;
    }
    
    /* Special elements */
    kbd {
        background: #1a202c;
        color: white;
        padding: 0.2rem 0.5rem;
        border-radius: 0.25rem;
        font-size: 0.875em;
        font-family: 'SF Mono', Monaco, Consolas, monospace;
        box-shadow: 0 2px 0 #000;
    }
    
    mark {
        background: #fef3c7;
        padding: 0.1rem 0.3rem;
        border-radius: 0.2rem;
    }
    
    blockquote {
        margin: 1.5rem 0;
        padding: 1rem 1.5rem;
        background: #f8f9fa;
        border-left: 4px solid #667eea;
        font-style: italic;
    }
    
    /* Animations */
    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(20px); }
        to { opacity: 1; transform: translateY(0); }
    }
    
    .animate-fadeIn {
        animation: fadeIn 0.6s ease-out;
    }
    
    /* Responsive */
    @media (max-width: 768px) {
        .showcase-hero h1,
        .showcase-header h1 {
            font-size: 2rem;
        }
        
        .nav-links {
            gap: 1rem;
        }
        
        .code-example {
            padding: 1.5rem;
        }
        
        .preview-section {
            padding: 1.5rem;
        }
    }
    """)
}