# mecab-server
> A **stand-alone** mecab server for NLPers

## Requirements
```bash
Docker 18.xx
Python 3.6.X

# if you need
flake8>=3.5.0
autopep8>=1.3.5
```

## Usage
```bash
# Help
make

# Build image based on dockerfile
make build

# Run on local to debug
make dev
curl -XGET http://localhost:8080/parse?q=アルミ缶の上にあるみかん
curl -XPOST -d q=アルミ缶の上にあるみかん http://localhost:8080/parse

# Deploy on GAE
make deploy
```
