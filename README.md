# Keeper App – Dual-Stack Web Application (React + Flask + PostgreSQL)

## 📌 Project Overview  

The **Keeper App** is a Google Keep–style note-taking application built using a **dual-stack architecture**:  

- **Frontend**: React.js for a dynamic, responsive UI  
- **Backend**: Python Flask REST API for data handling and business logic  
- **Database**: PostgreSQL for persistent storage  

The project demonstrates **service decoupling**, **modular architecture**, and deployment using **AWS** with **Terraform** for infrastructure as code.

---

## 🏗 Architecture  

```text
[React Frontend]  <-->  [Flask API Backend]  <-->  [PostgreSQL Database]
```

- Frontend interacts with the backend through RESTful API endpoints  
- Backend handles data processing, authentication, and communicates with PostgreSQL  
- PostgreSQL stores and retrieves notes data  
- AWS hosts the services, with Terraform for provisioning and GitHub Actions for CI/CD automation  

---

## ⚙️ Tech Stack  

**Frontend:**  

- React.js  
- HTML, CSS, JavaScript  
- Axios (API requests)  

**Backend:**  

- Python Flask  
- Flask-SQLAlchemy (ORM)  
- Flask-CORS (cross-origin requests)  
- psycopg2 (PostgreSQL driver)  

**Database:**  

- PostgreSQL (local dev)  
- AWS RDS (production)  

**DevOps / Deployment:**  

- AWS EC2, RDS, Secrets Manager, CloudWatch  
- Terraform for infrastructure provisioning  
- GitHub Actions + AWS CodePipeline for CI/CD  

---

## 🚀 Features  

- Add, edit, and delete notes  
- Persistent storage with PostgreSQL  
- Secure API communication with HTTPS and IAM roles (AWS)  
- CI/CD pipeline for automated deployment  
- CloudWatch monitoring for performance and error tracking  

---

## 📂 Repository Structure  

```text
keeper-app/
│── my-react-app/         # React.js frontend
│── backend/              # Flask backend API
│── terraform/            # Infrastructure as Code
│── README.md
│── .gitignore
```

---

## 🛠 Development Setup

### 1️⃣ Clone the Repository  

```bash
git clone https://github.com/username/keeper-app.git
cd keeper-app
```

### 2️⃣ Backend Setup (Flask + PostgreSQL)  

```bash
cd backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
flask run
```

### 3️⃣ Frontend Setup (React)  

```bash
cd frontend
npm install
npm start
```

---

## 📦 Deployment Plan

1. Develop and test locally with PostgreSQL  
2. Provision AWS infrastructure with Terraform  
3. Configure GitHub Actions to trigger AWS CodePipeline on push  
4. Deploy backend to AWS EC2, frontend to S3/CloudFront  
5. Connect frontend to backend API  
6. Secure with IAM, HTTPS, and Secrets Manager

## 🌐 Environment Configuration

- Local development uses `.env` files for configuration.
- Production uses environment variables set in GitHub Actions and AWS.
- Sensitive values (AWS credentials, DB credentials) are stored in GitHub Secrets.

## 🔄 CI/CD & Automated Deployment

- **GitHub Actions** automates infrastructure provisioning and app deployment.
- **Terraform** provisions AWS resources and outputs dynamic values (EC2 IP, RDS endpoint).
- **React frontend** is built with the correct API endpoint and uploaded to S3.
- **Flask backend** is containerized, pushed to ECR, and deployed to EC2.
- Environment variables are used to configure both frontend and backend for production.

## 📝 Notes

- Ensure `db_username` and `db_password` are set in GitHub Secrets for production.
- The API endpoint for the frontend is set using the EC2 public IP after infrastructure is provisioned.
- Terraform outputs are used in the workflow to pass dynamic values to build and deployment steps.

## 🚧 Future Improvements & Enhancements

This project is designed to be extensible and a foundation for more advanced cloud-native architectures. Potential future enhancements include:

1. **User Authentication & Authorization**
   - Implement a login page for different users.
   - Add authentication (e.g., JWT, OAuth) and role-based access control.

2. **Security Hardening**
   - Conduct security audits to identify and fix vulnerabilities.
   - Implement HTTPS everywhere, use AWS Secrets Manager, and follow best practices for IAM policies.

3. **Microservices & Event-Driven Architecture**
   - Refactor the backend into multiple microservices.
   - Use event-driven communication (e.g., AWS SNS/SQS, Kafka) for inter-service messaging.

4. **Cloud Provider Migration**
   - Explore migrating the infrastructure to other cloud providers (Azure, GCP).
   - Compare cost, performance, and service offerings.

5. **Additional Enhancements**
   - More features and improvements will be added as the project evolves.

---

Feel free to contribute ideas or enhancements by opening issues or pull requests!
