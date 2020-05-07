FROM continuumio/miniconda3


#RUN conda env create --file /data/conda_requirements.yaml
#RUN conda install --yes --file /data/conda_requirements.yaml

# install ms odbc driver
#https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-ver15#debian17

#sudo su
#RUN apt install -y gnupg
RUN apt-get install -y apt-utils
RUN apt-get install -y curl
RUN apt-get install -y gnupg

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list

RUN apt-get update
RUN ACCEPT_EULA=Y && \
    apt-get install msodbcsql17 
# optional: for bcp and sqlcmd
RUN ACCEPT_EULA=Y && \
    apt-get install mssql-tools 
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile && \
    echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc && \
    source ~/.bashrc && \
# optional: for unixODBC development headers
    apt-get install unixodbc-dev && \
# optional: kerberos library for debian-slim distributions
    apt-get install libgssapi-krb5-2 

# install python libraries
COPY conda_requirements.yaml /data/conda_requirements.yaml

RUN conda env update --file /data/conda_requirements.yaml  --prune


#ENTRYPOINT [ "/usr/bin/tini", "--" ]
#CMD [ "/bin/bash" ]

CMD ["python3"]
