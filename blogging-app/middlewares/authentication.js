const { validateToken } = require("../services/authentication");
const JWT = require("jsonwebtoken");
const User=require("../models/user")
const mongoose = require("mongoose");

function  authenticateUserRequest () {
  return async (req, res, next) => {
      try {
      const auth = req.headers.authorization;
      if (!auth || !auth.startsWith("Bearer ")) {
        console.log("Singing up!")
         next();
         return;
      }
      const token = auth.split(" ")[1];
      const payload = validateToken(token);
  
      const objectId = new mongoose.Types.ObjectId(payload._id);
      const user= await User.findById(objectId);
      console.log("user Id:- ",objectId)
      console.log("user :- ",user)
      if(!user){
          return res
          .status(401)
          .json({ success: false, message: "User not found!" });
      }
  
      req.user=user;
      return next();
    } catch (error) {
        console.log("authentication error!")
        return res.status(401).json({ success: false, message: "Invalid token!" });
    }
  };
}


module.exports={authenticateUserRequest};