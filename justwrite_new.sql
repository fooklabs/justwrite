-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler  version: 0.8.0
-- PostgreSQL version: 9.4
-- Project Site: pgmodeler.com.br
-- Model Author: ---

-- object: justwrite_u | type: ROLE --
-- DROP ROLE IF EXISTS justwrite_u;
CREATE ROLE justwrite_u WITH ;
-- ddl-end --


-- Database creation must be done outside an multicommand file.
-- These commands were put in this file only for convenience.
-- -- object: new_database | type: DATABASE --
-- -- DROP DATABASE IF EXISTS new_database;
-- CREATE DATABASE new_database
-- ;
-- -- ddl-end --
-- 

CREATE EXTENSION ltree;
CREATE EXTENSION "uuid-ossp";

-- object: public.user | type: TABLE --
-- DROP TABLE IF EXISTS public.user CASCADE;
CREATE TABLE public.user(
	login text NOT NULL,
	password text NOT NULL,
	reputation integer NOT NULL DEFAULT 0,
	created timestamp with time zone NOT NULL DEFAULT now(),
	CONSTRAINT login PRIMARY KEY (login),
	CONSTRAINT user_login_uq UNIQUE (login)

);
-- ddl-end --
ALTER TABLE public.user OWNER TO justwrite_u;
-- ddl-end --

-- object: public.topic | type: TABLE --
-- DROP TABLE IF EXISTS public.topic CASCADE;
CREATE TABLE public.topic(
	name text NOT NULL,
	count integer NOT NULL DEFAULT 0,
	description text,
	wiki text,
	created timestamp NOT NULL DEFAULT now(),
	CONSTRAINT topic_name_pk PRIMARY KEY (name),
	CONSTRAINT topic_name_uq UNIQUE (name)

);
-- ddl-end --
ALTER TABLE public.topic OWNER TO justwrite_u;
-- ddl-end --

-- object: public.post | type: TABLE --
-- DROP TABLE IF EXISTS public.post CASCADE;
CREATE TABLE public.post(
	post_id bigserial NOT NULL,
	post_uuid uuid default uuid_generate_v4() NOT NULL,
	title text NOT NULL,
	body text NOT NULL,
	public boolean NOT NULL DEFAULT FALSE,
	published boolean NOT NULL DEFAULT FALSE,
	created timestamp with time zone NOT NULL DEFAULT now(),
	login text NOT NULL,
	CONSTRAINT post_id_pk PRIMARY KEY (post_id),
	CONSTRAINT post_uuid_uq UNIQUE (post_uuid)

);
-- ddl-end --
ALTER TABLE public.post OWNER TO justwrite_u;
-- ddl-end --

-- object: public.comment | type: TABLE --
-- DROP TABLE IF EXISTS public.comment CASCADE;
CREATE TABLE public.post_comment(
        post_comment_id bigserial NOT NULL,
        post_comment_uuid uuid default uuid_generate_v4() NOT NULL,
        post_id bigint not null,
        login text NOT NULL,
        body text NOT NULL,
        path ltree NOT NULL,
        created timestamp with time zone NOT NULL DEFAULT now(),
        last_updated timestamp with time zone,
	CONSTRAINT post_comment_id_pk PRIMARY KEY (post_comment_id),
	CONSTRAINT post_comment_uuid_uq UNIQUE (post_comment_uuid)

);
-- ddl-end --
ALTER TABLE public.post_comment OWNER TO justwrite_u;
-- ddl-end --

-- object: public.link | type: TABLE --
-- DROP TABLE IF EXISTS public.link CASCADE;
CREATE TABLE public.link(
	link_id bigserial NOT NULL,
	link_uuid uuid default uuid_generate_v4() NOT NULL,
	url text NOT NULL,
	description text,
	created timestamp with time zone NOT NULL DEFAULT now(),
	CONSTRAINT link_id_pk PRIMARY KEY (link_id),
	CONSTRAINT link_uuid_uq UNIQUE (link_uuid),
	CONSTRAINT link_url_uq UNIQUE (url)

);
-- ddl-end --
ALTER TABLE public.link OWNER TO justwrite_u;
-- ddl-end --

