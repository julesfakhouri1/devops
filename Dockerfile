# Étape de build
FROM node:18-alpine AS builder

WORKDIR /app

# Copier les fichiers de dépendances
COPY package.json package-lock.json ./

# Installer les dépendances
RUN npm ci

# Copier le reste du code source
COPY . .

# Build de l'application
RUN npm run build

# Étape de production
FROM node:18-alpine AS runner

WORKDIR /app

# Définir les variables d'environnement pour la production
ENV NODE_ENV=production

# Copier le package.json et le package-lock.json
COPY --from=builder /app/package.json .
COPY --from=builder /app/package-lock.json .

# Installer seulement les dépendances de production
RUN npm ci --only=production

# Copier le dossier .next
COPY --from=builder /app/.next ./.next

# Copier le fichier de configuration Next.js
COPY --from=builder /app/next.config.mjs ./

# Créer un dossier public vide
RUN mkdir -p ./public

# Exposer le port 3000
EXPOSE 3000

# Commande pour démarrer l'application
CMD ["npm", "start"]