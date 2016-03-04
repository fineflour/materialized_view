--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: address_transitions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE address_transitions (
    id integer NOT NULL,
    to_state character varying(255),
    metadata text DEFAULT '{}'::text,
    sort_key integer,
    order_exception_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: address_transitions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE address_transitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: address_transitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE address_transitions_id_seq OWNED BY address_transitions.id;


--
-- Name: api_request_logs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE api_request_logs (
    id integer NOT NULL,
    request text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: api_request_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE api_request_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: api_request_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE api_request_logs_id_seq OWNED BY api_request_logs.id;


--
-- Name: blacklisted_addresses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE blacklisted_addresses (
    id integer NOT NULL,
    delivery_point_barcode character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    order_id integer
);


--
-- Name: blacklisted_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE blacklisted_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: blacklisted_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE blacklisted_addresses_id_seq OWNED BY blacklisted_addresses.id;


--
-- Name: database_structures; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE database_structures (
    id integer NOT NULL
);


--
-- Name: database_structures_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE database_structures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: database_structures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE database_structures_id_seq OWNED BY database_structures.id;


--
-- Name: delayed_jobs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE delayed_jobs (
    id integer NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    attempts integer DEFAULT 0 NOT NULL,
    handler text NOT NULL,
    last_error text,
    run_at timestamp without time zone,
    locked_at timestamp without time zone,
    failed_at timestamp without time zone,
    locked_by character varying(255),
    queue character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE delayed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE delayed_jobs_id_seq OWNED BY delayed_jobs.id;


--
-- Name: distribution_centers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE distribution_centers (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: distribution_centers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE distribution_centers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: distribution_centers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE distribution_centers_id_seq OWNED BY distribution_centers.id;


--
-- Name: exception_logs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE exception_logs (
    id integer NOT NULL,
    rake_task_duration integer,
    address_exception_found integer,
    log_summary character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    total_ops_checked integer,
    limit_exception_found integer,
    total_orders integer
);


--
-- Name: exception_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE exception_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exception_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE exception_logs_id_seq OWNED BY exception_logs.id;


--
-- Name: impb_configurations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE impb_configurations (
    id integer NOT NULL,
    piece_start_number integer,
    container_start_number integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: impb_configurations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE impb_configurations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: impb_configurations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE impb_configurations_id_seq OWNED BY impb_configurations.id;


--
-- Name: inventory_adjustments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE inventory_adjustments (
    id integer NOT NULL,
    quantity integer,
    description text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    material_id integer,
    user_id integer
);


--
-- Name: inventory_adjustments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE inventory_adjustments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventory_adjustments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE inventory_adjustments_id_seq OWNED BY inventory_adjustments.id;


--
-- Name: mailing_configurations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE mailing_configurations (
    id integer NOT NULL,
    minimum_size integer,
    kind character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    label_model_number character varying(255),
    max_address_line_length integer,
    distribution character varying(255),
    maximum_size integer,
    weight double precision,
    labels_per_sheet integer
);


--
-- Name: mailing_configurations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mailing_configurations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mailing_configurations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mailing_configurations_id_seq OWNED BY mailing_configurations.id;


--
-- Name: materials; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE materials (
    id integer NOT NULL,
    name character varying(255),
    description text,
    language character varying(255),
    weight double precision,
    length double precision,
    height double precision,
    width double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    shortname character varying(255),
    active boolean DEFAULT true,
    quantity integer DEFAULT 0,
    velocity_30_day integer DEFAULT 0,
    velocity_60_day integer DEFAULT 0,
    velocity_90_day integer DEFAULT 0,
    velocity_180_day integer DEFAULT 0,
    census_quantity integer,
    censused_at timestamp without time zone,
    distribution_center_id integer
);


--
-- Name: materials_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE materials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: materials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE materials_id_seq OWNED BY materials.id;


--
-- Name: models; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE models (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: models_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE models_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: models_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE models_id_seq OWNED BY models.id;


--
-- Name: non_ops_distribution_totals; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE non_ops_distribution_totals (
    id integer NOT NULL,
    product integer,
    total integer,
    note character varying(255),
    entered_by character varying(255),
    report_date timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: non_ops_distribution_totals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE non_ops_distribution_totals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: non_ops_distribution_totals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE non_ops_distribution_totals_id_seq OWNED BY non_ops_distribution_totals.id;


--
-- Name: notes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE notes (
    id integer NOT NULL,
    content text,
    order_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    entered_by character varying(255)
);


--
-- Name: notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notes_id_seq OWNED BY notes.id;


--
-- Name: order_exceptions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE order_exceptions (
    id integer NOT NULL,
    orderproduct_id integer,
    type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: order_exceptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE order_exceptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: order_exceptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE order_exceptions_id_seq OWNED BY order_exceptions.id;


--
-- Name: order_search_matviews; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE order_search_matviews (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: order_search_matviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE order_search_matviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: order_search_matviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE order_search_matviews_id_seq OWNED BY order_search_matviews.id;


--
-- Name: orderproduct_transitions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE orderproduct_transitions (
    id integer NOT NULL,
    to_state character varying(255),
    metadata text DEFAULT '{}'::text,
    sort_key integer,
    orderproduct_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: orderproduct_transitions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE orderproduct_transitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: orderproduct_transitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE orderproduct_transitions_id_seq OWNED BY orderproduct_transitions.id;


--
-- Name: orderproducts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE orderproducts (
    id integer NOT NULL,
    order_id integer,
    product_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    pallet_id integer,
    legacy_id integer,
    current_state character varying(255)
);


--
-- Name: orderproducts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE orderproducts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: orderproducts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE orderproducts_id_seq OWNED BY orderproducts.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE orders (
    id integer NOT NULL,
    firstname character varying(255),
    lastname character varying(255),
    address1 character varying(255),
    address2 character varying(255),
    city character varying(255),
    state character varying(255),
    zip character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    email character varying(255),
    address_hash character varying(255),
    name_hash character varying(255),
    legacy_id integer,
    phone character varying(255),
    request_method character varying(255),
    search_body text,
    language_spoken character varying(255),
    how_heard character varying(255),
    requests_further_contact boolean DEFAULT false,
    skip_limit_check boolean DEFAULT false,
    delivery_type character varying(255) DEFAULT 'bulk'::character varying,
    type character varying(255),
    ip_address character varying(255),
    latitude double precision,
    longitude double precision,
    geocoded_at timestamp without time zone
);


--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE orders_id_seq OWNED BY orders.id;


--
-- Name: pallets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pallets (
    id integer NOT NULL,
    shipped_at timestamp without time zone,
    status character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    address_label_data text,
    mailing_configuration_id integer,
    legacy_id integer,
    impb_configuration_id integer
);


--
-- Name: pallets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pallets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pallets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pallets_id_seq OWNED BY pallets.id;


--
-- Name: product_materials; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE product_materials (
    id integer NOT NULL,
    product_id integer,
    material_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: product_materials_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE product_materials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_materials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE product_materials_id_seq OWNED BY product_materials.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE products (
    id integer NOT NULL,
    name character varying(255),
    shortname character varying(255),
    active boolean DEFAULT true,
    description text,
    language character varying(255),
    author character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    mailing_configuration_id integer
);


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE products_id_seq OWNED BY products.id;


--
-- Name: reports; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE reports (
    id integer NOT NULL,
    name character varying(255),
    cities text,
    begin_date date,
    end_date date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    state character varying(255),
    filters character varying(255),
    language_spoken character varying(255)
);


--
-- Name: reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE reports_id_seq OWNED BY reports.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: smarty_streets_responses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE smarty_streets_responses (
    id integer NOT NULL,
    match_code character varying(255),
    footnotes text,
    order_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    record_type character varying(255),
    zip_type character varying(255),
    county_fips character varying(255),
    county_name character varying(255),
    carrier_route character varying(255),
    congressional_district character varying(255),
    rdi character varying(255),
    elot_sequence character varying(255),
    elot_sort character varying(255),
    latitude double precision,
    longitude double precision,
    "precision" character varying(255),
    time_zone character varying(255),
    utc_offset integer,
    dst boolean,
    delivery_point_barcode character varying(255)
);


--
-- Name: smarty_streets_responses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE smarty_streets_responses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: smarty_streets_responses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE smarty_streets_responses_id_seq OWNED BY smarty_streets_responses.id;


--
-- Name: uniquecities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE uniquecities (
    id integer NOT NULL,
    city character varying(255),
    state character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: uniquecities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE uniquecities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: uniquecities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE uniquecities_id_seq OWNED BY uniquecities.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    name character varying(255),
    role integer DEFAULT 0
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: versions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE versions (
    id integer NOT NULL,
    item_type character varying(255) NOT NULL,
    item_id integer NOT NULL,
    event character varying(255) NOT NULL,
    whodunnit character varying(255),
    object text,
    created_at timestamp without time zone,
    object_changes text
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE versions_id_seq OWNED BY versions.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY address_transitions ALTER COLUMN id SET DEFAULT nextval('address_transitions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY api_request_logs ALTER COLUMN id SET DEFAULT nextval('api_request_logs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY blacklisted_addresses ALTER COLUMN id SET DEFAULT nextval('blacklisted_addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY database_structures ALTER COLUMN id SET DEFAULT nextval('database_structures_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY delayed_jobs ALTER COLUMN id SET DEFAULT nextval('delayed_jobs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY distribution_centers ALTER COLUMN id SET DEFAULT nextval('distribution_centers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY exception_logs ALTER COLUMN id SET DEFAULT nextval('exception_logs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY impb_configurations ALTER COLUMN id SET DEFAULT nextval('impb_configurations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY inventory_adjustments ALTER COLUMN id SET DEFAULT nextval('inventory_adjustments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mailing_configurations ALTER COLUMN id SET DEFAULT nextval('mailing_configurations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY materials ALTER COLUMN id SET DEFAULT nextval('materials_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY models ALTER COLUMN id SET DEFAULT nextval('models_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY non_ops_distribution_totals ALTER COLUMN id SET DEFAULT nextval('non_ops_distribution_totals_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notes ALTER COLUMN id SET DEFAULT nextval('notes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY order_exceptions ALTER COLUMN id SET DEFAULT nextval('order_exceptions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY order_search_matviews ALTER COLUMN id SET DEFAULT nextval('order_search_matviews_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY orderproduct_transitions ALTER COLUMN id SET DEFAULT nextval('orderproduct_transitions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY orderproducts ALTER COLUMN id SET DEFAULT nextval('orderproducts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY orders ALTER COLUMN id SET DEFAULT nextval('orders_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pallets ALTER COLUMN id SET DEFAULT nextval('pallets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY product_materials ALTER COLUMN id SET DEFAULT nextval('product_materials_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY products ALTER COLUMN id SET DEFAULT nextval('products_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY reports ALTER COLUMN id SET DEFAULT nextval('reports_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY smarty_streets_responses ALTER COLUMN id SET DEFAULT nextval('smarty_streets_responses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY uniquecities ALTER COLUMN id SET DEFAULT nextval('uniquecities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY versions ALTER COLUMN id SET DEFAULT nextval('versions_id_seq'::regclass);


--
-- Name: orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: order_search_matview; Type: MATERIALIZED VIEW; Schema: public; Owner: -; Tablespace: 
--

CREATE MATERIALIZED VIEW order_search_matview AS
 SELECT o.id AS pg_search_id,
    o.created_at,
    o.firstname,
    o.lastname,
    o.email,
    o.address1,
    o.address2,
    o.city,
    o.state,
    o.search_body,
    array_to_string(array_agg(op.product_id), ','::text) AS pid,
    array_to_string(array_agg(p.name), ','::text) AS pname
   FROM ((orders o
     JOIN orderproducts op ON ((op.order_id = o.id)))
     JOIN products p ON ((op.product_id = p.id)))
  GROUP BY o.id
  ORDER BY o.id DESC
  WITH NO DATA;


--
-- Name: address_transitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY address_transitions
    ADD CONSTRAINT address_transitions_pkey PRIMARY KEY (id);


--
-- Name: api_request_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY api_request_logs
    ADD CONSTRAINT api_request_logs_pkey PRIMARY KEY (id);


--
-- Name: blacklisted_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY blacklisted_addresses
    ADD CONSTRAINT blacklisted_addresses_pkey PRIMARY KEY (id);


--
-- Name: database_structures_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY database_structures
    ADD CONSTRAINT database_structures_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY delayed_jobs
    ADD CONSTRAINT delayed_jobs_pkey PRIMARY KEY (id);


--
-- Name: distribution_centers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY distribution_centers
    ADD CONSTRAINT distribution_centers_pkey PRIMARY KEY (id);


--
-- Name: exception_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY exception_logs
    ADD CONSTRAINT exception_logs_pkey PRIMARY KEY (id);


--
-- Name: impb_configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY impb_configurations
    ADD CONSTRAINT impb_configurations_pkey PRIMARY KEY (id);


--
-- Name: inventory_adjustments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY inventory_adjustments
    ADD CONSTRAINT inventory_adjustments_pkey PRIMARY KEY (id);


--
-- Name: mailing_configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mailing_configurations
    ADD CONSTRAINT mailing_configurations_pkey PRIMARY KEY (id);


--
-- Name: materials_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY materials
    ADD CONSTRAINT materials_pkey PRIMARY KEY (id);


--
-- Name: models_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY models
    ADD CONSTRAINT models_pkey PRIMARY KEY (id);


--
-- Name: non_ops_distribution_totals_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY non_ops_distribution_totals
    ADD CONSTRAINT non_ops_distribution_totals_pkey PRIMARY KEY (id);


--
-- Name: notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);


--
-- Name: order_exceptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY order_exceptions
    ADD CONSTRAINT order_exceptions_pkey PRIMARY KEY (id);


--
-- Name: order_search_matviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY order_search_matviews
    ADD CONSTRAINT order_search_matviews_pkey PRIMARY KEY (id);


--
-- Name: orderproduct_transitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY orderproduct_transitions
    ADD CONSTRAINT orderproduct_transitions_pkey PRIMARY KEY (id);


--
-- Name: orderproducts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY orderproducts
    ADD CONSTRAINT orderproducts_pkey PRIMARY KEY (id);


--
-- Name: pallets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pallets
    ADD CONSTRAINT pallets_pkey PRIMARY KEY (id);


--
-- Name: product_materials_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY product_materials
    ADD CONSTRAINT product_materials_pkey PRIMARY KEY (id);


--
-- Name: products_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- Name: smarty_streets_responses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY smarty_streets_responses
    ADD CONSTRAINT smarty_streets_responses_pkey PRIMARY KEY (id);


--
-- Name: uniquecities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY uniquecities
    ADD CONSTRAINT uniquecities_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_priority; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX delayed_jobs_priority ON delayed_jobs USING btree (priority, run_at);


--
-- Name: index_address_transitions_on_order_exception_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_address_transitions_on_order_exception_id ON address_transitions USING btree (order_exception_id);


--
-- Name: index_address_transitions_on_sort_key_and_order_exception_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_address_transitions_on_sort_key_and_order_exception_id ON address_transitions USING btree (sort_key, order_exception_id);


--
-- Name: index_mailing_configurations_on_kind; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_mailing_configurations_on_kind ON mailing_configurations USING btree (kind);


--
-- Name: index_models_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_models_on_email ON models USING btree (email);


--
-- Name: index_models_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_models_on_reset_password_token ON models USING btree (reset_password_token);


--
-- Name: index_notes_on_order_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notes_on_order_id ON notes USING btree (order_id);


--
-- Name: index_order_exceptions_on_id_and_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_order_exceptions_on_id_and_type ON order_exceptions USING btree (id, type);


--
-- Name: index_order_exceptions_on_orderproduct_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_order_exceptions_on_orderproduct_id ON order_exceptions USING btree (orderproduct_id);


--
-- Name: index_orderproduct_transitions_on_orderproduct_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_orderproduct_transitions_on_orderproduct_id ON orderproduct_transitions USING btree (orderproduct_id);


--
-- Name: index_orderproduct_transitions_on_sort_key_and_orderproduct_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_orderproduct_transitions_on_sort_key_and_orderproduct_id ON orderproduct_transitions USING btree (sort_key, orderproduct_id);


--
-- Name: index_orderproducts_on_current_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_orderproducts_on_current_state ON orderproducts USING btree (current_state);


--
-- Name: index_orderproducts_on_legacy_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_orderproducts_on_legacy_id ON orderproducts USING btree (legacy_id);


--
-- Name: index_orderproducts_on_order_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_orderproducts_on_order_id ON orderproducts USING btree (order_id);


--
-- Name: index_orderproducts_on_order_id_and_product_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_orderproducts_on_order_id_and_product_id ON orderproducts USING btree (order_id, product_id);


--
-- Name: index_orderproducts_on_pallet_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_orderproducts_on_pallet_id ON orderproducts USING btree (pallet_id);


--
-- Name: index_orderproducts_on_product_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_orderproducts_on_product_id ON orderproducts USING btree (product_id);


--
-- Name: index_orders_on_created_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_orders_on_created_at ON orders USING btree (created_at);


--
-- Name: index_orders_on_legacy_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_orders_on_legacy_id ON orders USING btree (legacy_id);


--
-- Name: index_pallets_on_created_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_pallets_on_created_at ON pallets USING btree (created_at);


--
-- Name: index_pallets_on_impb_configuration_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_pallets_on_impb_configuration_id ON pallets USING btree (impb_configuration_id);


--
-- Name: index_pallets_on_legacy_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_pallets_on_legacy_id ON pallets USING btree (legacy_id);


--
-- Name: index_pallets_on_mailing_configuration_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_pallets_on_mailing_configuration_id ON pallets USING btree (mailing_configuration_id);


--
-- Name: index_product_materials_on_material_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_product_materials_on_material_id ON product_materials USING btree (material_id);


--
-- Name: index_product_materials_on_product_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_product_materials_on_product_id ON product_materials USING btree (product_id);


--
-- Name: index_products_on_mailing_configuration_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_products_on_mailing_configuration_id ON products USING btree (mailing_configuration_id);


--
-- Name: index_smarty_streets_responses_on_order_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_smarty_streets_responses_on_order_id ON smarty_streets_responses USING btree (order_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_name ON users USING btree (name);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_versions_on_item_type_and_item_id ON versions USING btree (item_type, item_id);


--
-- Name: order_search_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX order_search_id ON order_search_matview USING btree (pg_search_id);


--
-- Name: search_body_gin; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX search_body_gin ON orders USING gin (to_tsvector('simple'::regconfig, COALESCE(search_body, ''::text)));


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20140709202429');

INSERT INTO schema_migrations (version) VALUES ('20140710165322');

INSERT INTO schema_migrations (version) VALUES ('20140710172342');

INSERT INTO schema_migrations (version) VALUES ('20140710174042');

INSERT INTO schema_migrations (version) VALUES ('20140710175943');

INSERT INTO schema_migrations (version) VALUES ('20140710182514');

INSERT INTO schema_migrations (version) VALUES ('20140711180626');

INSERT INTO schema_migrations (version) VALUES ('20140711181619');

INSERT INTO schema_migrations (version) VALUES ('20140715153337');

INSERT INTO schema_migrations (version) VALUES ('20140724163046');

INSERT INTO schema_migrations (version) VALUES ('20140725184407');

INSERT INTO schema_migrations (version) VALUES ('20140729180030');

INSERT INTO schema_migrations (version) VALUES ('20140808125337');

INSERT INTO schema_migrations (version) VALUES ('20140808133452');

INSERT INTO schema_migrations (version) VALUES ('20140808145805');

INSERT INTO schema_migrations (version) VALUES ('20140811205310');

INSERT INTO schema_migrations (version) VALUES ('20140822195749');

INSERT INTO schema_migrations (version) VALUES ('20140825141917');

INSERT INTO schema_migrations (version) VALUES ('20140826143547');

INSERT INTO schema_migrations (version) VALUES ('20140827211503');

INSERT INTO schema_migrations (version) VALUES ('20140905173555');

INSERT INTO schema_migrations (version) VALUES ('20140908221034');

INSERT INTO schema_migrations (version) VALUES ('20140909215722');

INSERT INTO schema_migrations (version) VALUES ('20140918152732');

INSERT INTO schema_migrations (version) VALUES ('20140923205836');

INSERT INTO schema_migrations (version) VALUES ('20140923225022');

INSERT INTO schema_migrations (version) VALUES ('20140924203827');

INSERT INTO schema_migrations (version) VALUES ('20140930152502');

INSERT INTO schema_migrations (version) VALUES ('20141008142920');

INSERT INTO schema_migrations (version) VALUES ('20141016200418');

INSERT INTO schema_migrations (version) VALUES ('20141016201425');

INSERT INTO schema_migrations (version) VALUES ('20141021033652');

INSERT INTO schema_migrations (version) VALUES ('20141023224825');

INSERT INTO schema_migrations (version) VALUES ('20141027185355');

INSERT INTO schema_migrations (version) VALUES ('20141031065838');

INSERT INTO schema_migrations (version) VALUES ('20141106193743');

INSERT INTO schema_migrations (version) VALUES ('20141120195942');

INSERT INTO schema_migrations (version) VALUES ('20141124210848');

INSERT INTO schema_migrations (version) VALUES ('20141126225149');

INSERT INTO schema_migrations (version) VALUES ('20141201195356');

INSERT INTO schema_migrations (version) VALUES ('20141202183257');

INSERT INTO schema_migrations (version) VALUES ('20141203021124');

INSERT INTO schema_migrations (version) VALUES ('20141203234945');

INSERT INTO schema_migrations (version) VALUES ('20141204224256');

INSERT INTO schema_migrations (version) VALUES ('20141213072055');

INSERT INTO schema_migrations (version) VALUES ('20141229203654');

INSERT INTO schema_migrations (version) VALUES ('20141231013453');

INSERT INTO schema_migrations (version) VALUES ('20141231220927');

INSERT INTO schema_migrations (version) VALUES ('20150102230531');

INSERT INTO schema_migrations (version) VALUES ('20150106164046');

INSERT INTO schema_migrations (version) VALUES ('20150113140719');

INSERT INTO schema_migrations (version) VALUES ('20150113143314');

INSERT INTO schema_migrations (version) VALUES ('20150113182915');

INSERT INTO schema_migrations (version) VALUES ('20150113231721');

INSERT INTO schema_migrations (version) VALUES ('20150113234014');

INSERT INTO schema_migrations (version) VALUES ('20150115201820');

INSERT INTO schema_migrations (version) VALUES ('20150116001749');

INSERT INTO schema_migrations (version) VALUES ('20150116204932');

INSERT INTO schema_migrations (version) VALUES ('20150118193006');

INSERT INTO schema_migrations (version) VALUES ('20150119134841');

INSERT INTO schema_migrations (version) VALUES ('20150119231325');

INSERT INTO schema_migrations (version) VALUES ('20150120210548');

INSERT INTO schema_migrations (version) VALUES ('20150121140450');

INSERT INTO schema_migrations (version) VALUES ('20150121151704');

INSERT INTO schema_migrations (version) VALUES ('20150121151843');

INSERT INTO schema_migrations (version) VALUES ('20150121183230');

INSERT INTO schema_migrations (version) VALUES ('20150121213003');

INSERT INTO schema_migrations (version) VALUES ('20150128155036');

INSERT INTO schema_migrations (version) VALUES ('20150203161147');

INSERT INTO schema_migrations (version) VALUES ('20150203202455');

INSERT INTO schema_migrations (version) VALUES ('20150204211900');

INSERT INTO schema_migrations (version) VALUES ('20150210204325');

INSERT INTO schema_migrations (version) VALUES ('20150210204859');

INSERT INTO schema_migrations (version) VALUES ('20150210225651');

INSERT INTO schema_migrations (version) VALUES ('20150213135647');

INSERT INTO schema_migrations (version) VALUES ('20150311002940');

INSERT INTO schema_migrations (version) VALUES ('20150316174854');

INSERT INTO schema_migrations (version) VALUES ('20150323233336');

INSERT INTO schema_migrations (version) VALUES ('20150326184931');

INSERT INTO schema_migrations (version) VALUES ('20150401015428');

INSERT INTO schema_migrations (version) VALUES ('20150407170533');

INSERT INTO schema_migrations (version) VALUES ('20150410144940');

INSERT INTO schema_migrations (version) VALUES ('20150410172117');

INSERT INTO schema_migrations (version) VALUES ('20150410185618');

INSERT INTO schema_migrations (version) VALUES ('20150413151603');

INSERT INTO schema_migrations (version) VALUES ('20150414164156');

INSERT INTO schema_migrations (version) VALUES ('20150420212905');

INSERT INTO schema_migrations (version) VALUES ('20150422163630');

INSERT INTO schema_migrations (version) VALUES ('20150428231310');

INSERT INTO schema_migrations (version) VALUES ('20150526192457');

INSERT INTO schema_migrations (version) VALUES ('20150831170627');

INSERT INTO schema_migrations (version) VALUES ('20150903140156');

INSERT INTO schema_migrations (version) VALUES ('20150910145039');

INSERT INTO schema_migrations (version) VALUES ('20150914204627');

INSERT INTO schema_migrations (version) VALUES ('20151116194835');

INSERT INTO schema_migrations (version) VALUES ('20151116205930');

INSERT INTO schema_migrations (version) VALUES ('20151116210129');

INSERT INTO schema_migrations (version) VALUES ('20151117143337');

INSERT INTO schema_migrations (version) VALUES ('20151117144455');

INSERT INTO schema_migrations (version) VALUES ('20151117164804');

INSERT INTO schema_migrations (version) VALUES ('20151117165402');

INSERT INTO schema_migrations (version) VALUES ('20151125121758');

INSERT INTO schema_migrations (version) VALUES ('20151125163028');

INSERT INTO schema_migrations (version) VALUES ('20151211161332');

INSERT INTO schema_migrations (version) VALUES ('20151231215448');

INSERT INTO schema_migrations (version) VALUES ('20151231230813');

INSERT INTO schema_migrations (version) VALUES ('20160107165417');

INSERT INTO schema_migrations (version) VALUES ('20160107185550');

INSERT INTO schema_migrations (version) VALUES ('20160107203250');

INSERT INTO schema_migrations (version) VALUES ('20160120191411');

INSERT INTO schema_migrations (version) VALUES ('20160202191338');

INSERT INTO schema_migrations (version) VALUES ('20160203162217');

INSERT INTO schema_migrations (version) VALUES ('20160203163612');

INSERT INTO schema_migrations (version) VALUES ('20160229183114');

INSERT INTO schema_migrations (version) VALUES ('20160229183501');

INSERT INTO schema_migrations (version) VALUES ('20160303163310');

INSERT INTO schema_migrations (version) VALUES ('20160303180119');

INSERT INTO schema_migrations (version) VALUES ('20160303182905');

INSERT INTO schema_migrations (version) VALUES ('20160304171014');

INSERT INTO schema_migrations (version) VALUES ('20160304185001');

INSERT INTO schema_migrations (version) VALUES ('20160304195436');

