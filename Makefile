# Detect system
UNAME := $(shell uname)
UNAME_M := $(shell uname -m)
UNAME_C := $(UNAME)_$(UNAME_M)

APP_NAME 								 ?=`grep 'app:' mix.exs | sed -e 's/\[//g' -e 's/ //g' -e 's/app://' -e 's/[:,]//g'`
APP_VSN 								 ?=`grep 'version:' mix.exs | cut -d '"' -f2`
DOCKER_IMAGE 						 ="registry.gitlab.com/jackjoe/justified/justified"
WEBPACK_PORT             =2994

SHELL 									 := /bin/bash

.SILENT: ;               # no need for @
.ONESHELL: ;             # recipes execute in same shell
.NOTPARALLEL: ;          # wait for this target to finish
.EXPORT_ALL_VARIABLES: ; # send all vars to shell
.SHELLFLAGS = -c
Makefile: ;              # skip prerequisite discovery

.PHONY: run test

run: 
	echo "source .env && iex -S mix phx.server for $(CI_COMMIT_REF_SLUG)"
	source .env && iex -S mix phx.server

run_styles:
	echo "npx tailwindcss -i ./assets/css/style.css -o ./priv/static/assets/style.css --watch"
	npx tailwindcss -i ./assets/css/style.css -o ./priv/static/assets/style.css --watch

styles:
	echo "npx tailwindcss -i ./assets/css/style.css -o ./priv/static/assets/style.css"
	npx tailwindcss -i ./assets/css/style.css -o ./priv/static/assets/style.css

cleanup:
	source .env && mix clean
	rm -rf ./priv/plts

gettext:
	source .env && mix gettext.extract
	mix gettext.merge priv/gettext --no-fuzzy

docker_build:

