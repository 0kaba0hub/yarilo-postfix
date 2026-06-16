CREATE TABLE IF NOT EXISTS domain (
  id          BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  domain      VARCHAR(255)        NOT NULL,
  transport   VARCHAR(255)        NOT NULL,
  trial       TINYINT(1)          NOT NULL DEFAULT 0,
  destination VARCHAR(100)        NOT NULL DEFAULT 'smtp:127.0.0.1:3025',
  abuse       TINYINT(1)          NOT NULL DEFAULT 0,
  active      TINYINT(1)          NOT NULL DEFAULT 1,
  created     DATETIME            NOT NULL,
  modified    DATETIME            NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY ux_domain (domain)
);
