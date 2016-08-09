FROM fedora:24

ADD https://ftp.postgresql.org/pub/pgadmin3/pgadmin4/v1.0-beta3/pip/pgadmin4-1.0b3-py2-none-any.whl /tmp/

RUN dnf install -q -y @python
RUN dnf install -q -y @c-development python-devel postgresql-devel redhat-rpm-config && \
  pip install --user /tmp/pgadmin4-1.0b3-py2-none-any.whl && \
  dnf history -q -y rollback last-1 && \
  dnf clean all

RUN cp ~/.local/lib/python2.7/site-packages/pgadmin4/config.py ~/.local/lib/python2.7/site-packages/pgadmin4/config_local.py
RUN sed -i 's/SERVER_MODE = True/SERVER_MODE = False/' ~/.local/lib/python2.7/site-packages/pgadmin4/config_local.py
RUN sed -i 's/DEFAULT_SERVER = '\''localhost'\''/DEFAULT_SERVER = '\''0.0.0.0'\''/' ~/.local/lib/python2.7/site-packages/pgadmin4/config_local.py

EXPOSE 5050

CMD ["python", "/root/.local/lib/python2.7/site-packages/pgadmin4/pgAdmin4.py"]
