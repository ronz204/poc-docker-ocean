import Elysia from "elysia";
import cors from "@elysiajs/cors";
import { AuthController } from "@Controllers/auth-controller";

const Cors = (app: Elysia) => {
  return app.use(cors({ origin: "*" }));
};

const HealthCheck = (app: Elysia) => {
  return app.get("/health", () => ({ status: "healthy" }));
};

const Controllers = (app: Elysia) => {
  return app
    .use(AuthController);
};

export const Bootstrap = (app: Elysia) => {
  return app
    .use(Cors)
    .use(HealthCheck)
    .use(Controllers);
};
