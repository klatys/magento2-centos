FROM registry.centos.org/centos:latest

ENV INSTALL_PKGS="git wget curl unzip rpm-build rpmdevtools php-cli php-fpm php-pdo php-mysqlnd php-opcache php-xml php-gd php-intl php-mbstring php-process php-bcmath php-json php-soap php-pecl-redis php-sodium libsodium php-pecl-amqp"


RUN echo $'[mariadb]\nname = MariaDB\nbaseurl = http://yum.mariadb.org/10.2/centos7-amd64\nenabled = 1\ngpgcheck = 1' > /etc/yum.repos.d/MariaDB.repo && \
    rpm --import https://yum.mariadb.org/RPM-GPG-KEY-MariaDB && \
    echo $'[rabbitmq_erlang]\nname=rabbitmq_erlang\nbaseurl=https://packagecloud.io/rabbitmq/erlang/el/8/$basearch\nrepo_gpgcheck=1\ngpgcheck=1\nenabled=1\ngpgkey=https://packagecloud.io/rabbitmq/erlang/gpgkey\n       https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc\nsslverify=1\nsslcacert=/etc/pki/tls/certs/ca-bundle.crt\nmetadata_expire=300\n\n[rabbitmq_erlang-source]\nname=rabbitmq_erlang-source\nbaseurl=https://packagecloud.io/rabbitmq/erlang/el/8/SRPMS\nrepo_gpgcheck=1\ngpgcheck=0\nenabled=1\ngpgkey=https://packagecloud.io/rabbitmq/erlang/gpgkey\nsslverify=1\nsslcacert=/etc/pki/tls/certs/ca-bundle.crt\nmetadata_expire=300\n\n[rabbitmq_server]\nname=rabbitmq_server\nbaseurl=https://packagecloud.io/rabbitmq/rabbitmq-server/el/8/$basearch\nrepo_gpgcheck=1\ngpgcheck=0\nenabled=1\ngpgkey=https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey\nsslverify=1\nsslcacert=/etc/pki/tls/certs/ca-bundle.crt\nmetadata_expire=300\n\n[rabbitmq_server-source]\nname=rabbitmq_server-source\nbaseurl=https://packagecloud.io/rabbitmq/rabbitmq-server/el/8/SRPMS\nrepo_gpgcheck=1\ngpgcheck=0\nenabled=1\ngpgkey=https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey\nsslverify=1\nsslcacert=/etc/pki/tls/certs/ca-bundle.crt\nmetadata_expire=300\n' > /etc/yum.repos.d/rabbitmq.repo && \
    rpm --import https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc && \
    rpm --import https://packagecloud.io/rabbitmq/erlang/gpgkey && \
    rpm --import https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey && \
    dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    dnf install -y https://rpms.remirepo.net/enterprise/remi-release-8.rpm && \
    dnf module enable php:remi-7.2 -y && \
    yum -y update --setopt=tsflags=nodocs && \
    yum -y install --setopt=tsflags=nodocs $INSTALL_PKGS && \
    php -v && \
    yum -q makecache -y --disablerepo='*' --enablerepo='rabbitmq_erlang' --enablerepo='rabbitmq_server' && \
    yum -y install socat logrotate && \
    yum -y install --repo rabbitmq_erlang --repo rabbitmq_server erlang rabbitmq-server && \
    yum -y clean all

RUN wget https://getcomposer.org/download/latest-1.x/composer.phar && \
    mv composer.phar /usr/local/bin/composer && \
    chmod +x /usr/local/bin/composer && \
    composer global require hirak/prestissimo
