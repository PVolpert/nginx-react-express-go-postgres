#

# Nginx-react-express-go-postgres

## Description

This is a template for a Docker Compose that includes:

-   Nginx as Reverse Proxy
-   React as Frontend
-   Express as Backend
-   Go as Backend
-   PostgresSQL as Database

The template was heavily inspired by the [Awesome Compose Project](https://github.com/docker/awesome-compose).
Additionally I use knowledge gathered from building the [foodapp project](https://github.com/ElarOdas/foodapp).

## Purpose

Primary purpose of this template is the realization of my [master thesis project]() using the most up to date Dockerfile and Compose approaches.
Secondary purpose is to more learn about state of the art container design while finishing the project and to use that knowledge in future designs.

## Plans

At the time of development the [Docker dev environments](https://docs.docker.com/desktop/dev-environments/) are currently in beta and therefore exposed to changes. For now I do not use docker dev environments until a stable release. With the full release I plan to revisit this project.

~~The node.js backend is very large compared to the go backend. The plan is to find a method to reduce the size in a production setting.~~ Shrinked image from ~1/2 GB to 200 MB. Still not perfect but better.

In the future I might add a Worker unit using Go and Redis implementing a [communication patter](https://redis.com/redis-best-practices/communication-patterns/). As this is not needed for the thesis project the inclusion of a Worker and Redis will be postponed until after completing the thesis project.
