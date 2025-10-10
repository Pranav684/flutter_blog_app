const { Router } = require("express");
const User = require("../models/user");

const router = Router();

router.post("/signin", async (req, res) => {
  try {
    const { email, password } = req.body;
    const { token, user } = await User.matchPasswordAndCreateToken(
      email,
      password
    );

    console.log("Created User:", user);
    console.log("token", token);
    return res.json({
      success: true,
      message: "user logged in!",
      token: token,
      user: user,
    });
  } catch (error) {
    return res.json({
      success: false,
      message: "Something went wrong!",
    });
  }
});

router.post("/signup", async (req, res) => {
  console.log(req.body);
  const { fullName, email, password, profileImageUrl } = req.body;
  try {
    await User.create({
      fullName,
      email,
      password,
      profileImageUrl,
    });
    console.log("Created User:1");
    const { token, user } = await User.matchPasswordAndCreateToken(
      email,
      password
    );
    console.log("Created User:2");
    return res.json({
      success: true,
      message: "user careted!",
      token: token,
      user: user,
    });
    // console.log("Created User:3");
  } catch (error) {
    console.log("Error:", error.message);
    return res.json({
      success: false,
      message: "Something went wrong!",
    });
  }
});

module.exports = router;
