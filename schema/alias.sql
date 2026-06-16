CREATE TABLE IF NOT EXISTS alias (
  id       BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  address  VARCHAR(255)        NOT NULL,
  goto     MEDIUMTEXT          NOT NULL,
  domain   VARCHAR(255)        NOT NULL,
  active   TINYINT(1)          NOT NULL DEFAULT 1,
  created  DATETIME            NOT NULL,
  modified DATETIME            NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY ux_address (address),
  KEY      idx_domain  (domain),
  KEY      idx_goto    (goto(64))
);
