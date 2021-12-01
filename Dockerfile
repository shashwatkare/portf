FROM python3.8-slim-buster AS builder
LABEL "maintainer"="Shashwat Kare <skare@cisco.com>"
LABEL "version"=1.0
LABEL "build-date"=$DT$

ENV PYTHONPATH "${PYTHONPATH}:/usr/app:/usr/app/src"
ENV PYTHON_BIN_PATH "/usr/bin/python3"
ENV PYTHON_INCLUDE_PATH /usr/include/python3.8m/
ENV PYTHON_LIB_PATH /usr/lib/python3.8/site-packages

RUN #pip install -U pip && pip install --no-cache-dir gunicorn gevent greenlet meinheld
RUN pip install -U pip

#RUN apt-get -y update --fix-missing && apt-get -y upgrade && apt-get -y install gcc libev-dev curl gzip nano
RUN #apt-get -y update --fix-missing && apt-get -y upgrade
RUN apt-get -y update --fix-missing

RUN mkdir -m 0700 -p /usr/app

RUN mkdir -m 0700 -p /usr/local && \
    chmod -R 777 /usr/local && \
    groupadd -r ica_group && \
    useradd -r -g ica_group ica_parser

RUN mkdir -m 0700 -p /usr/app && chmod -R 777 /usr/app

WORKDIR /usr/app

COPY . .

RUN pip install -r requirements.txt --no-cache-dir && apt-get clean && rm -rf /var/lib/apt/lists/*

USER ica_parser

CMD python src/app.py
