# 📰 Flutter Blog App

A modern **full-stack blog application** built with **Flutter**, **Firebase**, **Node.js**, **Express**, **MongoDB**, and **SQLite**.  
It allows users to **read, write, and comment on blogs**, with a seamless and responsive UI inspired by modern social apps.

---

## 🚀 Features

### 🖥️ Frontend (Flutter)
- Beautiful and responsive UI using **Flutter**.
- **Provider/Riverpod** state management.
- **Local caching** using **SQLite** for offline access.

### ⚙️ Backend (Node.js + Express)
- RESTful API built with **Express**.
- Authentication middleware for secure routes.
- API endpoints for:
  - Creating, reading, updating, deleting blogs.
  - Adding comments.
  - User profile management.
- Input validation and error handling.

### 🗄️ Database
- **MongoDB Atlas** for storing:
  - User profiles.
  - Blog data and comments.
- **SQLite** for local storage and offline support in the Flutter app.

### ☁️ Firebase Integration
- **Firebase Auth** for user authentication.
- **Firebase Storage** for image uploads and blog cover images.

---

## 🧩 Tech Stack

| Layer | Technology | Description |
|-------|-------------|-------------|
| Frontend | Flutter | Cross-platform mobile framework |
| Local DB | SQLite | Offline caching and local data |
| Auth & Cloud | Firebase | Authentication & image storage |
| Backend | Node.js + Express | REST API services |
| Database | MongoDB | Main cloud database |

---

---

## ⚡ Installation & Setup


### 🔹 1. Clone the repository
```bash
git clone https://github.com/<your-username>/flutter_blog_app.git
cd flutter_blog_app
```
🔹 2. Setup the Flutter frontend
```bash
cd blog_app
flutter pub get
flutter run
```
🔹 3. Setup the Node.js backend
```bash
cd ../backend
npm install
node server.js
```
🔹 4. Configure Firebase
```bash
Create a Firebase project.
Enable Authentication and Storage.
Add your Firebase config to the Flutter project (firebase_options.dart or .env).
```
🔹 5. Setup MongoDB
```bash
Create a free cluster on MongoDB Atlas.
Add your connection string to backend/.env:
MONGO_URI=your_mongodb_connection_string
```
🧑‍💻 API Endpoints
```bash
Method	Endpoint	Description
GET	/api/blogs	Fetch all blogs
POST	/api/blogs	Create new blog
GET	/api/blogs/:id	Get single blog
POST	/api/blogs/:id/comment	Add a comment
DELETE	/api/blogs/:id	Delete blog
```
🛠️ Environment Variables
```bash
Backend .env file should include:
PORT=5000
MONGO_URI=your_mongo_connection_string
JWT_SECRET=your_secret_key
```
📸 Screenshots

<img width="415" height="857" alt="Screenshot 2025-10-17 at 1 52 27 AM" src="https://github.com/user-attachments/assets/2172531b-fe56-4103-ba0d-0ce3bd32e7d3" />
<img width="408" height="843" alt="Screenshot 2025-10-17 at 1 55 34 AM" src="https://github.com/user-attachments/assets/22f7fc5c-3fa2-4f6d-aaf6-84376e29b5c0" />
<img width="413" height="848" alt="Screenshot 2025-10-17 at 1 53 26 AM" src="https://github.com/user-attachments/assets/eff9b2a9-c0e4-47d6-b58d-5400be0f57fa" />
<img width="411" height="842" alt="Screenshot 2025-10-17 at 1 53 53 AM" src="https://github.com/user-attachments/assets/7d547f97-adcc-48da-8a38-d632f6863209" />


🧠 Future Enhancements
```bash
User profiles and follower system.
Blog categories & tags.
Push notifications via Firebase.
Web dashboard for admin management.
Dark/light theme switch.
```
🧑‍💼 Author
```bash
Pranav Srivastava
Frontend Developer | Flutter, Node.js, Firebase, MongoDB
🌐 GitHub
✉️ pranavsrivastava684@gmail.com
```


