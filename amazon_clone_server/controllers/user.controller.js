import { CreateError } from "../utils/error.js";
import { CreateSuccess } from "../utils/success.js";
import Product from "../models/Product.js";
import User from "../models/User.js";
import Order from "../models/Order.js";

export const AddCart = async(req, res, next) => {
    try {
        const {id} = req.body;
        const product = await Product.findById({_id: id});
        let user = await User.findById(req.user);
        if (user.cart.length == 0) {
            user.cart.push({product: product, quantity: 1});
        }
        else {

            let isProductFound = false;
            for (let i = 0; i < user.cart.length; i++) {
              if (user.cart[i].product._id.equals(product._id)) {
                isProductFound = true;
              }
            }
      
            if (isProductFound) {
              let producttt = user.cart.find((productt) =>
                productt.product._id.equals(product._id)
              );
              producttt.quantity += 1;
            } else {
              user.cart.push({ product, quantity: 1 });
            }
        }
        user = await user.save();
        

        return next(CreateSuccess(200, "Successfully Added to cart", user));

        
    } catch (error) {
       
        return next(CreateError(500, error.message));
    }
}

export const RemoveCart = async(req, res, next) => {
  try {
      const {id} = req.params;
      const product = await Product.findById({_id: id});
      let user = await User.findById(req.user);
      
      for (let i = 0; i < user.cart.length; i++) {
        if (user.cart[i].product._id.equals(product._id)) {
          if (user.cart[i].quantity > 1) {
            user.cart[i].quantity -= 1;
          } 
          else {
            user.cart.splice(i, 1);
        } 
      }
    }
      user = await user.save();
      

      return next(CreateSuccess(200, "Successfully Added to cart", user));

      
  } catch (error) {
      
      return next(CreateError(500, error.message));
  }
}

export const saveAddress = async(req, res, next) => {
  try {
    const {address} = req.body;
    let user = await User.findById(req.user);
    user.address = address;
    user = await user.save();
    return next(CreateSuccess(200, "Successfully Added to cart", user));

  } catch (error) {
      return next(CreateError(500, error.message));
  }
}

export const saveOrder = async(req, res, next) => {
  try {
    const {cart, totalPrice, address} = req.body;
    let products = [];

    for (let i = 0; i < cart.length; i++) {
      let product = await Product.findById(cart[i].product._id);
      if (product.quantity >= cart[i].quantity) {
        product.quantity -= cart[i].quantity;
        products.push({product, quantity: cart[i].quantity});
        await product.save();
      } else {
        return next(CreateError(400, `${product.name} is out of stock`));
      }
    }

    let user = await User.findById(req.user);
    user.cart = [];
    user = await user.save();

    let order = new Order({
      products,
      totalPrice,
      address,
      userId: req.user,
      orderAt: new Date().getTime(),
    });

    order = await order.save();

    return next(CreateSuccess(200, "Successfully Placed Order", order));

  } catch (error) {
    
    return next(CreateError(500, error.message));
  }
}

export const getOrders = async(req, res, next) => {
  try {
    let orders = await Order.find({userId: req.user});
    return next(CreateSuccess(200, "Successfully Fetched Orders", orders));

  } catch (error) {
    return next(CreateError(500, error.message));
  }
}



