FROM alpine

RUN apk update && apk add  vim \
                                 curl \
                                 wget \
                                 git \
                                 sl \
                                 iputils-ping \
                                 nginx 

WORKDIR /app

COPY . /app

ADD . /app

RUN chmod +x script.sh

ENTRYPOINT ["ping"]

CMD ["1.1.1.1"]
