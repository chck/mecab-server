# [START dockerfile]
FROM gcr.io/google_appengine/python

# Install the fortunes binary from the debian repositories.
RUN apt-get update && apt-get -y install \
      mecab \
      libmecab-dev \
      mecab-ipadic-utf8 \
      git \
      make \
      curl \
      xz-utils \
      file

RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git /tmp/neologd && \
  cd /tmp/neologd && \
  ./bin/install-mecab-ipadic-neologd -n -u -y && \
  rm -rf /tmp/neologd
ENV MECAB_DICDIR=/usr/lib/mecab/dic/mecab-ipadic-neologd

RUN pip install natto-py

# Change the -p argument to use Python 2.7 if desired.
RUN virtualenv /env -p python3.6

# Set virtualenv environment variables. This is equivalent to running
# source /env/bin/activate.
ENV VIRTUAL_ENV /env
ENV PATH /env/bin:$PATH

ADD requirements.txt /app/
RUN pip install -r requirements.txt
ADD . /app/

CMD gunicorn -b :$PORT main:app
# [END dockerfile]
