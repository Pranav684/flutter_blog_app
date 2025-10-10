const { Router } = require("express");
const Blog = require("../models/blog");
const Comment = require("../models/comments");
const router = Router();

router.post("/upload", async (req, res) => {
  const { title, body, coverImageURL } = req.body;
  console.log("user Id: ", req.user._id);
  try {
    await Blog.create({
      title,
      body,
      coverImageURL,
      createdBy: req.user._id,
    });

    return res.json({
      success: true,
      message: "blog uploaded!",
    });
  } catch (error) {
    return res.json({
      success: false,
      message: "Something went wrong!",
    });
  }
});

router.get("/get_all_blogs", async (req, res) => {
  try {
    const allBlogs = await Blog.find({})
      .populate("createdBy")
      .sort("-createdAt");
    console.log(allBlogs);
    return res.json({
      success: true,
      blogs: allBlogs,
    });
  } catch (error) {
    return res.json({
      success: false,
      message: "Something went wrong!",
    });
  }
});

router.get("/:id", async (req, res) => {
  try {
    const blog = await Blog.findById(req.params.id).populate("createdBy");
    const comments = await Comment.find({ blogId: req.params.id }).populate(
      "createdBy"
    );
    return res.json({
      success: true,
      blog: blog,
      comments: comments,
    });
  } catch (error) {
    return res.json({
      success: false,
      message: "Something went wrong!",
    });
  }
});

router.post("/comment/:blogId", async (req, res) => {
  try {
    await Comment.create({
      content: req.body.content,
      blogId: req.params.blogId,
      createdBy: req.user._id,
    });

    return res.json({
      success: true,
      message: "comment posted!",
    });
  } catch (error) {
    return res.json({
      success: false,
      message: "Something went wrong!",
    });
  }
});

module.exports = router;
