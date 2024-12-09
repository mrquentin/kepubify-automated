FROM ubuntu:latest

RUN apt-get update && apt-get install -y inotify-tools wget

WORKDIR /app

RUN wget https://github.com/pgaskin/kepubify/releases/download/v4.0.4/kepubify-linux-64bit -O /app/kepubify
RUN chmod +x /app/kepubify
COPY script.sh /app/

CMD ["sh", "script.sh"]