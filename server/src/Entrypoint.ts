import { Elysia } from "elysia";
import { cors } from "@elysiajs/cors";
import { HealthController } from "@Controllers/HealthController";

const app = new Elysia()
  .use(cors({ origin: "*" }))
  .use(HealthController)
  .listen(3000);

const url = `http://${app.server?.hostname}:${app.server?.port}`;
console.log(`🦊 Elysia is running at ${url}`);
