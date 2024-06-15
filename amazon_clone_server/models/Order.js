import mongoose from "mongoose";
import { ProductSchema } from "./Product.js";
 
const orderSchema = new mongoose.Schema({
    products: [
        {
            product: ProductSchema,
            quantity: {
                type: Number,
                required: true,
            },
        }
    ],
    totalPrice: {
        type: Number,
        required: true,
    },
    address: {
        type: String,
        required: true,
    },
    userId: {
        type: String,
        required: true,
    },
    orderAt: {
        type: Number,
        required: true,
    },
    status: {
        type: Number,
        default: 0,
    }
    
    
});    
export default mongoose.model( 'Order', orderSchema);