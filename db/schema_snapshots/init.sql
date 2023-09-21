CREATE TABLE IF NOT EXISTS patients (
    id integer PRIMARY KEY NOT NULL,
    full_name varchar(255) NOT NULL,
    date_of_birth date NOT NULL,
    records_vendor varchar(255),
    vendor_id varchar(255)
);

INSERT INTO patients (
  id,
  full_name,
  date_of_birth,
  records_vendor,
  vendor_id
) VALUES (
  1,
  'Elaine Benes',
  '1988-10-12',
  NULL,
  NULL
);

INSERT INTO patients (
  id,
  full_name,
  date_of_birth,
  records_vendor,
  vendor_id
) VALUES (
  2,
  'Cosmo Kramer',
  '1987-03-18',
  'one',
  '743'
);

INSERT INTO patients (
  id,
  full_name,
  date_of_birth,
  records_vendor,
  vendor_id
) VALUES (
  3,
  'George Costanza',
  '1984-09-07',
  'two',
  '16'
);
