FROM node:22-alpine

WORKDIR /app

# Copiar archivos.
COPY server.js ./
COPY public/ ./public/

ENV PORT=8080
EXPOSE 8080

# El contenedor no corre como root.
USER node

# Health check.
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://127.0.0.1:8080/health || exit 1

CMD ["node", "server.js"]
