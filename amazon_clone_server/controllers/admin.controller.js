import User from "../models/User.js";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import Product from "../models/Product.js";
import Order from "../models/Order.js";


import { CreateSuccess } from '../utils/success.js';
import { CreateError } from "../utils/error.js";


// Add product Controller

export const addProduct = async (req, res, next) => {
    try {
        const { name, description, images, quantity, price, category } = req.body;
        let product = new Product({
            name,
            description,
            images,
            quantity,
            price,
            category
        });
            const savedProduct = await product.save();
        return next(CreateSuccess(200, "Product added successfully", savedProduct));
    } catch (error) {
        c
        return next(CreateError(500, error.message));
    }
}

// Get product Controller

export const getProduct = async (req, res, next) => {
    try {
        const products = await Product.find();
        return next(CreateSuccess(200, "Product fetched successfully", products));
    } catch (error) {
        return next(CreateError(500, error.message));
    }
}

// Delete product Controller

export const deleteProduct = async (req, res, next) => {
    try {
        const {id} = req.body;
        const product = await Product.findByIdAndDelete(id);
        if(!product){
            return next(CreateError(404, "Product not found"));
        }
        return next(CreateSuccess(200, "Product deleted successfully", product));
    } catch (error) {
        return next(CreateError(500, error.message));
    }
}

export const getOrders = async (req, res, next) => {
    try {
        const orders = await Order.find({});
        if (!orders) {
            return next(CreateError(404, "No Orders found"));
        }
        return next(CreateSuccess(200, "Orders fetched successfully", orders));
        
    } catch (error) {
        return next(CreateError(501, "Order Not fetched"));
    }
}

export const changeOrderStatus = async (req, res, next) => {
    try {
        const { id, status } = req.body;
        const order = await Order.findByIdAndUpdate(id, { status }, { new: true });
        if (!order) {
            return next(CreateError(404, "Order not found"));
        }
        return next(CreateSuccess(200, "Order status changed successfully", order));
    }
    catch (error) {
        return next(CreateError(500, error.message));
    }
}

export const analytict = async (req, res, next) => {
    try {
        const orders = await Order.find({});
        let totalEarnings = 0;
        for (let i = 0; i < orders.length; i++) {
            for (let j = 0; j < orders[i].products.length; j++) {
                totalEarnings += orders[i].products[j].quantity * orders[i].products[j].product.price;
            }
        }

        // Category wise earnings
        let categoryWiseEarnings = {};
        let categories = ['Mobiles', 'Essentials', 'Appliances', 'Books', 'Fashion'];
        for (let i = 0; i < categories.length; i++) {
            categoryWiseEarnings[categories[i]] = await fetchCategoryWiseProduct(categories[i]);
        }
        let mobileEarnings = await fetchCategoryWiseProduct("Mobiles");
    let essentialEarnings = await fetchCategoryWiseProduct("Essentials");
    let applianceEarnings = await fetchCategoryWiseProduct("Appliances");
    let booksEarnings = await fetchCategoryWiseProduct("Books");
    let fashionEarnings = await fetchCategoryWiseProduct("Fashion");

    let earnings = {
      totalEarnings,
      mobileEarnings,
      essentialEarnings,
      applianceEarnings,
      booksEarnings,
      fashionEarnings,
    };

        return next(CreateSuccess(200, "Analytics fetched successfully", earnings));

        
    } catch (error) {
        return next(CreateError(500, error.message));
    }
}

async function fetchCategoryWiseProduct(category) {
    let earnings = 0;
    let categoryOrders = await Order.find({
      "products.product.category": category,
    });
  
    for (let i = 0; i < categoryOrders.length; i++) {
      for (let j = 0; j < categoryOrders[i].products.length; j++) {
        earnings +=
          categoryOrders[i].products[j].quantity *
          categoryOrders[i].products[j].product.price;
      }
    }
    return earnings;
  } 