FROM python:3-alpine3.15

WORKDIR /app
COPY . .
RUN apk add --no-cache gawk sed bash grep bc coreutils \
    && pip install -r requirements.txt \
    && chmod +x run.sh

EXPOSE 8000

CMD ["/app/run.sh"]
