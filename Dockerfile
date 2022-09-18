# File: docker_phx/Dockerfile
FROM elixir:1.14-alpine as build

# install build dependencies
RUN apk add --update git build-base nodejs npm yarn python3

RUN mkdir /app
WORKDIR /app

# copy all application files
copy . ./

# install Hex + Rebar
RUN mix do local.hex --force, local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
RUN mix deps.get --only $MIX_ENV
RUN mix phx.digest

# build release
RUN mix release

# prepare release image
FROM alpine:3.16 AS app

# install runtime dependencies
RUN apk add --no-cache openssl ncurses-libs libstdc++

EXPOSE 4000
ENV MIX_ENV=prod
ENV USER="elixir"

# prepare app directory
RUN mkdir /app
WORKDIR /app

# copy release to app container
COPY --from=build /app/_build/${MIX_ENV}/rel/production .
RUN chown -R nobody: /app
USER nobody

ENTRYPOINT ["bin/production"]
CMD ["start"]
