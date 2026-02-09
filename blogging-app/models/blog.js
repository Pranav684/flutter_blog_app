const { Schema, model, default: mongoose } = require("mongoose");

// const likeToPost = new Schema({
//   likedBy: {
//     type: mongoose.Schema.Types.ObjectId,
//     ref: "user",
//     required: true,
//   },
// });

const blogSchema = new Schema(
  {
    title: {
      type: String,
      required: true,
    },
    body: {
      type: String,
      required: true,
    },
    coverImageURL: {
      type: String,
      required: false,
    },
    likes: {
      type: Number,
      default:0,
      min:0,
    },
    createdBy: {
      type: Schema.Types.ObjectId,
      ref: "user",
    },
  },
  {
    timestamps: true,
  }
);

const Blog = model("blog", blogSchema);
module.exports = Blog;
