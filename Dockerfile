FROM node:18.13-alpine3.16 as angular
WORKDIR /app

COPY . .

RUN npm install
RUN npm run build


FROM busybox:1.35

# Create a non-root user to own the files and run our server
RUN adduser -D static
USER static
WORKDIR /home/static

# Copy the static website
# Use the .dockerignore file to control what ends up inside the image!
COPY --from=angular /app/dist/hakathon/browser .

# Run BusyBox httpd
CMD ["busybox", "httpd", "-f", "-v", "-p", "3000"]

# docker build -t static:latest .
# docker run -it --rm --init -p 3000:3000 static:latest