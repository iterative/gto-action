FROM python:3.9-slim

RUN apt-get update && apt-get upgrade -y && apt-get install -y git && apt-get clean
RUN pip install gto==0.2.1
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]