# Use an existing docker image as an base.
# The OS of the Docker container automatically downloaded from docker hub.
# Tagging with 'as' to specify this is the build phase.
FROM node:alpine as builder

# Create directory in the container to copy files into. 
# This automatically selected by the copy command.
WORKDIR '/app'

# Used to bring in the package.js file. 
# Here only package.json is copied so that if changes are made 
# to other files caching is not broken.
COPY package.json .

# Install dependencies. 
RUN npm install 

# Copy the rest of the files.
COPY . .

RUN npm run build

# Second phase from new docker image.
FROM nginx

# Here we copy the relevat folders from the builder phase. 
# Copy them to the nginx server that will start automatically. 
COPY --from=builder /app/build /usr/share/nginx/html