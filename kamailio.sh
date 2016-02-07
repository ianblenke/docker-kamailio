#!/bin/bash -e

export KAMAILIO_PKG=${KAMAILIO_PKG:-24} 
export KAMAILIO_SHR=${KAMAILIO_SHR:-64} 
export KAMAILIO_CFG=${KAMAILIO_CFG:-/etc/kamailio/kamailio.cfg}

export RTP_PORT_RANGE_START=${RTP_PORT_RANGE_START:-10000}
export RTP_PORT_RANGE_END=${RTP_PORT_RANGE_END:-49152}

export PRIVATE_IPV4="${PRIVATE_IPV4:-$(ip addr show eth0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)}"

# Discover public and private IP for this instance
[ -n "$PUBLIC_IPV4" ] || \
PUBLIC_IPV4="$(curl --fail -qsH 'Metadata-Flavor: Google' http://169.254.169.254/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)}" || \
PUBLIC_IPV4="$(curl --fail -qs http://169.254.169.254/2014-11-05/meta-data/public-ipv4)" || \
PUBLIC_IPV4="$(curl --fail -qs whatismyip.akamai.com)" || \
PUBLIC_IPV4="$(curl --fail -qs ipinfo.io/ip)" || \
PUBLIC_IPV4="$(curl --fail -qs ipecho.net/plain)"
export PUBLIC_IPV4

export PUBLIC_IPV6="${PUBLIC_IPV6:-$(ip -6 addr show $(ip -6 route show default | grep -e '^default' | awk '{print $5}') | grep inet6 | grep global | awk '{print $2}' | grep -v -e '^::' | cut -d/ -f1)}"
if [ -n "$PUBLIC_IPV6" ]; then
  export PUBLIC_IPV6=::1
fi

export PUBLIC_PORT=${PUBLIC_PORT:-25060}
export PRIVATE_PORT=${PRIVATE_PORT:-25060}

# We always want this to be a known alias
export XIP_PUBLIC_DNS=registrar.${PUBLIC_IPV4}.xip.io

# This should be overrideable in docker-compose.yml
export SIP_DOMAIN=${SIP_DOMAIN:-sip.${PUBLIC_IPV4}.xip.io}

export TLS_VERIFY_CERTIFICATE=${TLS_VERIFY_CERTIFICATE:-no}
export TLS_REQUIRE_CERTIFICATE=${TLS_REQUIRE_CERTIFICATE:-no}
export TLS_PRIVATE_KEY_PATH=${TLS_PRIVATE_KEY_PATH:-/etc/kamailio/kamailio-selfsigned.key}
export TLS_CERTIFICATE_PATH=${TLS_CERTIFICATE_PATH:-/etc/kamailio/kamailio-selfsigned.pem}
export TLS_CA_CHAIN_PATH=${TLS_CA_CHAIN_PATH:-${TLS_CERTIFICATE_PATH}}

# Import Server SSL key files passed as base64+bzip2 encoded environment variables
if [ ! -s "${TLS_PRIVATE_KEY_PATH}" ]; then
  echo "${SSL_PRIVATE_KEY}" | base64 -d | bzip2 -d > ${TLS_PRIVATE_KEY_PATH}
fi
if [ ! -s "${TLS_CA_CHAIN_PATH}" ]; then
  echo "${SSL_CA_CHAIN}" | base64 -d | bzip2 -d > ${TLS_CA_CHAIN_PATH}
fi
if [ ! -s "${TLS_CERTIFICATE_PATH}" ]; then
  echo "${SSL_CERTIFICATE}" | base64 -d | bzip2 -d > ${TLS_CERTIFICATE_PATH}
fi

[ -d /etc/kamailio/dbtext ] || cp -a /usr/share/kamailio/dbtext/kamailio /etc/kamailio/dbtext 

envsubst < /etc/kamailio/kamailio-local.cfg.tpl > /etc/kamailio/kamailio-local.cfg
envsubst < /etc/kamailio/tls.cfg.tpl > /etc/kamailio/tls.cfg

case "$1" in
  bash)
    exec bash
  ;; 
  rtpproxy)
    exec rtpproxy -f -F \
                  -A ${PUBLIC_IP} -l ${PRIVATE_IP} \
                  -6 ${PUBLIC_IPV6} \
                  -s udp:localhost:7722 \
                  -m ${RTP_PORT_RANGE_START} \
                  -M ${RTP_PORT_RANGE_END}
  ;;
  *)
    exec kamailio -f $KAMAILIO_CFG -M $KAMAILIO_PKG -m $KAMAILIO_SHR -DD -E -e
  ;;
esac
