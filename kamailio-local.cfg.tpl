# Enable what we require
#!define WITH_USRLOCDB
#!define WITH_DBTEXT
#!define WITH_NAT
#!define WITH_NATSIPPING
#!define WITH_PRESENCE
#!define WITH_TLS

# Setup listening interfaces
listen=tcp:${PRIVATE_IPV4}:${PRIVATE_TCP_PORT} tcp:[${PUBLIC_IPV6}]:${PRIVATE_TCP_PORT} advertise ${PUBLIC_IPV4}:${PUBLIC_TCP_PORT}
listen=tls:${PRIVATE_IPV4}:${PRIVATE_TLS_PORT} tls:[${PUBLIC_IPV6}]:${PRIVATE_TLS_PORT} advertise ${PUBLIC_IPV4}:${PUBLIC_TLS_PORT}
port=${PRIVATE_TCP_PORT}
advertised_port=${PUBLIC_TCP_PORT}
alias=${XIP_PUBLIC_DNS}
alias=${SIP_DOMAIN}
alias=${XIP_PUBLIC_DNS}:${PUBLIC_TCP_PORT}
alias=${SIP_DOMAIN}:${PUBLIC_TCP_PORT}
alias=${XIP_PUBLIC_DNS}:${PUBLIC_TLS_PORT}
alias=${SIP_DOMAIN}:${PUBLIC_TLS_PORT}

# Tweak some core settings
auto_bind_ipv6=1            # Auto-bind to all IPV6 interfaces
dns_try_ipv6=yes            # Enable IPV6 DNS queries
dns_cache_flags=4           # Prefer IPV6
dns_try_naptr=yes           # Enable NAPTR support according to RFC 3263
dns_use_search_list=no      # Do not search using domains in resolv.conf
use_dns_failover=yes        
dns_retr_time=1             # Time in seconds before retrying a dns request.
dns_retr_no=2               # Only retry the DNS lookup twice
tcp_connection_lifetime=900 # Lifetime in seconds for TCP sessions
tcp_crlf_ping=yes           # Enable SIP outbound TCP keep-alive PING-PONG
tcp_keepcnt=3               # Number of keepalives before dropping connection
tcp_syncnt=3                # Number of SYN sent before aborting a connect
tcp_keepidle=60             # Time before sending keepalives, for idle socket
tcp_keepintvl=60            # Time interval between keepalive probes
tcp_linger2=60              # Lifetime of orphaned sockets in FIN_WAIT2 state
tcp_send_timeout=10         # Seconds before TCP out connect idle will close
tcp_connect_timeout=5       # Faster detection of TCP connection problems
tcp_max_connections=4096    # tcp_conn.h: DEFAULT_TCP_MAX_CONNECTIONS 2048
