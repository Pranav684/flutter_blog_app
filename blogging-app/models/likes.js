const mongoose = require("mongoose");

const likeSchema = new mongoose.Schema(
  {
    userId: {
      type: String,
      required: true,
    },
    blogId: {
      type: String,
      reuired: true,
    },
  },
  { timestamps: true }
);

likeSchema.index({userId:1,blogId:1},{unique:true});
likeSchema.index({blogId:1});

module.exports = mongoose.model("like", likeSchema);