# ianblenke/kamailio

This is a Docker Hub autobuild repo with scripted templating to deploy an IPV6 aware Kamailio.

This will deploy painlessly under the [ianblenke/aws-6to4-docker-ipv6](https://github.com/ianblenke/aws-6to4-docker-ipv6) repository.

All IPV4 and IPV6 are auto-discovered, with sane fallbacks and defaults.

The `docker-compose.yml` is an example of what you can `docker-compose up` using the Docker Hub image built from this repository.
The `build.yml` is an example of how you can iterate locally with docker-compose while changing this project to suit your needs.

There is no authentication enabled by default. Anything can register to this kamailio instance as it stands.

This kamailio will respond to `sip:ANYTHING@registrar.A.B.C.D.xip.io:25060`, where ANYTHING is literally any username you wish, and A.B.C.D is the public IPV4 address of the server.

Unfortunately, that does not point a DNS name at an IPV6 address. For that, you will need to setup your own DNS domain name record to point at the server.

To add the alias to kamailio for your DNS name record, you will want to change the `SIP_DOMAIN` environment variable in the `docker-compose.yml`/`build.yml` to reflect the DNS name you wish to setup to point to the kamailio server.

