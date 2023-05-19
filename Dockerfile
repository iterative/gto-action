FROM python:3.9-slim

RUN apt-get update && apt-get upgrade -y && apt-get install -y git && apt-get clean
RUN pip install gto==0.3.0-rc3 dvc==2.57.2
COPY entrypoint.sh /entrypoint.sh
COPY read_annotation.py /read_annotation.py
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
