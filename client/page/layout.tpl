<!doctype html>
{% html lang="en" framework="LGD:static/js/mod.js" %}
    {% head %}
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="">
        <meta name="author" content="">
        <link rel="icon" href="/static/favicon.ico">
        <title>{{ title }}</title>
        {% require "LGD:static/css/bootstrap.css" %}
        {% require "LGD:static/js/jquery.js" %}
         {% require "LGD:static/js/template.js" %}
    {% endhead %}

    {% body %}
        <div id="wrapper">
            <div id="middle" class="container">
                {% block content %}
                {% endblock %}
            </div>
        </div>

    {% endbody %}

{% endhtml %}
