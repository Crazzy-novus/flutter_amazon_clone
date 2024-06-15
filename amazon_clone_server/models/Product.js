import mongoose from "mongoose";
import ratingSchema from "./Rating.js";


export const ProductSchema = new mongoose.Schema({

    name: {
        type: String,
        required: true,
        trim: true
    },
    description: {
        type: String,
        required: true,
        trim: true
    },
    images: [
        {
            type: String,
            required: true
        }

    ],
    quantity: {
        type: Number,
        default: 0
    },
    price: {
        type: Number,
        required: true
    },
    category: {
        type: String,
        required: true,
        default: ""
    },
    ratings: [ratingSchema],
    
},
{
    timestamps: true  // To store creared or modifiesd time of the record
});
export default mongoose.model( 'Product', ProductSchema);
