# File: docker_phx/Dockerfile
FROM elixir:1.14-alpine as build

# install build dependencies
RUN apk add --update git build-base nodejs npm yarn python3

RUN mkdir /app
WORKDIR /app

# install Hex + Rebar
RUN mix do local.hex --force, local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
copy .env .
RUN mix deps.get --only $MIX_ENV
RUN mix deps.compile

# build assets
# COPY assets assets
# RUN cd assets && npm install && npm run deploy
# RUN mix phx.digest

# build project
# COPY priv priv
# COPY lib lib
# RUN mix compile

# build release
# at this point we should copy the rel directory but
# we are not using it so we can omit it
# COPY rel rel
RUN source .env && mix release production

# prepare release image
FROM alpine:3.16 AS app

# install runtime dependencies
RUN apk add --no-cache openssl ncurses-libs libstdc++

EXPOSE 4000
ENV MIX_ENV=prod

# prepare app directory
RUN mkdir /app
WORKDIR /app

# copy release to app container
COPY --from=build /app/_build/prod/rel/production .
COPY --chown=nobody:nobody rel/start.sh .
RUN chmod +x /app/start.sh
RUN chown -R nobody: /app
USER nobody

ENV HOME=/app
CMD ["sh", "start.sh"]
