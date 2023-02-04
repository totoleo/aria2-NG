FROM alpine:latest

MAINTAINER colinwjd <wjdwjd@live.cn>

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
  && apk update \
	&& apk add --no-cache --update aria2 darkhttpd wget curl \
	&& mkdir -p aria2/conf aria2/conf-temp aria2/downloads aria-ng \
  && repo="https://github.com/mayswind/AriaNg" \
  && latest=`curl -s -o /dev/null -w "%{redirect_url}" $repo"/releases/latest" | grep -Eo "[0-9]+.[0-9]*.[0-9]*"` \
  && wget -q $repo"/releases/download/"$latest"/AriaNg-"$latest".zip" \
	&& unzip "AriaNg-"$latest".zip" -d aria-ng \
	&& rm -rf "AriaNg-"$latest".zip" \
  && rm -rf /var/lib/apt/lists/*

COPY init.sh /aria2/init.sh
COPY conf-temp /aria2/conf-temp

WORKDIR /
VOLUME ["/aria2/conf", "/aria2/downloads"]
EXPOSE 6800 80 8080

CMD ["/aria2/init.sh"]
