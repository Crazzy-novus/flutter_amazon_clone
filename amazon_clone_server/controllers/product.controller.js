// Api to get category from url query and fetch product from database

import Product from "../models/Product.js";
import ratingSchema from "../models/Rating.js";
import { CreateSuccess } from '../utils/success.js';
import { CreateError } from "../utils/error.js";

export const getProduct = async (req, res, next) => {
    try {
        const category = req.query.category;
        const products = await Product.find({category: category});
        if (!products) {
            return next(CreateError(404, "Product not found"));
        }
        return next(CreateSuccess(200, "Product fetched successfully", products));
    } catch (error) {
        return next(CreateError(500, error.message));
    }
}

export const searchProduct = async (req, res, next) => {
    try {
        const searchQuery = req.params.name;
        const products = await Product.find({
            name: {$regex: searchQuery, $options: 'i'}
        });
        if (!products) {
            return next(CreateError(404, "Product not found"));
        }
        return next(CreateSuccess(200, "Product fetched successfully", products));
    } catch (error) {
        return next(CreateError(500, error.message));
    }
}

// Controller to get id and rating from clint and update the value in database

export const rateProduct = async (req, res, next) => {
    
    try {
        const { id, rating } = req.body;
        const product = await Product.findById (id);
        if (!product) {
            return next(CreateError(404, "Product not found"));
        }
        const isRated = product.ratings.find(r => r.userId === req.user);
        // Ddelete the data if it present

    try {
        
        if (isRated) {
            product.ratings = product.ratings.filter(r => r.userId !== req.user);
        }
        product.ratings.push({userId: req.user, rating: rating});
        await product.save();
    } catch (error) {
       
    
}
        return next(CreateSuccess(200, "Product rated successfully", product));

    } catch (error) {
        return next(CreateError(500, error.message));
    }
}

export const dealOfDay = async (req, res, next) => {
    try {
        let products = await Product.find({});
        products = products.sort((a, b) => {
            let aSum = 0;
            let bSum = 0;

            for (let i = 0; i < a.ratings.length; i++) {
                aSum += a.ratings[i].rating;
            }
            for (let i = 0; i < b.ratings.length; i++) {
                aSum += b.ratings[i].rating;
            }
            return aSum < bSum ? 1 : -1;
        });

        return next(CreateSuccess(200, "Deal of the Day Product", products[0]));
        
    } catch (error) {
        return next(CreateError(500, error.message));
    }

}