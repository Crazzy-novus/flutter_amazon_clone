import express from 'express';
import { auth } from '../middleware/auth.middleware.js';
import { AddCart, RemoveCart, saveAddress, saveOrder, getOrders } from '../controllers/user.controller.js';

const router = express.Router();

router.post("/add-to-cart", auth, AddCart);
router.delete("/remove-from-cart/:id", auth, RemoveCart);
router.post('/save-address', auth, saveAddress);
router.post('/order', auth, saveOrder);
router.get('/orders/me', auth, getOrders);

export default router;