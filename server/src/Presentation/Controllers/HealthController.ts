import Elysia from "elysia";

export const HealthController = new Elysia()
  .get("/health", () => {
    return { status: "ok" };
  });
