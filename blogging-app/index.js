const path = require("path");
const express = require("express");
const mongoose = require("mongoose");
const userRouter = require("./routes/user");
const blogRouter = require("./routes/blog");
const { authenticateUserRequest } = require("./middlewares/authentication");

const app = express();
const PORT = 8000;

mongoose
  .connect("mongodb://localhost:27017/blogify")
  .then((e) => console.log("MongoDB Connected"));

app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(authenticateUserRequest());

app.use("/user", userRouter);
app.use("/blog", blogRouter);

// app.set("view engine", "ejs");
// app.set("views", path.resolve("./views"));

app.listen(PORT, () => console.log(`Server Started at PORT:${PORT}`));
