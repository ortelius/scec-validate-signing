FROM cgr.dev/chainguard/go@sha256:bf24a98bd1a558b382ab6fc838ae06602ef40ef603ffe8f3e97f3e3465b14b39 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:b1620a369a98f45856657820fb8203adbc8b823ba7019c3bd84185ce45f7b395

WORKDIR /app

COPY --from=builder /app/main .
COPY --from=builder /app/docs docs

ENV ARANGO_HOST localhost
ENV ARANGO_USER root
ENV ARANGO_PASS rootpassword
ENV ARANGO_PORT 8529
ENV MS_PORT 8080

EXPOSE 8080

ENTRYPOINT [ "/app/main" ]
