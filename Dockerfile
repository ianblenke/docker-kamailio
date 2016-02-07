FROM alpine
MAINTAINER Ian Blenke <ian@blenke.com>

ENV KAMAILIO_VERSION 4.3.4-r1
ENV RTPPROXY_VERSION 2.0.0-r1

RUN apk update && \
    current_kamailio_version="$(apk info kamailio -d | head -1 | awk '{print $1}' | cut -d- -f2-)" && \
    if [ $KAMAILIO_VERSION != "$current_kamailio_version" ]; then \
	echo "Cannot find kamailio $KAMAILIO_VERSION in alpine package repo" ; \
	echo "Try bumping the Dockerfile KAMAILIO_VERSION to $current_kamailio_version ; \
        exit 1 ; \
    fi && \
    current_rtpproxy_version="$(apk info rtpproxy -d | head -1 | awk '{print $1}' | cut -d- -f2-)" && \
    if [ $RTPPROXY_VERSION != "$current_rtpproxy_version" ]; then \
	echo "Cannot find rtpproxy $RTPPROXY_VERSION in alpine package repo" ; \
	echo "Try bumping the Dockerfile RTPPROXY_VERSION to $current_rtpproxy_version ; \
        exit 1 ; \
    fi && \
    echo Installing: bash gettext curl $(apk search kamailio) $(apk search rtpproxy) && \
    apk add bash gettext curl\
            $(apk search kamailio | grep $KAMAILIO_VERSION | sed -e 's/-[0-9].*$//') \
            $(apk search rtpproxy | grep $RTPPROXY_VERSION | sed -e 's/-[0-9].*$//')

ADD kamailio.cfg /etc/kamailio/kamailio.cfg
ADD kamailio.sh /kamailio.sh

ADD *.tpl /etc/kamailio/

CMD /kamailio.sh
