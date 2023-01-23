DROP TABLE src_trip_data;
CREATE TABLE src_trip_data
    (
        trip_id INT,
        start_time TIMESTAMP,
        end_time TIMESTAMP,
        bikeid INT,
        tripduration INT,
        from_station_id INT,
        from_station_name VARCHAR,
        to_station_id INT,
        to_station_name VARCHAR,
        usertype VARCHAR,
        gender VARCHAR,
        birthyear VARCHAR
) WITH (
  'connector' = 'postgres-cdc',
  'hostname' = 'postgres',
  'port' = '5432',
  'username' = 'postgres',
  'password' = 'postgres',
  'database-name' = 'trip',
  'schema-name' = 'public',
  'table-name' = 'trip_data',
  'decoding.plugin.name'= 'pgoutput'
);

select count(*) from src_trip_data;



DROP TABLE trg_trip_data;
CREATE TABLE trg_trip_data
    (
        trip_id INT,
        start_time TIMESTAMP,
        end_time TIMESTAMP,
        bikeid INT,
        tripduration INT,
        from_station_id INT,
        from_station_name VARCHAR,
        to_station_id INT,
        to_station_name VARCHAR,
        usertype VARCHAR,
        gender VARCHAR,
        birthyear VARCHAR    
) WITH (
  'connector'='iceberg',
  'catalog-name'='hadoop_prod',
  'catalog-type'='hadoop',
  'warehouse'='hdfs://localhost:9000/warehouse/lakehouse',
  'property-version'='1',
  'database-name' = 'default_database',
  'table-name' = 'trg_trip_data',
  'decoding.plugin.name'= 'pgoutput',
);


insert into trg_trip_data select * from src_trip_data;

select * from trg_trip_data;


CREATE TABLE test
    (
        trip_id INT
) WITH (
    'connector'='iceberg',
    'catalog-name'='s3',
    'catalog-type'='hadoop',
    's3.endpoint'='http://minio:9000',
    's3.warehouse'='s3a://lakehouse/',
    's3.access-key'='3JgaDfIIjVwnnUhy',
    's3.secret-key'='faEICXUIHPeAIo0zrLYhiDK44mIA6Xup',
    's3.path.style.access'='true',
    'warehouse'='/db'
);