FROM python:3

ENV PYTHONUNBUFFERED 1

WORKDIR /app

ADD ./app .

RUN apk add mysql-dev

RUN apk add mariadb-dev

RUN pip install -r requirements.txt

EXPOSE 8000

CMD ["python manage.py migrate && python manage.py runserver"]