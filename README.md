docker-nginx
============

Docker container with an running nginx.

# Status
[![Build Status](https://travis-ci.org/bodsch/docker-nginx.svg?branch=1702-02)](https://travis-ci.org/bodsch/docker-nginx)

# Build

Your can use the included Makefile.

To build the Container: ```make build```

To remove the builded Docker Image: ```make clean```

Starts the Container: ```make run```

Starts the Container with Login Shell: ```make shell```

Entering the Container: ```make exec```

Stop (but **not kill**): ```make stop```

History ```make history```

Starts a *docker-compose*: ```make compose-up```

Remove the *docker-compose* images: ```make compose-down```


# Docker Hub

You can find the Container also at  [DockerHub](https://hub.docker.com/r/bodsch/docker-nginx/)

# Ports

 * 80
 * 443
