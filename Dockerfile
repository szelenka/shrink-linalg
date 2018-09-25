FROM python:3.6-slim-jessie
MAINTAINER Scott Zelenka (szelenka)

COPY ./library-dependencies.txt /tmp/library-dependencies.txt
COPY ./requirements.txt /tmp/requirements.txt
RUN buildDeps='build-essential gcc gfortran python3-dev' \
    && apt-get update \
    && apt-get install -y $buildDeps --no-install-recommends \
    && cat /tmp/library-dependencies.txt | egrep -v "^\s*(#|$)" | xargs apt-get install -y \
    && CFLAGS="-g0 -Wl,--strip-all -I/usr/include:/usr/local/include -L/usr/lib:/usr/local/lib" \
        /usr/local/bin/pip install \
        --no-cache-dir \
        --compile \
        --global-option=build_ext \
        --global-option="-j 4" \
        -r /tmp/requirements.txt \
    && apt-get purge -y --auto-remove $buildDeps \
    && rm -rf /var/lib/apt/lists/* \
    && rm -r \
        /tmp/requirements.txt \
        /tmp/library-dependencies.txt
