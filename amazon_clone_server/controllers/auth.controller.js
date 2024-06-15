
import User from "../models/User.js";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";


import { CreateSuccess } from '../utils/success.js';
import { CreateError } from "../utils/error.js";


export const register  = async (req, res, next) => {
   
   
    try {
        const salt = await bcrypt.genSalt(10); // generate salt for hashing the password
        const hashedPassword = await bcrypt.hash(req.body.password, salt); // hash the password
        const newUser = new User({ // create a new user 
        email: req.body.email,//
        password: hashedPassword,
        name: req.body.name,
    });
    await newUser.save(); // save the user to the database
    return next(CreateSuccess(200, "User registered Successfully ", newUser));
    } catch (error) {
        
        return next(CreateError(500, error.message));
    }
}

export const login = async (req, res, next) => {
    
    try {
        const user = await User.findOne({email: req.body.email});// find the user by email 

        if (!user) { // check if the user exists
            return next(CreateError(400, "User not found"));
        }
        

        const validPassword = await bcrypt.compare(req.body.password, user.password); // compare the password
        if (!validPassword) { // check if the password is valid
            return next(CreateError(400, "Invalid Password"));
        }

        const token = jwt.sign({id: user._id}, "passwordKey"); // generate a token
        
        return next(CreateSuccess(200, "User logged in Successfully", {token: token, ...user._doc})); // send a success message
         // send a success message
    } catch (error) {
        return next(CreateError(500, error.message));
    }
    
}

export const verifyToken = async (req, res, next) => {
    
    try {

        const token = req.header('x-auth-token');

        if (!token) return CreateError(404, "Token Not Valid");
        const verified = jwt.verify(token, 'passwordKey');
        if (!verified) return CreateError(404, "Authorization Denied");

        const user = await User.findById(verified.id);

        if (!user) return CreateError(404, "User not found");
        
        return CreateSuccess(200, "Token Verified");
        
    } catch (error) {
        return CreateError(500, error.message);
    }
    
}

export const getUser = async (req, res, next) => {
    try {
        const user =  await User.findById(req.user);
        if (!user) return next(CreateError(404, "User not found"));
        return next(CreateSuccess(200, "User Found Success", {...user._doc,token: req.token}));
    } catch (error) {
        return next(CreateError(500, error.message));
    }
}