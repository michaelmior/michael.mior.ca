---
title: "Locomotor"
template: page.pug
---

*Locomotor is available on [GitHub](https://github.com/michaelmior/locomotor)*

Server-side execution is a well-known method for improving the performance of database applications.
Running code on the database server eliminates round trips to the client application resulting in significantly reduced latency.
However, the common approach of explicitly writing server-side code in stored procedures has significant drawbacks.
Application developers must develop and maintain code in two separate languages and manually partition code between the client and server.
Code shipping is a viable alternative but still requires an explicit specification of which code can be run on the server.
We propose a hybrid shipping approach based on static analysis which automatically partitions client code and only ships code to the server which is likely to improve performance.

We demonstrate the viability of this approach in a prototype system which we call Locomotor.
Locomotor operates on Python applications using the Redis key-value store.
Through static analysis, it identifies fragments of code which can benefit from being executed on the server and automatically performs translation to execute the fragments on the server.
Unlike many previous systems, Locomotor is not pattern-based and is able to ship a wide variety of code.
By shipping code to the server, Locomotor is able to achieve significant performance gains over client-side execution with no modifications to the application code.

# Publications

<!--lint disable no-html-->
<div class="acmdlitem">
  <a href="https://www.researchgate.net/publication/319329199_Locomotor_transparent_migration_of_client-side_database_code" title="Locomotor: transparent migration of client-side database code">
    Locomotor: transparent migration of client-side database code
  </a>
  <div style="margin-left:25px">
    Michael J. Mior<br>
    In Proceedings of The 16th International Symposium on Database Programming Languages (DBPL '17)
  </div>
</div>
