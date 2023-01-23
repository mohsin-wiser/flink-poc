CREATE DATABASE trip;

\connect trip;

CREATE TABLE trip_data
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
);
