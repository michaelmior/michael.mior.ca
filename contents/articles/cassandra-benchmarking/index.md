---
title: Cassandra benchmarking
author: michaelmior
date: 2014-08-21
template: article.jade
---
I was recently trying to run some benchmarks against [Cassandra](http://cassandra.apache.org/) on [EC2](http://aws.amazon.com/ec2/) since unfortunately the servers I had in our machine room were destroyed in a fire.
For all my local testing, I used a single instance running on my desktop machine, but I wanted to ramp things up for the real benchmarks and use three nodes.
Since my workload is read-only and the dataset is fairly small, I also wanted a replication factor of three so each node would have a copy of all the data.

My first attempt to load all this data was to follow [some documentation](http://www.datastax.com/documentation/cql/3.0/cql/cql_using/update_ks_rf_t.html) provided by DataStax.
Their suggestion was to use `ALTER KEYSPACE` in CQL to change the replication factor, and then simply run `nodetool repair` on each node.
However, I found that running repair on just one node took several hours for a modest-sized amount of data (~2GB).
This was a pretty big time sink as I wanted to able to quickly spin up and down a cluster for testing.

Next I tried changing the configured replication factor locally before exporting the data.
I then simply copied the data to all nodes in the cluster and tried to start them as normal.
This created some weird conflicts as nodes seemed to be confused about who owned what portion of data.

Finally, I simply loaded up the data set on a single node and configured a replication factor of three.
I then started each node in sequence and the auto bootstrapping process took care of copying the entire dataset to each node in the cluster.
This whole process was complete in less than half an hour.
This approach wouldn't really work in a production setting since it assumes the node has no existing data (although if you can afford to bring a node offline for a while, I suppose that it might work).
In any case, this solution worked great for me and hopefully someone else finds this useful.
