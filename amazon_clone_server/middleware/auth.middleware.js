import jwt from 'jsonwebtoken';
import { CreateError } from '../utils/error.js';
import User from "../models/User.js";

export const auth = async (req, res, next) => {
    try{
        
        const token = req.header('x-auth-token');
        if (!token) {
            return  CreateError(401, "No auth token access Denied");
        }

        const verified = jwt.verify(token, 'passwordKey');
        if (!verified) return CreateError(401, "Token verification failed Authorization Denied");

        req.user = verified.id;
        req.token = token;
        next();

    } catch (error) {
        return CreateError(500, error.message);
    }
}

// verify admin
export const admin = async (req, res, next) => {
    try{
        const token = req.header('x-auth-token');
        if (!token) {
            return  CreateError(401, "No auth token access Denied");
        }

        const verified = jwt.verify(token, 'passwordKey');
        if (!verified) return CreateError(401, "Token verification failed Authorization Denied");

        const user = await User.findById(verified.id);
        if (!user) return CreateError(404, "User not found");
        if (user.type !== 'admin') return CreateError(401, "Authorization Denied");
        
        req.user = verified.id;
        req.token = token;
        next();

    } catch (error) {
        return CreateError(500, error.message);
    }
}

