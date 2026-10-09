# Etapa 1: baixa as fotografias ilustrativas (licença Unsplash) já otimizadas em WebP
FROM alpine:3.20 AS images
RUN apk add --no-cache curl ca-certificates
WORKDIR /img
ARG U=https://images.unsplash.com
RUN set -e; \
  get() { curl -fsSL --retry 3 -o "$1" "$2"; test -s "$1"; }; \
  get hero.webp        "$U/photo-1775756789951-3f2ef4307258?w=1200&h=1000&fit=crop&crop=entropy&q=72&fm=webp"; \
  get veicular.webp    "$U/photo-1714592734108-f1e774f95a18?w=800&h=600&fit=crop&q=70&fm=webp"; \
  get frotas.webp      "$U/photo-1766785368863-f2188a8c8b32?w=800&h=600&fit=crop&q=70&fm=webp"; \
  get cameras.webp     "$U/photo-1765959106936-851735565c12?w=800&h=600&fit=crop&q=70&fm=webp"; \
  get quinta-roda.webp "$U/photo-1788972013158-2e82e093b044?w=800&h=600&fit=crop&q=70&fm=webp"; \
  get tecnologia.webp  "$U/photo-1643686978040-beac9782e58b?w=1000&h=750&fit=crop&q=70&fm=webp"; \
  get manaus.webp      "$U/photo-1520464399004-1f1e8e938bb3?w=2000&h=860&fit=crop&crop=entropy&q=72&fm=webp"; \
  get manaus-m.webp    "$U/photo-1520464399004-1f1e8e938bb3?w=900&h=1125&fit=crop&crop=entropy&q=70&fm=webp"; \
  ls -la

# Etapa 2: servidor estático
FROM caddy:2.8.4-alpine
COPY Caddyfile /etc/caddy/Caddyfile
COPY index.html logo.png robots.txt sitemap.xml favicon.ico site.webmanifest /srv/
COPY icons /srv/icons
COPY fotos /srv/fotos
COPY --from=images /img /srv/img
EXPOSE 8080
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
