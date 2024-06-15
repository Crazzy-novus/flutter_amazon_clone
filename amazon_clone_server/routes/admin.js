import express from 'express';
import { admin } from '../middleware/auth.middleware.js';
import { addProduct, getProduct,deleteProduct, getOrders, changeOrderStatus, analytict } from '../controllers/admin.controller.js';



const router = express.Router();

router.post ('/add-product', admin, addProduct );
router.get ('/get-product', admin, getProduct );
router.delete('/delete-product', admin, deleteProduct);
router.get('/get-orders', admin, getOrders);
router.post('/change-order-status', admin, changeOrderStatus);
router.get('/analytics', admin, analytict);




// Register as admin


export default router;