-- object: public.comment | type: TABLE --
-- DROP TABLE IF EXISTS public.comment CASCADE;
CREATE TABLE public.link_comment(
        link_comment_id bigserial NOT NULL,
        link_comment_uuid uuid default uuid_generate_v4() NOT NULL,
        link_id bigint not null,
        login text NOT NULL,
        body text NOT NULL,
        path ltree NOT NULL,
        created timestamp with time zone NOT NULL DEFAULT now(),
        last_updated timestamp with time zone,
	CONSTRAINT link_comment_id_pk PRIMARY KEY (link_comment_id),
	CONSTRAINT link_comment_uuid_uq UNIQUE (link_comment_uuid)

);
-- ddl-end --
ALTER TABLE public.link_comment OWNER TO justwrite_u;
-- ddl-end --

-- object: public.post_to_topic | type: TABLE --
-- DROP TABLE IF EXISTS public.post_to_topic CASCADE;
CREATE TABLE public.post_to_topic(
	post_to_topic_id bigserial NOT NULL,
	post bigint NOT NULL,
	topic text NOT NULL,
	count integer NOT NULL DEFAULT 0,
	upvote integer NOT NULL DEFAULT 0,
	downvote integer NOT NULL DEFAULT 0,
	created timestamp with time zone NOT NULL DEFAULT now(),
	CONSTRAINT post_to_topic_id_pk PRIMARY KEY (post_to_topic_id),
	CONSTRAINT post_to_topic_post_topic_uq UNIQUE (post,topic)
);
-- ddl-end --
ALTER TABLE public.post_to_topic OWNER TO justwrite_u;
-- ddl-end --

-- object: public.link_to_topic | type: TABLE --
-- DROP TABLE IF EXISTS public.link_to_topic CASCADE;
CREATE TABLE public.link_to_topic(
	link_to_topic_id bigserial NOT NULL,
	link bigint NOT NULL,
	topic text NOT NULL,
	count integer NOT NULL DEFAULT 0,
	upvote integer NOT NULL DEFAULT 0,
	downvote integer NOT NULL DEFAULT 0,
	created timestamp with time zone NOT NULL DEFAULT now(),
	CONSTRAINT link_to_topic_id_pk PRIMARY KEY (link_to_topic_id),
	CONSTRAINT link_to_topic_link_topic_uq UNIQUE (link,topic)

);
-- ddl-end --
ALTER TABLE public.link_to_topic OWNER TO justwrite_u;
-- ddl-end --

-- object: public.topic_to_topic | type: TABLE --
-- DROP TABLE IF EXISTS public.topic_to_topic CASCADE;
CREATE TABLE public.topic_to_topic(
	topic_to_topic_id bigserial NOT NULL,
	topic1 text NOT NULL,
	topic2 text NOT NULL,
	count integer NOT NULL DEFAULT 0,
	upvote integer NOT NULL DEFAULT 0,
	downvote integer NOT NULL DEFAULT 0,
	created timestamp with time zone NOT NULL DEFAULT now(),
	CONSTRAINT topic_to_topic_id_pk PRIMARY KEY (topic_to_topic_id),
	CONSTRAINT topic_to_topic_topic1_topic2_uq UNIQUE (topic1,topic2)

);
-- ddl-end --
ALTER TABLE public.topic_to_topic OWNER TO justwrite_u;
-- ddl-end --

-- object: public.book | type: TABLE --
-- DROP TABLE IF EXISTS public.book CASCADE;
CREATE TABLE public.book(
	book_id bigserial NOT NULL,
	book_uuid uuid default uuid_generate_v4() NOT NULL,
	name text NOT NULL,
	public boolean NOT NULL DEFAULT FALSE,
	writable boolean NOT NULL DEFAULT FALSE,
	created timestamp with time zone NOT NULL DEFAULT now(),
	login text NOT NULL,
	CONSTRAINT book_id_pk PRIMARY KEY (book_id),
	CONSTRAINT book_uuid_uq UNIQUE (book_uuid)

);
-- ddl-end --
ALTER TABLE public.book OWNER TO justwrite_u;
-- ddl-end --

-- object: public.book_to_post | type: TABLE --
-- DROP TABLE IF EXISTS public.book_to_post CASCADE;
CREATE TABLE public.book_to_post(
	book_to_post_id bigserial NOT NULL,
	book_id bigint NOT NULL,
	post_id bigint NOT NULL,
	sequence smallint NOT NULL,
	CONSTRAINT book_to_post_id_pk PRIMARY KEY (book_to_post_id)

);
-- ddl-end --
ALTER TABLE public.book_to_post OWNER TO justwrite_u;
-- ddl-end --

