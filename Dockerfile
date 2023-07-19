FROM python:3.9-slim

RUN apt-get update && apt-get upgrade -y && apt-get install -y git && apt-get clean
COPY entrypoint.sh /entrypoint.sh
COPY read_annotation.py /read_annotation.py
COPY requirements.txt /requirements.txt
RUN pip install -r requirements.txt
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
