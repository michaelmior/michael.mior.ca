---
title: Unit testing Django model mixins
author: michaelmior
date: 2012-01-14
template: article.jade
summary: "By creating a simple subclass of Django test cases, its easy to perform unit testing on mixin model classes."
---
I recently found myself having to unit test some model mixins and I thought I would share the technique I used in case anyone else finds it useful.
You could just pick a model which uses the mixin and run the test on instances of that model.
But the goal of a mixin is to provide reusable functionality independent of any model.
Instead, we create a dummy model we can use for testing.

The model shouldn't reside in `models.py` since we don’t want it in our database.
Instead, we create the model dynamically.
However, I wanted to test some functionality which requires saving the model to the database.
Fortunately, Django can construct the necessary SQL to create and destroy the database table.
We simply override setUp and tearDown to do the heavy lifting.

~~~ python
from django.test import TestCase
from django.db import connection
from django.core.management.color import no_style
from django.db.models.base import ModelBase

class ModelMixinTestCase(TestCase):
    """
    Base class for tests of model mixins. To use, subclass and specify
    the mixin class variable. A model using the mixin will be made
    available in self.model.
    """

    def setUp(self):
        # Create a dummy model which extends the mixin
        self.model = ModelBase('__TestModel__'+self.mixin.__name__, (self.mixin,),
            { '__module__': self.mixin.__module__ })

        # Create the schema for our test model
        self._style = no_style()
        sql, _ = connection.creation.sql_create_model(self.model, self._style)

        self._cursor = connection.cursor()
        for statement in sql:
            self._cursor.execute(statement)

    def tearDown(self):
        # Delete the schema for the test model
        sql = connection.creation.sql_destroy_model(self.model, (), self._style)
        for statement in sql:
            self._cursor.execute(statement)
~~~

To make use of this code, just subclass from `ModelMixinTestCase` and set the mixin class variable to the model mixin class you wish to test.
You’ll then have access to a fully functioning model which uses this mixin via `self.model`.
Happy testing!
