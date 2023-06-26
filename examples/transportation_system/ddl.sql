--
-- TRANSPORTATION SYSTEM
--

-- Tables creation
create table bus_line (
   line_number integer primary key,
   description varchar(50),
   operator varchar(20)
);

create table school_district (
   district_name varchar(50) primary key,
   school_capacity integer,
   geom ast_polygon
);

create table bus_stop (
   stop_id integer primary key,
   shelter_type varchar(50),
   geom ast_node
);

create table bus_route_segment (
   traverse_time time,
   segment_number integer,
   busline integer references bus_line (line_number),
   geom ast_uniline
);

--
-- School_district and bus_stop topological relationship constraints.
--
CREATE TRIGGER school_district_contains_trigger
   AFTER INSERT OR UPDATE ON school_district
   FOR EACH STATEMENT
   EXECUTE PROCEDURE ast_spatialrelationship('school_district', 'geom', 'bus_stop', 'geom', 'contains');

--
-- Bus_route_segment and Bus_stop arc-node network constraints
--
CREATE TRIGGER busroute_insert_update_trigger
   AFTER INSERT OR UPDATE ON bus_route_segment
	FOR EACH STATEMENT
	EXECUTE PROCEDURE ast_arcnodenetwork('bus_route_segment', 'geom', 'bus_stop', 'geom');
