import mongoose from "mongoose";
import { ProductSchema } from "./Product.js";

const UserSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
        trim: true
    },
    email: {
        type: String,
        required: true,
        unique: true,
        trim: true,
        validate: {
            validator:  (value) => {
                const re = /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i; 
                return value.match(re);
            },
            message: props => `${props.value} is not a valid email address`
        }
    },
    password: {
        type: String,
        required: true
    },
    address: {
        type: String,
        default: ""
    },
    type: {
        type: String,
        default: "user"
    },
    cart: [
        {
            product: ProductSchema,
            quantity: {
                type: Number,
                required: true,
        }
    }
    ]
},

{
    timestamps: true  // To store creared or modifiesd time of the record
});

export default mongoose.model( 'User', UserSchema);