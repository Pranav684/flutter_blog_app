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
```bash
```

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


