---
title: Calcite Cassandra adapter
author: michaelmior
date: 2016-02-20
modified: 2016-03-27
template: article.jade
summary: "It is now possible to execute SQL queries over Cassandra tables using an adapter for Apache Calcite."
---

For those not familiar, [Calcite](https://calcite.apache.org/) is a generic SQL query optimizer which can execute SQL queries over multiple backend data sources.
This is a powerful concept because it allows complex queries to be executed over sources which provide much simpler interfaces from [CSV files](https://calcite.apache.org/apidocs/org/apache/calcite/adapter/csv/package-summary.html) to [MongoDB](https://calcite.apache.org/apidocs/org/apache/calcite/adapter/mongodb/package-summary.html).
Calcite is also leveraged as the cost-based-optimizer framework for the [Hive](https://cwiki.apache.org/confluence/display/Hive/Cost-based+optimization+in+Hive) data warehouse.

Much of my PhD research has revolved around generating optimized schemas for NoSQL databases such as [Cassandra](https://cassandra.apache.org/).
(For a proof-of-concept tool, check out the [NoSQL Schema Evaluator](https://github.com/michaelmior/NoSE).)
On discovering calcite, this seemed like a good fit with my work.
One of the challenges with using NoSQL databases for complex queries is the necessity of working within the restrictions set by the query language.
In previous work, I built a very simple query execution on top of Cassandra designed to execute a predefined set of query plans.
Leveraging Calcite, it is possible to execute a very complete [dialect of SQL](https://calcite.apache.org/docs/reference.html) on top of any defined data source (which calcite calls "adapters").

Unfortunately, Calcite did not already have an adapter for Cassandra.
Fortunately, writing an adapter is a fairly straightforward process, so I decided to take this on.
The simplest possible implementation of an adapter provides a set of tables along with a scan operator to retrieve all the rows in the tables.
While this is sufficient to enable Calcite to perform query execution, scanning a table in Cassandra is [very inefficient](http://www.myhowto.org/bigdata/2013/11/04/scanning-the-entire-cassandra-column-family-with-cql/).
This is a result of the fact that partitions in a Cassandra table are commonly distributed across nodes via hash partitioning.
While it is possible to retrieve all rows, they will be produced in a random order and the query will need to contact all nodes in the database.
Assuming that the query the user wants to issue does not need to touch all rows in a table, it is possible to use filtering in the Cassandra Query Language ([CQL](https://cassandra.apache.org/doc/cql/CQL.html)) to push filtering down to Cassandra.

The current version of the adapter also supports exploiting the native sort order of Cassandra tables by [clustering key](https://docs.datastax.com/en/cql/3.0/cql/ddl/ddl_compound_keys_c.html).
There is still a lot of work to be done, but an initial version of this adapter should be shipped in Calcite 1.7.0.
Until the release, you'll have to compile [from source](https://github.com/apache/calcite/).
A quick set of commands to get things running is below.

~~~sh
$ git clone https://github.com/apache/calcite.git
$ cd calcite
$ mvn install

# You will need to create a JSON document which provides connection information
# An example can be found in ./cassandra/src/test/resources/model.json
$ ./sqlline
sqlline> !connect jdbc:calcite:model=path/to/cassandra/model.json admin admin
~~~

At this point you can write SQL queries which reference your Cassandra tables.
Note that table names need to be quoted and there will likely be some failures with certain query patterns.
You can view the proposed plan for a query by prefixing it with `EXPLAIN PLAN FOR` in the `sqlline` shell.
This will show whether the query is able to exploit filtering or sorting directly in CQL.
This is a long way from making Cassandra a viable data warehouse, but it may be helpful for performing occasional analytical queries without needing to write a significant amount of code.

## Update: March 27, 2016

Calcite 1.7.0 has now been [released](https://calcite.apache.org/docs/history.html#v1-7-0) which includes the Cassandra adapter.
In addition to what was discussed above, the adapter also now automatically recognizes [materialized views](www.datastax.com/dev/blog/new-in-cassandra-3-0-materialized-views).
[Documentation](https://calcite.apache.org/docs/cassandra.html) is available on the Calcite website.