-- object: public.book_to_link | type: TABLE --
-- DROP TABLE IF EXISTS public.book_to_link CASCADE;
CREATE TABLE public.book_to_link(
	book_to_link_id bigserial NOT NULL,
	book_id bigint NOT NULL,
	link_id bigint NOT NULL,
	sequence smallint NOT NULL,
	CONSTRAINT book_to_link_id_pk PRIMARY KEY (book_to_link_id)

);
-- ddl-end --
ALTER TABLE public.book_to_link OWNER TO justwrite_u;
-- ddl-end --

-- object: public.subject | type: TABLE --
-- DROP TABLE IF EXISTS public.subject CASCADE;
CREATE TABLE public.subject(
	subject_id bigserial NOT NULL,
	subject_uuid uuid default uuid_generate_v4() NOT NULL,
	name text NOT NULL,
	public boolean NOT NULL DEFAULT FALSE,
	created timestamp with time zone NOT NULL DEFAULT now(),
	login text NOT NULL,
	CONSTRAINT subject_id_pk PRIMARY KEY (subject_id),
	CONSTRAINT subject_uuid_uq UNIQUE (subject_uuid)

);
-- ddl-end --
ALTER TABLE public.subject OWNER TO justwrite_u;
-- ddl-end --

-- object: public.subject_to_topic | type: TABLE --
-- DROP TABLE IF EXISTS public.subject_to_topic CASCADE;
CREATE TABLE public.subject_to_topic(
	subject_to_topic_id bigserial NOT NULL,
	subject_id bigint NOT NULL,
	topic text NOT NULL,
	CONSTRAINT subject_to_topic_id_pk PRIMARY KEY (subject_to_topic_id)

);
-- ddl-end --
ALTER TABLE public.subject_to_topic OWNER TO justwrite_u;
-- ddl-end --

