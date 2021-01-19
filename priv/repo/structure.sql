--
-- PostgreSQL database dump
--

-- Dumped from database version 12.5 (Ubuntu 12.5-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.5 (Ubuntu 12.5-0ubuntu0.20.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: card_refills; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.card_refills (
    id bigint NOT NULL,
    refill_round_id bigint NOT NULL,
    gift_card_id bigint NOT NULL,
    amount integer NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    payment_method_id bigint NOT NULL,
    payment_locator character varying(255)
);


--
-- Name: card_refills_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.card_refills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: card_refills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.card_refills_id_seq OWNED BY public.card_refills.id;


--
-- Name: contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contacts (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    phone character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    address character varying(255)
);


--
-- Name: contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.contacts_id_seq OWNED BY public.contacts.id;


--
-- Name: fundraiser_admins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fundraiser_admins (
    id bigint NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    user_id bigint NOT NULL,
    fundraiser_id bigint NOT NULL,
    contact_id bigint NOT NULL,
    "primary" boolean DEFAULT false
);


--
-- Name: fundraiser_admins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fundraiser_admins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fundraiser_admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fundraiser_admins_id_seq OWNED BY public.fundraiser_admins.id;


--
-- Name: fundraisers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fundraisers (
    id bigint NOT NULL,
    school_id bigint NOT NULL,
    store_id bigint NOT NULL,
    refill_round_min integer DEFAULT 1000,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    store_contact_id bigint NOT NULL,
    name character varying(255) NOT NULL,
    active boolean DEFAULT true,
    card_refill_max integer NOT NULL,
    card_reserve_low_mark integer DEFAULT 0,
    card_reserve_max integer DEFAULT 50
);


--
-- Name: fundraisers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fundraisers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fundraisers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fundraisers_id_seq OWNED BY public.fundraisers.id;


--
-- Name: gift_cards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gift_cards (
    id bigint NOT NULL,
    card_number character varying(255) NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    active boolean DEFAULT false,
    fundraiser_id bigint NOT NULL,
    participant_id bigint
);


--
-- Name: gift_cards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gift_cards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gift_cards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.gift_cards_id_seq OWNED BY public.gift_cards.id;


--
-- Name: participants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.participants (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    fundraiser_id bigint NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    contact_id bigint NOT NULL,
    notify_by_email boolean DEFAULT true,
    notify_by_text boolean DEFAULT false,
    active boolean DEFAULT true
);


--
-- Name: participants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.participants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: participants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.participants_id_seq OWNED BY public.participants.id;


--
-- Name: payment_methods; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payment_methods (
    id bigint NOT NULL,
    payment_service_id bigint NOT NULL,
    fundraiser_id bigint NOT NULL,
    payable_to character varying(255) NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: payment_methods_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.payment_methods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payment_methods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.payment_methods_id_seq OWNED BY public.payment_methods.id;


--
-- Name: payment_services; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payment_services (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    url character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: payment_services_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.payment_services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payment_services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.payment_services_id_seq OWNED BY public.payment_services.id;


--
-- Name: refill_rounds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.refill_rounds (
    id bigint NOT NULL,
    fundraiser_id bigint NOT NULL,
    closed_on timestamp(0) without time zone,
    executed_on timestamp(0) without time zone,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: refill_rounds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.refill_rounds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: refill_rounds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.refill_rounds_id_seq OWNED BY public.refill_rounds.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: schools; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schools (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    address character varying(255) NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    short_name character varying(255) NOT NULL
);


--
-- Name: schools_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.schools_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: schools_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.schools_id_seq OWNED BY public.schools.id;


--
-- Name: stores; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stores (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    address character varying(255) NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    short_name character varying(255) NOT NULL
);


--
-- Name: stores_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.stores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.stores_id_seq OWNED BY public.stores.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email public.citext NOT NULL,
    hashed_password character varying(255) NOT NULL,
    confirmed_at timestamp(0) without time zone,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    role character varying(255) NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: users_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users_tokens (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    token bytea NOT NULL,
    context character varying(255) NOT NULL,
    sent_to character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL
);


--
-- Name: users_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_tokens_id_seq OWNED BY public.users_tokens.id;


--
-- Name: card_refills id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.card_refills ALTER COLUMN id SET DEFAULT nextval('public.card_refills_id_seq'::regclass);


--
-- Name: contacts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts ALTER COLUMN id SET DEFAULT nextval('public.contacts_id_seq'::regclass);


--
-- Name: fundraiser_admins id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fundraiser_admins ALTER COLUMN id SET DEFAULT nextval('public.fundraiser_admins_id_seq'::regclass);


--
-- Name: fundraisers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fundraisers ALTER COLUMN id SET DEFAULT nextval('public.fundraisers_id_seq'::regclass);


--
-- Name: gift_cards id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gift_cards ALTER COLUMN id SET DEFAULT nextval('public.gift_cards_id_seq'::regclass);


--
-- Name: participants id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participants ALTER COLUMN id SET DEFAULT nextval('public.participants_id_seq'::regclass);


--
-- Name: payment_methods id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_methods ALTER COLUMN id SET DEFAULT nextval('public.payment_methods_id_seq'::regclass);


--
-- Name: payment_services id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_services ALTER COLUMN id SET DEFAULT nextval('public.payment_services_id_seq'::regclass);


--
-- Name: refill_rounds id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refill_rounds ALTER COLUMN id SET DEFAULT nextval('public.refill_rounds_id_seq'::regclass);


--
-- Name: schools id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schools ALTER COLUMN id SET DEFAULT nextval('public.schools_id_seq'::regclass);


--
-- Name: stores id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stores ALTER COLUMN id SET DEFAULT nextval('public.stores_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: users_tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_tokens ALTER COLUMN id SET DEFAULT nextval('public.users_tokens_id_seq'::regclass);


--
-- Name: card_refills card_refills_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.card_refills
    ADD CONSTRAINT card_refills_pkey PRIMARY KEY (id);


--
-- Name: contacts contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: fundraiser_admins fundraiser_admins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fundraiser_admins
    ADD CONSTRAINT fundraiser_admins_pkey PRIMARY KEY (id);


--
-- Name: fundraisers fundraisers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fundraisers
    ADD CONSTRAINT fundraisers_pkey PRIMARY KEY (id);


--
-- Name: gift_cards gift_cards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gift_cards
    ADD CONSTRAINT gift_cards_pkey PRIMARY KEY (id);


--
-- Name: participants participants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participants
    ADD CONSTRAINT participants_pkey PRIMARY KEY (id);


--
-- Name: payment_methods payment_methods_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_methods
    ADD CONSTRAINT payment_methods_pkey PRIMARY KEY (id);


--
-- Name: payment_services payment_services_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_services
    ADD CONSTRAINT payment_services_pkey PRIMARY KEY (id);


--
-- Name: refill_rounds refill_rounds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refill_rounds
    ADD CONSTRAINT refill_rounds_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: schools schools_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schools
    ADD CONSTRAINT schools_pkey PRIMARY KEY (id);


--
-- Name: stores stores_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stores
    ADD CONSTRAINT stores_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users_tokens users_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_tokens
    ADD CONSTRAINT users_tokens_pkey PRIMARY KEY (id);


--
-- Name: card_refills_gift_card_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX card_refills_gift_card_id_index ON public.card_refills USING btree (gift_card_id);


--
-- Name: card_refills_payment_method_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX card_refills_payment_method_id_index ON public.card_refills USING btree (payment_method_id);


--
-- Name: card_refills_refill_round_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX card_refills_refill_round_id_index ON public.card_refills USING btree (refill_round_id);


--
-- Name: contacts_email_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX contacts_email_index ON public.contacts USING btree (email);


--
-- Name: fundraiser_admins_fundraiser_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fundraiser_admins_fundraiser_id_index ON public.fundraiser_admins USING btree (fundraiser_id);


--
-- Name: fundraiser_admins_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fundraiser_admins_user_id_index ON public.fundraiser_admins USING btree (user_id);


--
-- Name: fundraisers_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX fundraisers_name_index ON public.fundraisers USING btree (name);


--
-- Name: fundraisers_school_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fundraisers_school_id_index ON public.fundraisers USING btree (school_id);


--
-- Name: fundraisers_store_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fundraisers_store_id_index ON public.fundraisers USING btree (store_id);


--
-- Name: gift_cards_card_number_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX gift_cards_card_number_index ON public.gift_cards USING btree (card_number);


--
-- Name: participants_fundraiser_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX participants_fundraiser_id_index ON public.participants USING btree (fundraiser_id);


--
-- Name: participants_user_id_fundraiser_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX participants_user_id_fundraiser_id_index ON public.participants USING btree (user_id, fundraiser_id);


--
-- Name: participants_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX participants_user_id_index ON public.participants USING btree (user_id);


--
-- Name: payment_methods_fundraiser_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payment_methods_fundraiser_id_index ON public.payment_methods USING btree (fundraiser_id);


--
-- Name: payment_methods_payment_service_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payment_methods_payment_service_id_index ON public.payment_methods USING btree (payment_service_id);


--
-- Name: payment_services_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payment_services_name_index ON public.payment_services USING btree (name);


--
-- Name: refill_rounds_fundraiser_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX refill_rounds_fundraiser_id_index ON public.refill_rounds USING btree (fundraiser_id);


--
-- Name: schools_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX schools_name_index ON public.schools USING btree (name);


--
-- Name: schools_short_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX schools_short_name_index ON public.schools USING btree (short_name);


--
-- Name: stores_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX stores_name_index ON public.stores USING btree (name);


--
-- Name: stores_short_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX stores_short_name_index ON public.stores USING btree (short_name);


--
-- Name: users_email_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_email_index ON public.users USING btree (email);


--
-- Name: users_tokens_context_token_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_tokens_context_token_index ON public.users_tokens USING btree (context, token);


--
-- Name: users_tokens_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_tokens_user_id_index ON public.users_tokens USING btree (user_id);


--
-- Name: card_refills card_refills_gift_card_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.card_refills
    ADD CONSTRAINT card_refills_gift_card_id_fkey FOREIGN KEY (gift_card_id) REFERENCES public.gift_cards(id);


--
-- Name: card_refills card_refills_payment_method_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.card_refills
    ADD CONSTRAINT card_refills_payment_method_id_fkey FOREIGN KEY (payment_method_id) REFERENCES public.payment_methods(id);


--
-- Name: card_refills card_refills_refill_round_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.card_refills
    ADD CONSTRAINT card_refills_refill_round_id_fkey FOREIGN KEY (refill_round_id) REFERENCES public.refill_rounds(id);


--
-- Name: fundraiser_admins fundraiser_admins_contact_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fundraiser_admins
    ADD CONSTRAINT fundraiser_admins_contact_id_fkey FOREIGN KEY (contact_id) REFERENCES public.contacts(id);


--
-- Name: fundraiser_admins fundraiser_admins_fundraiser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fundraiser_admins
    ADD CONSTRAINT fundraiser_admins_fundraiser_id_fkey FOREIGN KEY (fundraiser_id) REFERENCES public.fundraisers(id);


--
-- Name: fundraiser_admins fundraiser_admins_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fundraiser_admins
    ADD CONSTRAINT fundraiser_admins_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: fundraisers fundraisers_school_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fundraisers
    ADD CONSTRAINT fundraisers_school_id_fkey FOREIGN KEY (school_id) REFERENCES public.schools(id);


--
-- Name: fundraisers fundraisers_store_contact_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fundraisers
    ADD CONSTRAINT fundraisers_store_contact_id_fkey FOREIGN KEY (store_contact_id) REFERENCES public.contacts(id);


--
-- Name: fundraisers fundraisers_store_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fundraisers
    ADD CONSTRAINT fundraisers_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.stores(id);


--
-- Name: gift_cards gift_cards_fundraiser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gift_cards
    ADD CONSTRAINT gift_cards_fundraiser_id_fkey FOREIGN KEY (fundraiser_id) REFERENCES public.fundraisers(id);


--
-- Name: gift_cards gift_cards_participant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gift_cards
    ADD CONSTRAINT gift_cards_participant_id_fkey FOREIGN KEY (participant_id) REFERENCES public.participants(id);


--
-- Name: participants participants_contact_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participants
    ADD CONSTRAINT participants_contact_id_fkey FOREIGN KEY (contact_id) REFERENCES public.contacts(id);


--
-- Name: participants participants_fundraiser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participants
    ADD CONSTRAINT participants_fundraiser_id_fkey FOREIGN KEY (fundraiser_id) REFERENCES public.fundraisers(id);


--
-- Name: participants participants_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participants
    ADD CONSTRAINT participants_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: payment_methods payment_methods_fundraiser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_methods
    ADD CONSTRAINT payment_methods_fundraiser_id_fkey FOREIGN KEY (fundraiser_id) REFERENCES public.fundraisers(id);


--
-- Name: payment_methods payment_methods_payment_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_methods
    ADD CONSTRAINT payment_methods_payment_service_id_fkey FOREIGN KEY (payment_service_id) REFERENCES public.payment_services(id);


--
-- Name: refill_rounds refill_rounds_fundraiser_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refill_rounds
    ADD CONSTRAINT refill_rounds_fundraiser_id_fkey FOREIGN KEY (fundraiser_id) REFERENCES public.fundraisers(id);


--
-- Name: users_tokens users_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_tokens
    ADD CONSTRAINT users_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

INSERT INTO public."schema_migrations" (version) VALUES (20201204191631);
INSERT INTO public."schema_migrations" (version) VALUES (20201206191009);
INSERT INTO public."schema_migrations" (version) VALUES (20201229162816);
INSERT INTO public."schema_migrations" (version) VALUES (20201229163930);
INSERT INTO public."schema_migrations" (version) VALUES (20201229164217);
INSERT INTO public."schema_migrations" (version) VALUES (20201229170714);
INSERT INTO public."schema_migrations" (version) VALUES (20201229171107);
INSERT INTO public."schema_migrations" (version) VALUES (20201229171510);
INSERT INTO public."schema_migrations" (version) VALUES (20201229172128);
INSERT INTO public."schema_migrations" (version) VALUES (20201229172243);
INSERT INTO public."schema_migrations" (version) VALUES (20201229172628);
INSERT INTO public."schema_migrations" (version) VALUES (20201229173420);
INSERT INTO public."schema_migrations" (version) VALUES (20201229173944);
INSERT INTO public."schema_migrations" (version) VALUES (20201229174200);
INSERT INTO public."schema_migrations" (version) VALUES (20201229174301);
INSERT INTO public."schema_migrations" (version) VALUES (20201229183439);
INSERT INTO public."schema_migrations" (version) VALUES (20201229184216);
INSERT INTO public."schema_migrations" (version) VALUES (20201229185332);
INSERT INTO public."schema_migrations" (version) VALUES (20201229191844);
INSERT INTO public."schema_migrations" (version) VALUES (20201229192145);
INSERT INTO public."schema_migrations" (version) VALUES (20201229192350);
INSERT INTO public."schema_migrations" (version) VALUES (20201229210559);
INSERT INTO public."schema_migrations" (version) VALUES (20201229211007);
INSERT INTO public."schema_migrations" (version) VALUES (20201229215853);
INSERT INTO public."schema_migrations" (version) VALUES (20201230151148);
INSERT INTO public."schema_migrations" (version) VALUES (20201230151349);
INSERT INTO public."schema_migrations" (version) VALUES (20201230174327);
INSERT INTO public."schema_migrations" (version) VALUES (20201230184629);
INSERT INTO public."schema_migrations" (version) VALUES (20201230185055);
INSERT INTO public."schema_migrations" (version) VALUES (20201230193942);
INSERT INTO public."schema_migrations" (version) VALUES (20201230200154);
INSERT INTO public."schema_migrations" (version) VALUES (20201231181412);
INSERT INTO public."schema_migrations" (version) VALUES (20201231190003);
INSERT INTO public."schema_migrations" (version) VALUES (20201231193057);
INSERT INTO public."schema_migrations" (version) VALUES (20201231193258);
INSERT INTO public."schema_migrations" (version) VALUES (20210103194845);
INSERT INTO public."schema_migrations" (version) VALUES (20210103202223);
INSERT INTO public."schema_migrations" (version) VALUES (20210103202426);
INSERT INTO public."schema_migrations" (version) VALUES (20210103202613);
INSERT INTO public."schema_migrations" (version) VALUES (20210117180632);
INSERT INTO public."schema_migrations" (version) VALUES (20210117202553);
INSERT INTO public."schema_migrations" (version) VALUES (20210118162807);
INSERT INTO public."schema_migrations" (version) VALUES (20210118163423);
INSERT INTO public."schema_migrations" (version) VALUES (20210118190840);
INSERT INTO public."schema_migrations" (version) VALUES (20210118202843);
INSERT INTO public."schema_migrations" (version) VALUES (20210118224718);
