# -*- coding: utf-8 -*-
import os
from functools import lru_cache

from bottle import request, default_app, get, post
from natto import MeCab


@lru_cache(maxsize=None)
def tagger():
    dicdir = os.environ.get('MECAB_DICDIR')
    if dicdir:
        return MeCab('-d {}'.format(dicdir))
    else:
        return MeCab()


@get('/parse')
@post('/parse')
def parse():
    result = []
    for line in tagger().parse(request.query.q or request.forms.q).split('\n'):
        line = line.strip()
        parts = line.split('\t', 1)
        if line == 'EOS' or len(parts) <= 1:
            continue
        surface, features = parts
        result.append({
            'surface': surface,
            'features': features.split(',')
        })
    return {
        'result': result
    }


app = default_app()
