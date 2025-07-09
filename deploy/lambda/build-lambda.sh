#!/bin/bash
#
# Build Swiftlets for AWS Lambda deployment
# This script packages Swiftlets as a Lambda function
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SITE_NAME=${1:-"swiftlets-site"}
LAMBDA_NAME=${2:-"swiftlets-lambda"}
ARCHITECTURE=${3:-"x86_64"}  # or "arm64"
OUTPUT_DIR="deploy/lambda/build"

echo -e "${GREEN}=== Swiftlets Lambda Build Script ===${NC}"
echo "Site: $SITE_NAME"
echo "Lambda Function: $LAMBDA_NAME"
echo "Architecture: $ARCHITECTURE"

# Validate architecture
if [[ "$ARCHITECTURE" != "x86_64" && "$ARCHITECTURE" != "arm64" ]]; then
    echo -e "${RED}Invalid architecture: $ARCHITECTURE${NC}"
    echo "Supported architectures: x86_64, arm64"
    exit 1
fi

# Clean previous builds
echo -e "${YELLOW}Cleaning previous builds...${NC}"
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

# Step 1: Build Swiftlets site
echo -e "${BLUE}Building Swiftlets site...${NC}"
./build-site "sites/$SITE_NAME" --platform linux --arch "$ARCHITECTURE"

# Step 2: Build Lambda adapter
echo -e "${BLUE}Building Lambda adapter...${NC}"
cd deploy/lambda

# Use Docker to build for Lambda runtime
docker run \
    --rm \
    --volume "$(pwd)/:/src" \
    --workdir "/src" \
    swift:5.9-amazonlinux2 \
    swift build -c release --product SwiftletsLambda

# Extract the built executable
docker run \
    --rm \
    --volume "$(pwd)/:/src" \
    --workdir "/src" \
    swift:5.9-amazonlinux2 \
    cp .build/release/SwiftletsLambda /src/build/bootstrap

cd ../..

# Step 3: Package Lambda deployment
echo -e "${BLUE}Creating Lambda deployment package...${NC}"

# Create Lambda directory structure
LAMBDA_DIR="$OUTPUT_DIR/lambda-package"
mkdir -p "$LAMBDA_DIR"

# Copy Lambda bootstrap (the adapter)
cp "$OUTPUT_DIR/bootstrap" "$LAMBDA_DIR/"
chmod +x "$LAMBDA_DIR/bootstrap"

# Copy Swiftlets executables
cp -r "bin/linux/$ARCHITECTURE" "$LAMBDA_DIR/bin/linux/"

# Copy site files (excluding source)
mkdir -p "$LAMBDA_DIR/sites/$SITE_NAME"
cp -r "sites/$SITE_NAME/public" "$LAMBDA_DIR/sites/$SITE_NAME/" 2>/dev/null || true
cp -r "sites/$SITE_NAME/.res" "$LAMBDA_DIR/sites/$SITE_NAME/" 2>/dev/null || true

# Create deployment ZIP
cd "$LAMBDA_DIR"
zip -r "../$LAMBDA_NAME.zip" .
cd -

# Calculate package size
PACKAGE_SIZE=$(du -h "$OUTPUT_DIR/$LAMBDA_NAME.zip" | cut -f1)

echo -e "${GREEN}Lambda package created successfully!${NC}"
echo "Package: $OUTPUT_DIR/$LAMBDA_NAME.zip"
echo "Size: $PACKAGE_SIZE"

# Step 4: Generate SAM template
echo -e "${BLUE}Generating SAM template...${NC}"

cat > "$OUTPUT_DIR/template.yaml" <<EOF
AWSTemplateFormatVersion: '2010-09-09'
Transform: AWS::Serverless-2016-10-31
Description: Swiftlets Lambda Deployment

Globals:
  Function:
    Timeout: 30
    MemorySize: 512
    
Parameters:
  Environment:
    Type: String
    Default: production
    AllowedValues:
      - development
      - staging
      - production

Resources:
  SwiftletsFunction:
    Type: AWS::Serverless::Function
    Properties:
      FunctionName: !Sub '\${AWS::StackName}-swiftlets'
      CodeUri: $LAMBDA_NAME.zip
      Handler: bootstrap
      Runtime: provided.al2
      Architectures:
        - $ARCHITECTURE
      Environment:
        Variables:
          SWIFTLETS_ENV: !Ref Environment
          SITE_NAME: $SITE_NAME
      Events:
        ApiEvent:
          Type: HttpApi
          Properties:
            Path: /{proxy+}
            Method: ANY
        RootEvent:
          Type: HttpApi
          Properties:
            Path: /
            Method: ANY

Outputs:
  ApiUrl:
    Description: API Gateway endpoint URL
    Value: !Sub 'https://\${ServerlessHttpApi}.execute-api.\${AWS::Region}.amazonaws.com/'
  FunctionArn:
    Description: Lambda Function ARN
    Value: !GetAtt SwiftletsFunction.Arn
EOF

# Step 5: Generate deployment script
echo -e "${BLUE}Generating deployment script...${NC}"

cat > "$OUTPUT_DIR/deploy.sh" <<'DEPLOY_SCRIPT'
#!/bin/bash
# Deploy Swiftlets to AWS Lambda

STACK_NAME=${1:-"swiftlets-lambda"}
REGION=${2:-"us-east-1"}
S3_BUCKET=${3:-""}

echo "Deploying stack: $STACK_NAME to region: $REGION"

# Deploy using SAM
if [ -z "$S3_BUCKET" ]; then
    sam deploy \
        --template-file template.yaml \
        --stack-name "$STACK_NAME" \
        --capabilities CAPABILITY_IAM \
        --region "$REGION" \
        --parameter-overrides Environment=production
else
    sam deploy \
        --template-file template.yaml \
        --stack-name "$STACK_NAME" \
        --capabilities CAPABILITY_IAM \
        --region "$REGION" \
        --s3-bucket "$S3_BUCKET" \
        --parameter-overrides Environment=production
fi
DEPLOY_SCRIPT

chmod +x "$OUTPUT_DIR/deploy.sh"

echo -e "${GREEN}=== Build Complete ===${NC}"
echo ""
echo "Next steps:"
echo "1. Install AWS SAM CLI: https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html"
echo "2. Configure AWS credentials: aws configure"
echo "3. Deploy to Lambda:"
echo "   cd $OUTPUT_DIR"
echo "   ./deploy.sh my-swiftlets-stack us-east-1 my-sam-bucket"
echo ""
echo "For local testing:"
echo "   cd $OUTPUT_DIR"
echo "   sam local start-api"