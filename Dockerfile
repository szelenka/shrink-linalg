FROM python:3.6-alpine
MAINTAINER Scott Zelenka (szelenka)

COPY ./library-dependencies.txt /tmp/library-dependencies.txt
COPY ./requirements.txt /tmp/requirements.txt
RUN buildDeps='build-base gcc gfortran' \
    && apk add --no-cache $buildDeps \
    && cat /tmp/library-dependencies.txt | egrep -v "^\s*(#|$)" | xargs apk add --no-cache \
    && CFLAGS="-g0 -Wl,--strip-all -I/usr/include:/usr/local/include -L/usr/lib:/usr/local/lib" \
        /usr/local/bin/pip install \
        --no-cache-dir \
        --compile \
        --global-option=build_ext \
        --global-option="-j 4" \
        -r /tmp/requirements.txt \
    && cat /tmp/library-dependencies.txt | egrep "^\s*[^#]+-dev\s*$" | xargs apk del \
    && apk del $buildDeps \
    && rm -rf /var/cache/apk/* \
    && rm -r \
        /tmp/requirements.txt \
        /tmp/library-dependencies.txt
