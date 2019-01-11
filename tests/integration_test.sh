#!/bin/bash

TEST_DIR="$(dirname "${0}")"
DOCKER_COMPOSE=(docker-compose -f "${TEST_DIR}/docker-compose.yml")

