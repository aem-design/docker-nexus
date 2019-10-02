FROM        aemdesign/oracle-jdk:jdk8

MAINTAINER  devops <devops@aem.design>

LABEL   os="centos" \
        container.description="docker nexus oss container" \
        version="1.0.0" \
        imagename="nexus" \
        test.command=" java -version 2>&1 | grep 'java version' | sed -e 's/.*java version "\(.*\)".*/\1/'" \
        test.command.verify="1.8"

ARG NEXUS_VERSION="3.18.1-01"
ARG NEXUS_MAJORVERSION="3"
ARG NEXUS_DOWNLOAD_URL="https://download.sonatype.com/nexus/${NEXUS_MAJORVERSION}/nexus-${NEXUS_VERSION}-unix.tar.gz"

ENV \
    SONATYPE_DIR="/opt/sonatype" \
    NEXUS_VERSION="${NEXUS_VERSION}" \
    NEXUS_MAJORVERSION="${NEXUS_MAJORVERSION}" \
    NEXUS_DOWNLOAD_URL="${NEXUS_DOWNLOAD_URL}" \
    NEXUS_HOME="/opt/sonatype/nexus" \
    NEXUS_DATA="/nexus-data" \
    SONATYPE_WORK="/opt/sonatype/sonatype-work" \
    CONTEXT_PATH="/" \
    CONTAINER_USER="nexus" \
    CONTAINER_USERID="10002" \
    CONTAINER_GUID="10002" \
    CONTAINER_GROUP="nexus" \
    JAVA_MAX_MEM="1200m" \
    JAVA_MIN_MEM="256m" \
    EXTRA_JAVA_OPTS=""

RUN \
    groupadd -g ${CONTAINER_GUID} ${CONTAINER_GROUP} && \
    useradd -r -u ${CONTAINER_USERID} -m -c "container account" -d ${NEXUS_DATA} -g ${CONTAINER_GUID} -s /bin/false ${CONTAINER_USER} && \
    mkdir -p ${NEXUS_HOME} && mkdir -p ${NEXUS_DATA}/etc ${NEXUS_DATA}/log ${NEXUS_DATA}/tmp && mkdir -p ${SONATYPE_WORK} && \
    curl --fail --silent --location --retry 3 ${NEXUS_DOWNLOAD_URL} | gunzip | tar x -C ${NEXUS_HOME} --strip-components=1 nexus-${NEXUS_VERSION} && \
    chown -R root:root ${NEXUS_HOME} && ln -s ${NEXUS_DATA} ${SONATYPE_WORK}/nexus3 && chown -R ${CONTAINER_USER}:${CONTAINER_GROUP} ${NEXUS_DATA} && \
    sed \
        -e "s|karaf.home=.|karaf.home=/opt/sonatype/nexus|g" \
        -e "s|karaf.base=.|karaf.base=/opt/sonatype/nexus|g" \
        -e "s|karaf.etc=etc|karaf.etc=/opt/sonatype/nexus/etc|g" \
        -e "s|java.util.logging.config.file=etc|java.util.logging.config.file=/opt/sonatype/nexus/etc|g" \
        -e "s|karaf.data=data|karaf.data=${NEXUS_DATA}|g" \
        -e "s|java.io.tmpdir=data/tmp|java.io.tmpdir=${NEXUS_DATA}/tmp|g" \
        -i ${NEXUS_HOME}/bin/nexus.vmoptions && \
    sed \
        -e "s|application-port=8081|application-port=8080|g" \
        -e "s|nexus-context-path=/|nexus-context-path=${CONTEXT_PATH}|g" \
        -i ${NEXUS_HOME}/etc/nexus-default.properties

VOLUME ${NEXUS_DATA}

EXPOSE 8080 5000

WORKDIR ${NEXUS_HOME}

USER ${CONTAINER_USER}

CMD ["bin/nexus", "run"]
