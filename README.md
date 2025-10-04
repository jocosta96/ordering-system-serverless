# Ordering System Serverless Infrastructure

## 🎯 Overview

This repository contains the **serverless infrastructure** for the Fast Food Ordering System, implementing **API Gateway** and **CPF-based authentication** using AWS serverless services.

## 🏗️ Architecture

### Core Components
- **AWS API Gateway**: External API endpoint for client requests
- **AWS Lambda**: Serverless authentication functions
- **AWS Cognito/AD**: Identity provider integration
- **JWT Tokens**: Secure authentication mechanism

### Authentication Flow
```
External Request → API Gateway → Lambda Auth Function → Cognito/AD → JWT Token
```

## 🔐 Authentication System

### CPF-Based Authentication
The system implements **passwordless authentication** using only CPF (Brazilian tax ID):

#### Key Features
- **No passwords required**: Only CPF needed for authentication
- **JWT token management**: Secure token-based authentication
- **Identity provider integration**: AWS Cognito or Active Directory
- **Serverless architecture**: Scalable Lambda-based authentication

#### Authentication Endpoints
```http
POST /auth/authenticate              # Authenticate with CPF
POST /auth/refresh                   # Refresh JWT token
GET  /auth/validate                  # Validate current token
POST /auth/logout                    # Invalidate token
```

### CPF Authentication Flow
1. **Client sends CPF** to authentication endpoint
2. **Lambda function validates** CPF format and structure
3. **Identity provider lookup** (Cognito/AD) for customer data
4. **JWT token generation** with customer information
5. **Token returned** to client for subsequent API calls


## 🚀 API Gateway Features

### Request Processing
- **Request validation**: CPF format validation
- **Rate limiting**: Protection against abuse
- **CORS configuration**: Controlled cross-origin access
- **Request/Response transformation**: Data format standardization

### Integration Points
- **External API access**: Secure gateway for client applications
- **Authentication layer**: CPF-based authentication for all requests
- **Backend integration**: Seamless connection to FastAPI application

## 🛠️ Technology Stack

### AWS Services
- **API Gateway**: REST API management and routing
- **Lambda**: Serverless compute for authentication

### Infrastructure as Code
- **Terraform**: Infrastructure provisioning and management
- **Remote State**: S3 backend for state management
- **Version Control**: Git-based infrastructure versioning

## 📁 Repository Structure

```
TBD
```

## 🚀 Deployment

### Prerequisites
- **AWS CLI**: Configured with appropriate credentials
- **Terraform**: Version 1.12.2 or higher
- **Git**: For repository management

### Deployment Steps
1. **Configure AWS credentials**:
   ```bash
   aws configure
   ```

2. **Initialize Terraform**:
   ```bash
   terraform init
   ```

3. **Plan infrastructure**:
   ```bash
   terraform plan
   ```

4. **Apply infrastructure**:
   ```bash
   terraform apply
   ```

### Environment Variables
```bash
# AWS Configuration
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key
AWS_DEFAULT_REGION=us-east-1

```

## 🔧 Configuration

## 🔒 Security

### Authentication Security
- **JWT Tokens**: Signed with RS256 algorithm
- **Token Expiration**: 24 hours with refresh capability
- **CPF Validation**: Brazilian CPF format validation
- **Rate Limiting**: Protection against brute force attacks

### API Security
- **HTTPS Only**: All endpoints require SSL/TLS
- **CORS Configuration**: Restricted to allowed origins
- **Request Validation**: Input sanitization and validation
- **Logging**: Comprehensive audit logging

## 📊 Monitoring & Logging

## 🧪 Testing

### Local Testing
```bash
# Test API Gateway locally
sam local start-api

# Test Lambda functions
sam local invoke AuthFunction
```

### Integration Testing
```bash
# Test authentication flow
curl -X POST https://api-gateway-url/auth/authenticate \
  -H "Content-Type: application/json" \
  -d '{"cpf": "12345678901"}'

# Test token validation
curl -X GET https://api-gateway-url/auth/validate \
  -H "Authorization: Bearer your-jwt-token"
```

## 🔄 CI/CD Integration

### GitHub Actions
- **Automated deployment** on main branch pushes
- **Infrastructure validation** before deployment
- **Security scanning** with tfsec
- **State management** with S3 backend

### Deployment Pipeline
1. **Code commit** to main branch
2. **Terraform plan** execution
3. **Security scan** with tfsec
4. **Infrastructure deployment**
5. **Validation tests** execution

## 📚 Documentation

### API Documentation
- **Swagger/OpenAPI**: Available at `/docs` endpoint
- **Authentication Guide**: CPF-based authentication flow
- **Integration Guide**: Client integration examples

### Infrastructure Documentation
- **Terraform Modules**: Reusable infrastructure components
- **Deployment Guide**: Step-by-step deployment instructions
- **Troubleshooting**: Common issues and solutions

This serverless infrastructure provides a **secure, scalable, and maintainable** authentication system for the Fast Food Ordering System, implementing **CPF-based authentication** with **JWT token management** and **AWS serverless services**.