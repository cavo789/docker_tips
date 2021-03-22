# Using Dockerfile or put it in a script?

Sometimes, you can put actions directly in the Dockerfile (using the `RUN` command) or in a Bash script that you're still using as an entrypoint (f.i. `ENTRYPOINT [ "/bin/bash", "-c", "/home/node/.docker/app/entrypoint.sh" ]`).

There is a big difference! The file `Dockerfile` is only used when building the image (i.e. `docker-compose build`). The file `docker-compose.yml` is used every time you start `docker-compose up`.

Put in the `Dockerfile` any statements needed to build your image and make that image usable. Using the `RUN` command, the action will be put in a layer by Docker and if nothing change, the layer will be reused during the next built action. This will greatly increase the performance by reducing the time needed for the built.

Let's consider the `composer install` (or `yarn install`) action: did you need to run it every time the image is used or, only, when the image is built?

If you put it in the `Dockerfile` as a `RUN` command, while the `composer.json` file (or `package.json`) isn't modified, the layer is still valid so no need to run the command once more. That's the best choice.
