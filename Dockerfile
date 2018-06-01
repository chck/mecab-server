FROM gcr.io/google_appengine/python:2018-05-30-140359

# Install the fortunes binary from the debian repositories.
RUN apt-get update && apt-get install -y --no-install-recommends \
      mecab \
      libmecab-dev \
      mecab-ipadic-utf8 \
      git \
      make \
      curl \
      xz-utils \
      file && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git /tmp/neologd && \
  mkdir /usr/lib/mecab/dic && \
  /tmp/neologd/bin/install-mecab-ipadic-neologd -n -u -y && \
  rm -rf /tmp/neologd
ENV MECAB_DICDIR=/usr/lib/mecab/dic/mecab-ipadic-neologd

COPY . /app/
WORKDIR /app/

ENV PYTHON_BIN_PATH="$(python3 -m site --user-base)/bin"
ENV PATH="$PATH:$PYTHON_BIN_PATH"

RUN pip3 install -U pip && pip3 install -r requirements.txt

CMD gunicorn -b :$PORT main:app
