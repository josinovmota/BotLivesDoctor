FROM python:latest

RUN pip install discord discord.py discord.ui python-dotenv

WORKDIR /usr/app/src
COPY bot.py ./
RUN touch ./.env

RUN pip freeze > requirements.txt
RUN pip install -r requirements.txt

CMD [ "python", "./bot.py"]
