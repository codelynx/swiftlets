# Alice's Journey: From Swift Developer to Web Deployment Wizard

Alice stared at her MacBook screen, her fingers hovering over the keyboard. She'd been building iOS apps with SwiftUI for three years, but today was different. Today, she wanted to build a website.

"Why can't building web apps be as elegant as SwiftUI?" she muttered, taking a sip of her cold brew coffee.

That's when she discovered Swiftlets.

## Chapter 1: The Discovery

Alice found Swiftlets while browsing GitHub. The README promised something almost too good to be true: SwiftUI-style syntax for building dynamic web applications.

```swift
@main
struct HomePage: SwiftletMain {
    @Query("name") var userName: String?
    
    var body: some HTML {
        VStack {
            H1("Hello, \(userName ?? "World")!")
            P("Welcome to my Swift-powered website!")
        }
    }
}
```

"Wait, this looks just like SwiftUI!" Alice exclaimed. Her heart raced with excitement.

## Chapter 2: Getting Started

Alice opened Terminal and got to work:

```bash
# Clone Swiftlets
git clone https://github.com/yourusername/swiftlets.git
cd swiftlets

# Build the server
./build-server
```

She created her first site with trembling fingers:

```bash
mkdir -p sites/alice-blog/src
```

Then wrote her first Swiftlet:

```swift
// sites/alice-blog/src/index.swift
import Swiftlets

@main
struct AliceBlog: SwiftletMain {
    var body: some HTML {
        Html {
            Head {
                Title("Alice's Swift Blog")
                Style {
                    """
                    body { 
                        font-family: -apple-system, BlinkMacSystemFont, sans-serif;
                        max-width: 800px;
                        margin: 0 auto;
                        padding: 2rem;
                    }
                    """
                }
            }
            Body {
                VStack(spacing: 30) {
                    Header {
                        H1("Alice's Swift Blog")
                            .foregroundColor("#007AFF")
                    }
                    
                    Main {
                        Article {
                            H2("My First Post: Why I Love Swift on the Server")
                            P("Today I discovered Swiftlets, and it changed everything...")
                        }
                    }
                    
                    Footer {
                        P("Built with ❤️ and Swift")
                            .fontSize(.small)
                            .foregroundColor("#666")
                    }
                }
            }
        }
    }
}
```

She built and ran it:

```bash
./build-site sites/alice-blog
./run-site sites/alice-blog
```

Opening http://localhost:8080, Alice gasped. Her Swift code had become a beautiful website!

## Chapter 3: Adding Interactivity

Alice wanted to add a contact form. She created a new file:

```swift
// sites/alice-blog/src/contact.swift
import Swiftlets

@main
struct ContactPage: SwiftletMain {
    @FormValue("name") var name: String?
    @FormValue("email") var email: String?
    @FormValue("message") var message: String?
    @State var submitted = false
    
    var body: some HTML {
        VStack(spacing: 20) {
            H1("Contact Alice")
            
            If(submitted) {
                Div {
                    H2("Thank you!")
                    P("I'll get back to you soon, \(name ?? "friend")!")
                }
                .padding(20)
                .backgroundColor("#d4edda")
                .borderRadius(8)
            } else {
                Form(action: "/contact", method: .post) {
                    VStack(spacing: 15) {
                        Label("Your Name") {
                            Input(type: .text, name: "name")
                                .required()
                        }
                        
                        Label("Email") {
                            Input(type: .email, name: "email")
                                .required()
                        }
                        
                        Label("Message") {
                            TextArea(name: "message", rows: 5)
                                .required()
                        }
                        
                        Button("Send Message", type: .submit)
                            .backgroundColor("#007AFF")
                            .foregroundColor("white")
                            .padding(10, 20)
                            .borderRadius(5)
                    }
                }
            }
        }
        .padding(20)
    }
}
```

## Chapter 4: The AWS Adventure

After a week of development, Alice's blog was ready. Now came the challenge: deploying to AWS.

"I've never deployed a server before," Alice admitted to her rubber duck debugger. The duck stared back, offering silent support.

She logged into AWS Console and launched an EC2 instance:
- Ubuntu 22.04 LTS
- t3.small (her blog didn't need much power yet)
- 20GB storage
- Security group allowing SSH (22), HTTP (80), HTTPS (443)

## Chapter 5: The Deployment Dance

Alice SSH'd into her new server:

```bash
ssh -i alice-key.pem ubuntu@ec2-3-14-159-265.compute-1.amazonaws.com
```

She remembered the Swiftlets deployment guide and ran:

```bash
# Download setup script
wget https://raw.githubusercontent.com/swiftlets/main/deploy/ec2/setup-instance.sh
chmod +x setup-instance.sh

# Run it
./setup-instance.sh
```

The script worked its magic, installing Swift, Nginx, and all dependencies. Alice watched the terminal scroll by, feeling like a real DevOps engineer.

## Chapter 6: The First Deploy

Back on her local machine, Alice prepared her deployment:

```bash
# Create deployment package
./deploy/ec2/build-for-linux.sh alice-blog

# Deploy to EC2
./deploy/ec2/deploy.sh ec2-3-14-159-265.compute-1.amazonaws.com alice-blog
```

She held her breath as the deployment script ran:
- ✓ Building site for Linux
- ✓ Uploading to server
- ✓ Extracting files
- ✓ Restarting service
- ✓ Health check passed

"Deployment successful!" appeared in green text.

## Chapter 7: Going Live

Alice opened her browser and typed her EC2 public IP. There it was—her Swift blog, live on the internet!

She quickly bought a domain and configured it:

```nginx
server {
    listen 80;
    server_name aliceswiftblog.com www.aliceswiftblog.com;
    
    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

## Chapter 8: The Continuous Journey

Alice set up GitHub Actions for automatic deployments:

```yaml
name: Deploy Blog
on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Deploy to EC2
        env:
          EC2_HOST: ${{ secrets.EC2_HOST }}
          SSH_KEY: ${{ secrets.SSH_KEY }}
        run: |
          echo "$SSH_KEY" > deploy_key
          chmod 600 deploy_key
          ./deploy/ec2/deploy.sh $EC2_HOST alice-blog deploy_key
```

Now every push to main automatically deployed her changes!

## Epilogue: Alice's Reflection

Six months later, Alice's blog had grown. She'd added:
- A comment system using Swiftlets' form handling
- An RSS feed generator
- Dark mode support
- Analytics tracking

She opened her latest blog post draft:

```markdown
# Why Every Swift Developer Should Try Server-Side Swift

When I started this journey, I was just an iOS developer who wanted to build a website. Swiftlets showed me that the skills I already had were more powerful than I realized.

Here's what I learned:
1. Swift isn't just for apps—it's a fantastic web language
2. SwiftUI patterns translate beautifully to HTML
3. Deployment doesn't have to be scary
4. Type safety on the server is amazing

To anyone reading this: if you know Swift, you can build for the web. Start small, deploy early, and enjoy the journey.

Happy coding!
- Alice
```

She clicked publish, watching as GitHub Actions automatically deployed her post to AWS.

Alice smiled. She'd gone from iOS developer to full-stack Swift engineer, and the journey had just begun.

---

*Want to follow Alice's path? Check out:*
- [Swiftlets Documentation](https://github.com/swiftlets/docs)
- [AWS EC2 Deployment Guide](./aws-ec2-deployment.md)
- [Deployment Overview](./deployment-overview.md)

*Remember: Every expert was once a beginner. Your Swift website journey starts with a single file.*