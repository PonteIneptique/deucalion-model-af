FROM ubuntu:18.04

RUN mkdir /app
WORKDIR /app

# Base install
RUN apt-get update && apt-get install -y zip python3.6 python3.6-dev python3-venv python3-pip
RUN python3.6 -m venv venv
RUN pip3 install --upgrade pip

# Add local files
COPY templates ./templates
COPY statics ./statics
COPY flaskapp.py model.tar boot.sh ./
RUN chmod +x boot.sh

# Download and install
ADD https://github.com/emanjavacas/pie/archive/v0.1.1.zip ./
RUN unzip v0.1.1.zip && mv -f ./pie-0.1.1/* ./ && rm -rf pie-0.1.1

# Install Pie and Pie Webapp requirements
RUN pip3 install -r requirements.txt
RUN pip3 install -r requirements-app.txt

# Small checkup
# RUN ls

ENV PIE_MODEL /app/model.tar

EXPOSE 5000
ENTRYPOINT ["/app/boot.sh"]