-- object: post_login_fk | type: CONSTRAINT --
-- ALTER TABLE public.post DROP CONSTRAINT IF EXISTS post_login_fk CASCADE;
ALTER TABLE public.post ADD CONSTRAINT post_login_fk FOREIGN KEY (login)
REFERENCES public.user (login) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_to_topic_post_fk | type: CONSTRAINT --
-- ALTER TABLE public.post_to_topic DROP CONSTRAINT IF EXISTS post_to_topic_post_fk CASCADE;
ALTER TABLE public.post_to_topic ADD CONSTRAINT post_to_topic_post_fk FOREIGN KEY (post)
REFERENCES public.post (post_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_to_topic_topic_fk | type: CONSTRAINT --
-- ALTER TABLE public.post_to_topic DROP CONSTRAINT IF EXISTS post_to_topic_topic_fk CASCADE;
ALTER TABLE public.post_to_topic ADD CONSTRAINT post_to_topic_topic_fk FOREIGN KEY (topic)
REFERENCES public.topic (name) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: link_to_topic_link_fk | type: CONSTRAINT --
-- ALTER TABLE public.link_to_topic DROP CONSTRAINT IF EXISTS link_to_topic_link_fk CASCADE;
ALTER TABLE public.link_to_topic ADD CONSTRAINT link_to_topic_link_fk FOREIGN KEY (link)
REFERENCES public.link (link_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: link_to_topic_topic_fk | type: CONSTRAINT --
-- ALTER TABLE public.link_to_topic DROP CONSTRAINT IF EXISTS link_to_topic_topic_fk CASCADE;
ALTER TABLE public.link_to_topic ADD CONSTRAINT link_to_topic_topic_fk FOREIGN KEY (topic)
REFERENCES public.topic (name) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: topic_to_topic_topic1_fk | type: CONSTRAINT --
-- ALTER TABLE public.topic_to_topic DROP CONSTRAINT IF EXISTS topic_to_topic_topic1_fk CASCADE;
ALTER TABLE public.topic_to_topic ADD CONSTRAINT topic_to_topic_topic1_fk FOREIGN KEY (topic1)
REFERENCES public.topic (name) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: topic_to_topic_topic2_fk | type: CONSTRAINT --
-- ALTER TABLE public.topic_to_topic DROP CONSTRAINT IF EXISTS topic_to_topic_topic2_fk CASCADE;
ALTER TABLE public.topic_to_topic ADD CONSTRAINT topic_to_topic_topic2_fk FOREIGN KEY (topic2)
REFERENCES public.topic (name) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: book_login_fk | type: CONSTRAINT --
-- ALTER TABLE public.book DROP CONSTRAINT IF EXISTS book_login_fk CASCADE;
ALTER TABLE public.book ADD CONSTRAINT book_login_fk FOREIGN KEY (login)
REFERENCES public.user (login) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: book_to_post_book_id_fk | type: CONSTRAINT --
-- ALTER TABLE public.book_to_post DROP CONSTRAINT IF EXISTS book_to_post_book_id_fk CASCADE;
ALTER TABLE public.book_to_post ADD CONSTRAINT book_to_post_book_id_fk FOREIGN KEY (book_id)
REFERENCES public.book (book_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: book_to_post_post_id_fk | type: CONSTRAINT --
-- ALTER TABLE public.book_to_post DROP CONSTRAINT IF EXISTS book_to_post_post_id_fk CASCADE;
ALTER TABLE public.book_to_post ADD CONSTRAINT book_to_post_post_id_fk FOREIGN KEY (post_id)
REFERENCES public.post (post_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: book_to_link_book_id_fk | type: CONSTRAINT --
-- ALTER TABLE public.book_to_link DROP CONSTRAINT IF EXISTS book_to_link_book_id_fk CASCADE;
ALTER TABLE public.book_to_link ADD CONSTRAINT book_to_link_book_id_fk FOREIGN KEY (book_id)
REFERENCES public.book (book_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: book_to_link_link_id_fk | type: CONSTRAINT --
-- ALTER TABLE public.book_to_link DROP CONSTRAINT IF EXISTS book_to_link_link_id_fk CASCADE;
ALTER TABLE public.book_to_link ADD CONSTRAINT book_to_link_link_id_fk FOREIGN KEY (link_id)
REFERENCES public.link (link_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: subject_login_fk | type: CONSTRAINT --
-- ALTER TABLE public.subject DROP CONSTRAINT IF EXISTS subject_login_fk CASCADE;
ALTER TABLE public.subject ADD CONSTRAINT subject_login_fk FOREIGN KEY (login)
REFERENCES public.user (login) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: subject_to_topic_subject_id_fk | type: CONSTRAINT --
-- ALTER TABLE public.subject_to_topic DROP CONSTRAINT IF EXISTS subject_to_topic_subject_id_fk CASCADE;
ALTER TABLE public.subject_to_topic ADD CONSTRAINT subject_to_topic_subject_id_fk FOREIGN KEY (subject_id)
REFERENCES public.subject (subject_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: subject_to_topic_topid_fk | type: CONSTRAINT --
-- ALTER TABLE public.subject_to_topic DROP CONSTRAINT IF EXISTS subject_to_topic_topid_fk CASCADE;
ALTER TABLE public.subject_to_topic ADD CONSTRAINT subject_to_topic_topid_fk FOREIGN KEY (topic)
REFERENCES public.topic (name) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_comment_login_id_fk | type: CONSTRAINT --
-- ALTER TABLE public.post_comment DROP CONSTRAINT IF EXISTS post_comment_login_id_fk CASCADE;
ALTER TABLE public.post_comment ADD CONSTRAINT post_comment_login_id_fk FOREIGN KEY (login)
REFERENCES public.user (login) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_comment_post_id_fk | type: CONSTRAINT --
-- ALTER TABLE public.post_comment DROP CONSTRAINT IF EXISTS post_comment_post_id_fk CASCADE;
ALTER TABLE public.post_comment ADD CONSTRAINT post_comment_post_id_fk FOREIGN KEY (post_id)
REFERENCES public.post (post_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: link_comment_login_id_fk | type: CONSTRAINT --
-- ALTER TABLE public.link_comment DROP CONSTRAINT IF EXISTS link_comment_login_id_fk CASCADE;
ALTER TABLE public.link_comment ADD CONSTRAINT link_comment_login_id_fk FOREIGN KEY (login)
REFERENCES public.user (login) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: link_comment_link_id_fk | type: CONSTRAINT --
-- ALTER TABLE public.link_comment DROP CONSTRAINT IF EXISTS link_comment_link_id_fk CASCADE;
ALTER TABLE public.link_comment ADD CONSTRAINT link_comment_link_id_fk FOREIGN KEY (link_id)
REFERENCES public.link (link_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --
