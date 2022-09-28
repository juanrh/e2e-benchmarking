FROM registry.access.redhat.com/ubi9/python-39:1-74

WORKDIR /usr/lib/benchmarks

COPY monitoring-benchmarks ./monitoring-benchmarks
COPY Makefile setup.py ./

RUN make deps
