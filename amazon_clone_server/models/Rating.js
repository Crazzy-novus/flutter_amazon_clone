import mongoose from "mongoose";

const ratingSchema = new mongoose.Schema({

    userId: {
        type: String,
        required: true
    },
    rating: {
        type: Number,
        required: true
    }
});

export default ratingSchema;