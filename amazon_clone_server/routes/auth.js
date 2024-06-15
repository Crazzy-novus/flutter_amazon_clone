import express from 'express';
import { login, register, verifyToken, getUser } from '../controllers/auth.controller.js';
import { auth } from '../middleware/auth.middleware.js';



const router = express.Router();

// Register the User
router.post('/register', register);

// Login the User
router.post('/login', login);

router.post ('/tokenIsValid', verifyToken);

router.get ('/', auth, getUser);



// Register as admin


export default router;