import { app } from "./app";
import { cors } from '@elysiajs/cors'


app.get("/", () => "Primary Backend OK")
    .use(cors({
        origin: 'http://localhost:3001',
        credentials: true,
    })).listen({
        port: process.env.PORT || 3000,
        hostname: '0.0.0.0'
    });