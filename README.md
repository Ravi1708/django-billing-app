# Simplest GST Billing app.

## Setup

The first thing to do is to clone the repository:

```sh
$ git clone https://github.com/Ravi1708/django-billing-app.git
$ cd django-billing-app
```

Create a virtual environment to install dependencies in and activate it:

```sh
$ virtualenv -p python3 venv
$ source venv/bin/activate
```

Then install the dependencies:

```sh
(env)$ pip install -r requirements.txt
```

Note the `(env)` in front of the prompt. This indicates that this terminal
session operates in a virtual environment set up by `virtualenv`.

Once `pip` has finished downloading the dependencies:

```sh
(env)$ python manage.py migrate
(env)$ python manage.py runserver
```

And navigate to `http://127.0.0.1:8000/`.

## Walkthrough

This is a simple GST billing app. It has the following features:

1. Easily create invoices
2. Manage inventory
3. Keep books and track balances
