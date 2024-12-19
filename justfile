#!/usr/bin/env just --justfile
set dotenv-load := true


# Run a gleam command in each repo
gleam +ARGS:
    cd ./kv_sessions/ && gleam {{ARGS}}
    cd ./kv_sessions_ets_adapter/ && gleam {{ARGS}}
    cd ./kv_sessions_postgres_adapter/ && gleam {{ARGS}}

# CI
ci_deps +PACKAGE:
    cd {{PACKAGE}} && gleam test

ci_test +PACKAGE:
    cd {{PACKAGE}} && gleam test

ci_format +PACKAGE:
    cd {{PACKAGE}} && gleam format --check src test

ci_publish +PACKAGE:
    cd {{PACKAGE}} && gleam publish --yes

ci_check_version +PACKAGE:
    @if git diff HEAD~1 HEAD -- {{PACKAGE}}/gleam.toml | grep '^+version' > /dev/null; then \
        from_version=$(git show HEAD~1:{{PACKAGE}}/gleam.toml | grep '^version' | cut -d '"' -f2); \
        to_version=$(grep '^version' {{PACKAGE}}/gleam.toml | cut -d '"' -f2); \
        echo true; \
    else \
        echo false;\
    fi
