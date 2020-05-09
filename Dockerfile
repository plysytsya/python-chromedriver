FROM python:3.7.5-slim-buster
COPY . /app
WORKDIR /app
RUN apt-get -yqq update && \
    apt-get -yqq install curl unzip && \
    apt-get -yqq install xvfb tinywm && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get -yqq update && \
    apt-get install -y gnupg2 && \
    apt update && \
    apt install -y git

# Install Google Chrome
RUN curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-get -yqq update && \
    apt-get -yqq install google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

# Install Chrome WebDriver
RUN CHROME_VERSION=$( google-chrome --version | perl -pe '($_)=/(\d+\.\d+\.\d+)/' ) && \
    CHROMEDRIVER_VERSION=$(curl https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION) && \
    wget https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip && \
    ln -s /app/chromedriver /usr/bin