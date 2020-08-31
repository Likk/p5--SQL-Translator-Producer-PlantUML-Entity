CREATE TABLE gene (
  `id`       INTEGER UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name`     VARCHAR(20),
  `sequence` TEXT
);

CREATE TABLE parents (
   `left_sequence`  TEXT,
   `right_sequence` TEXT,
   `left_gene_id`   INTEGER,
   `right_gene_id`  INTEGER,
   PRIMARY KEY (`left_sequence`, `right_sequence`),
   FOREIGN KEY (`left_gene_id`)  REFERENCES gene (id),
   FOREIGN KEY (`right_gene_id`) REFERENCES gene (id)
);

CREATE TABLE children (
   `id`             INTEGER UNSIGNED    NOT NULL  AUTO_INCREMENT PRIMARY KEY,
   `gene_id`        INTEGER,
   `left_sequence`  TEXT,
   `right_sequence` TEXT,
   `sub_name`       VARCHAR(20),
   FOREIGN KEY (`left_sequence`, `right_sequence`) REFERENCES parents ( `left_sequence`, `right_sequence` ),
   FOREIGN KEY (`gene_id`) REFERENCES gene (`id`)
);
