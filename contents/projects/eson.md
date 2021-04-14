---
title: "NoSQL conceptual modeling"
template: page.jade
---

## Conceptual modeling for NoSQL

Conceptual models such as the entity-relationship (ER) model have proved incredibly useful for relational database design.
One of the goals of this line of research is to understand how conceptual models can be used for modeling NoSQL databases.
This includes understanding how changes to a databases conceptual model may effect both the schema and the data stored in the underlying database.

## Database renormalization

Constructing a normalized model from a NoSQL database is a challenging problem.
Traditional normalization algorithms such as lossless join BCNF decomposition fail to appropriately handle the forms of denormalization present in NoSQL databases.
Appropriate algorithms for constructing a normalized schema from NoSQL databases are a critical step in performing meaningful data integration with other sources.

*An implementation of our ESON normalization algorithm is available on [GitHub](https://github.com/michaelmior/eson)*

# Publications

<!--lint disable no-html-->

<div class="acmdlitem">
  <a href="https://ieeexplore.ieee.org/document/9378228" title="Maintaining NoSQL Database Quality During Conceptual Model Evolution">
    Maintaining NoSQL Database Quality During Conceptual Model Evolution
  </a>
  <div style="margin-left:25px">
    Pablo Suárez-Otero, Michael J. Mior, Maria José Suárez-Cabal, Javier Tuya<br>
    6th International Workshop on Methods to Improve Big Data Science Projects
  </div>
</div>

<div class="acmdlitem">
  <a href="https://www.researchgate.net/publication/327878732_Renormalization_of_NoSQL_Database_Schemas_37th_International_Conference_ER_2018_Xi'an_China_October_22-25_2018_Proceedings" title="Renormalization of NoSQL Database Systems">
    Renormalization of NoSQL Database Systems
  </a>
  <div style="margin-left:25px">
    Michael J. Mior, Kenneth Salem
    ER '18 Proceedings of the 36th International Conference on Conceptual Modeling, 2018
  </div>
</div>
