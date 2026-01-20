import { Elysia, type ElysiaConfig } from "elysia";

const config: ElysiaConfig<"/health"> = {
  prefix: "/health", name: "health-router"
};

export const HealthRouter = new Elysia(config)
  .get("/health", () => ({ status: "healthy" }));
