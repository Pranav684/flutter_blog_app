const mongoose = require("mongoose");

const likeSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "user",
    },
    blogId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "blog",
    },
  },
  { timestamps: true }
);

likeSchema.index({ userId: 1, blogId: 1 }, { unique: true });
likeSchema.index({ blogId: 1 });

const Like= mongoose.model("like", likeSchema);
module.exports =Like;
