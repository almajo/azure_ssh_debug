FROM debian:bullseye-slim

# Start and enable SSH
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl gnupg lsb-release openssh-server \
    && curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | tee /etc/apt/trusted.gpg.d/pgdg.asc \
    && echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends postgresql-client-17 \
    && rm -rf /var/lib/apt/lists/* \
    && echo "root:Docker!" | chpasswd

COPY sshd_config /etc/ssh/

# Expose SSH port 2222
EXPOSE 2222 8000

# Create SSH host keys and run directory
RUN mkdir -p /var/run/sshd

# Start SSH server and keep container alive
CMD ["/usr/sbin/sshd", "-D"]