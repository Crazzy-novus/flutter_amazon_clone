import express from 'express';
import mongoose from 'mongoose';
import AuthRoute from './routes/auth.js';
import AdminRoute from './routes/admin.js';
import ProductRoute from './routes/product.js';
import UserRoute from './routes/user.js';

const PORT = process.env.PORT||3000;
const server = express();
server.use(express.json());


server.use("/api/auth", AuthRoute);
server.use("/api/admin", AdminRoute);
server.use('/api/product', ProductRoute);
server.use('/api/user', UserRoute);



// Response Handler Middleware
server.use((obj, req, res, next) => {
    const statuscode = obj.status || 500;
    const message = obj.message || "Something went wrong";
    return res.status(statuscode).json({
        success: [200,201,204].some(a=> a === obj.status)? true : false,
        status: statuscode,
        message: message,
        stack: obj.stack,
        data: obj.data? obj.data : false
    });
});

// Mongodb Connection
const ConnetMongoDB = async () => {
    try {
        const conn = await mongoose.connect("mongodb+srv://duraivignesh:1234@meptrix.cm65kmf.mongodb.net/?retryWrites=true&w=majority&appName=flutter_amazon_clone");
        console.log('DB connected !!!!!!!!!!!!!!!');
    } catch (error) { 
       console.error('Error: ', error.message);
        console.log('DB connection failed');
    }
}

server.listen(PORT, "0.0.0.0", function check (error) {
    ConnetMongoDB();
    if (error) {
        console.error('Error: ', error);
    }
    else {
        console.log('Server is listening at http://localhost:3001');
        
    }
});