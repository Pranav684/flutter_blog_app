const Like = require("../models/likes");
const Blog = require("../models/blog");
const mongoose = require("mongoose");

exports.toggelLike = async (req, res) => {
    try {
      const session = await mongoose.startSession();
    session.startTransaction();
    const userId = req.user._id;
    const blogId = req.params.blogId;

    console.log("..............");
    console.log(userId, blogId);
    console.log("..............");

    // create Like
    await Like.create(
      [
        {
          userId,
          blogId,
        },
      ],
      { session }
    );

    // increment like
    const blog = await Blog.findByIdAndUpdate(
      blogId,
      { $inc: { likes: 1 } },
      { new: true, session }
    );
    console.log("Object-1");
    await session.commitTransaction();
    console.log("Object-2");
    session.endSession();
    console.log("Object-3");

    return res.status(200).json({
      success: true,
      likeCount: blog.likes,
    });
  } catch (error) {
    const session = await mongoose.startSession();
    session.startTransaction();
    console.log("..............");
    console.log(error.code);
    console.log("..............");
    if (error.code === 11000) {
      try {
        const userId = req.user._id;
        const blogId = req.params.blogId;
        await Like.deleteOne({ userId, blogId }).session(session);
        console.log("..............1");

        // decrement like
        const blog = await Blog.findByIdAndUpdate(
          blogId,
          { $inc: { likes: -1 } },
          { new: true, session }
        );
        console.log("Object-3");
        await session.commitTransaction();
        console.log("Object-3");
        session.endSession();
        console.log("Object-3");

        return res.status(200).json({
          success: false,
          likeCount: blog.likes,
        });
      } catch (error) {
        console.log("..............");
        console.log(error);
        console.log("0");
        await session.abortTransaction();
        session.endSession();
        return res.json({
          success: false,
          error,
        });
      }
    }
    console.log("..............");
    console.log("error");
    console.log("..............");
    await session.abortTransaction();
    session.endSession();
    res.json({
      success: false,
      error,
    });
  }
};
