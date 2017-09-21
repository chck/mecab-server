# [START dockerfile]
FROM gcr.io/google_appengine/python:2017-08-24-232646

MAINTAINER chck <shimekiri.today@gmail.com>

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
  cd /tmp/neologd && \
  ./bin/install-mecab-ipadic-neologd -n -u -y && \
  rm -rf /tmp/neologd
ENV MECAB_DICDIR=/usr/lib/mecab/dic/mecab-ipadic-neologd

# Change the -p argument to use Python 2.7 if desired.
RUN virtualenv /env -p python3.6

# Set virtualenv environment variables. This is equivalent to running
# source /env/bin/activate.
ENV VIRTUAL_ENV /env
ENV PATH /env/bin:$PATH

COPY requirements.txt /app/
RUN pip install -r requirements.txt
COPY . /app/

CMD gunicorn -b :$PORT main:app
# [END dockerfile]
