FROM fedora:20
#ADD https://copr.fedoraproject.org/coprs/tomprince/hybridlogic/repo/fedora-20-x86_64/tomprince-hybridlogic-fedora-20-x86_64.repo /etc/yum.repos.d/
ADD tomprince-hybridlogic-fedora-20-x86_64.repo /etc/yum.repos.d/
#RUN yum upgrade -y
RUN yum install -y python-devel python-pip gcc libffi-devel openssl-devel git s3cmd dpkg-dev createrepo_c
# A new s3cmd is necessary to use the --no-mime-magic option
RUN yum upgrade -y s3cmd
RUN ["pip", "install", "buildbot==0.8.10", "txgithub==15.0.0", "eliot", "apache-libcloud", "service_identity", "machinist", "prometheus_client"]

ADD buildbot.tac /srv/buildmaster/
ADD public_html /srv/buildmaster/public_html
ADD templates /srv/buildmaster/templates/
ADD flocker_bb /srv/buildmaster/flocker_bb
ADD slave/cloud-init.sh /srv/buildmaster/slave/cloud-init.sh
ADD config.py /srv/buildmaster/

EXPOSE 80 9989
CMD ["twistd", "--syslog", "--prefix", "buildmaster", "--pidfile", "/var/run/buildbot.pid", "-ny", "/srv/buildmaster/buildbot.tac"]
WORKDIR /srv/buildmaster/data
VOLUME ["/srv/buildmaster/data"]