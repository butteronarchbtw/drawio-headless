# Docker drawio-headless

This project provides a docker image containing a headless drawio-desktop install.

It can be used to compile `.drawio` files when building docker images, e.g. when compiling LaTeX documents depending on these graphics in a reproducible environment.

## Usage

The image contains the usual `drawio` binary and a special script put at `/drawio/drawio-headless`.

> [!NOTE]
> Since drawio-desktop is an electron app, you must run it as a non-root user or with `--no-sandbox`.
> (See [this guide](https://www.docker.com/blog/understanding-the-docker-user-instruction/) for example)

This image provides drawio at *image build time*, which allows extracting the generated documents right with `docker build . -o <output dir>`.

### Example

```Dockerfile
FROM ghcr.io/butteronarchbtw/drawio-headless:latest AS graphics

RUN useradd -m -u 1000 builder

WORKDIR /graphics

COPY --chown=builder:builder ./<my drawio file>.drawio .

USER builder

RUN /drawio/drawio-headless --export --format pdf --crop --output <my pdf file>.pdf <my drawio file>.drawio

FROM scratch AS artifacts

COPY --from=graphics /graphics/<my pdf file>.pdf .
```

Running `docker build . -o output/` would create an `output/` directory containing `<my pdf file>.pdf`.

## Credits

This project is insipred by https://github.com/rlespinasse/docker-drawio-desktop-headless released under the MIT license.
