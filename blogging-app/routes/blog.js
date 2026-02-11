const { Router } = require("express");
const Blog = require("../models/blog");
const Comment = require("../models/comments");
const Like = require("../models/likes");
const likeController = require("../controllers/likesController");
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
      .populate("createdBy", "fullName email profileImageUrl role")
      .sort("-createdAt")
      .lean();

    console.log("......object - 1......");

    const userLikes = await Like.find({
      userId: req.user._id,
      blogId: { $in: allBlogs.map((blog) => blog._id) },
    }).select("blogId");

    console.log("......object - 2......");

    // converting them into set of strings for easy comparision
    const likedBlogSet = new Set(
      userLikes.map((like) => like.blogId.toString())
    );
    console.log("......object - 3......");

    const updatedBlogs = allBlogs.map((blog) => ({
      ...blog,
      likedByMe: likedBlogSet.has(blog._id.toString()),
    }));

    console.log(updatedBlogs);
    return res.json({
      success: true,
      blogs: updatedBlogs,
    });
  } catch (error) {
    console.log(error);
    return res.json({
      success: false,
      message: "Something went wrong!",
    });
  }
});

router.get("/:id", async (req, res) => {
  try {
    const blog = await Blog.findById(req.params.id).populate("createdBy", "fullName email profileImageUrl role").lean();
    const comments = await Comment.find({ blogId: req.params.id })
      .populate("createdBy")
      ;

    console.log("......object - 1......");

    const userLike = await Like.find({
      userId: req.user._id,
      blogId: blog._id,
    }).select("blogId");

    console.log("......object - 2......");

    console.log("......object - 4......");
    return res.json({
      success: true,
      blog: { ...blog, likedByMe: !!userLike.length },
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

router.post("/like/:blogId", likeController.toggelLike);

module.exports = router;
