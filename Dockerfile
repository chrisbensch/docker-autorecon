FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/autorecon

RUN mkdir -p /autorecon/results

COPY ./src/ /autorecon/

RUN sed -i "s/\/home\/{getuser()}\/Documents/\/autorecon\/results/g" /autorecon/autorecon

RUN apt update \
    && apt install -y sudo git python3 python3-pip \
        seclists curl gobuster dirb nbtscan nikto \
        nmap onesixtyone oscanner smbclient smbmap smtp-user-enum \
        snmp sslscan sipvicious whatweb exploitdb \
        nfs-common vim iputils-ping net-tools wget wpscan \
        smbclient python3-ldap3 python3-yaml python3-impacket \
    && python3 -m pip install -r /autorecon/requirements.txt \
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/cddmp/enum4linux-ng \
    && cd enum4linux-ng \
    && pip3 install wheel \
    && pip3 install -r requirements.txt \
    && python3 setup.py install \
    && cd / \
    && rm -rf enum4linux-ng
    
RUN git clone https://gitlab.com/saalen/ansifilter \
    && cd ansifilter \
    && make \
    && make install

#ENTRYPOINT ["autorecon"]