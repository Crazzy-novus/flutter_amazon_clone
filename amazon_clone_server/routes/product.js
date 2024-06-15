import express from 'express';
import { auth,  } from '../middleware/auth.middleware.js';
import { admin } from '../middleware/auth.middleware.js';
import { getProduct, searchProduct, rateProduct, dealOfDay } from '../controllers/product.controller.js';



const router = express.Router();

router.get('/get-product', auth, getProduct );
router.get('/search/:name', auth, searchProduct);
router.post('/rate-product', auth, rateProduct);
router.get ('/deal-of-day', auth, dealOfDay);
export default router;
