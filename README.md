# mecab-server
> a **stand-alone** mecab server for NLPers

## Requirements
```bash
Docker 17.xx
```

## Usage
```bash
# Build image based on dockerfile
docker build . -t mecab-server

# Run on local to debug
docker run --rm -p 8080:80 -e PORT=80 mecab-server
curl "http://localhost:8080/parse?q=アルミ缶の上にあるみかん"

# Deploy on GAE
gcloud app deploy --quiet
gcloud app browse -s mecab-server
```
