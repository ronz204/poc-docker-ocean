import Elysia from "elysia";
import cors from "@elysiajs/cors";
import { HealthRouter } from "@Routers/HealthRouter";

const addCors = (app: Elysia) => {
  return app.use(cors({ origin: "*" }));
};

const addRouters = (app: Elysia) => {
  return app
    .use(HealthRouter);
};

export const Bootstrap = (app: Elysia) => {
  return app
    .use(addCors)
    .use(addRouters);
};
