CREATE TABLE IF NOT EXISTS dkim (
  id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  domain      VARCHAR(255)    NOT NULL,
  selector    VARCHAR(63)     NOT NULL,
  private_key TEXT,
  public_key  TEXT,
  PRIMARY KEY (id),
  KEY idx_domain (domain)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
