#!/usr/bin/env just --justfile
set dotenv-load := true

# Run a gleam command in each repo
gleam +ARGS:
    cd ./kv_sessions/ && gleam {{ARGS}}
    cd ./kv_sessions_ets_adapter/ && gleam {{ARGS}}
    cd ./kv_sessions_postgres_adapter/ && gleam {{ARGS}}
    
