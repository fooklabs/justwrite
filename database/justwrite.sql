-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler  version: 0.8.0
-- PostgreSQL version: 9.4
-- Project Site: pgmodeler.com.br
-- Model Author: ---


-- Database creation must be done outside an multicommand file.
-- These commands were put in this file only for convenience.
-- -- object: new_database | type: DATABASE --
-- -- DROP DATABASE IF EXISTS new_database;
-- CREATE DATABASE new_database
-- ;
-- -- ddl-end --
--
CREATE EXTENSION ltree;

-- object: public.member | type: TABLE --
-- DROP TABLE IF EXISTS public.member CASCADE;
CREATE TABLE public.user(
	login text NOT NULL,
	password text NOT NULL,
	font text,
	CONSTRAINT user_login_pk PRIMARY KEY (login),
	CONSTRAINT user_login_uq UNIQUE (login)

);
-- ddl-end --
ALTER TABLE public.user OWNER TO postgres;
-- ddl-end --

-- object: public.post | type: TABLE --
-- DROP TABLE IF EXISTS public.post CASCADE;
CREATE TABLE public.post(
	post_id bigserial NOT NULL,
	login text NOT NULL,
	book_id bigint,
	book_order integer,
	title text NOT NULL,
	body text NOT NULL,
	interesting integer NOT NULL DEFAULT 0,
	not_interesting integer NOT NULL DEFAULT 0,
	shit_writing integer NOT NULL DEFAULT 0,
	good_writing integer NOT NULL DEFAULT 0,
	outdated integer NOT NULL DEFAULT 0,
	inaccurate integer NOT NULL DEFAULT 0,
	public_writeable boolean NOT NULL DEFAULT FALSE,
	published boolean NOT NULL DEFAULT FALSE,
	date_created timestamp with time zone NOT NULL DEFAULT now(),
	CONSTRAINT post_post_id_pk PRIMARY KEY (post_id)

);
-- ddl-end --
ALTER TABLE public.post OWNER TO postgres;
-- ddl-end --

-- object: public.tag | type: TABLE --
-- DROP TABLE IF EXISTS public.tag CASCADE;
CREATE TABLE public.tag(
	tag_id bigserial NOT NULL,
	name text NOT NULL,
	count bigint NOT NULL DEFAULT 0,
	CONSTRAINT tag_tag_id_pk PRIMARY KEY (tag_id),
	CONSTRAINT tag_name_uq UNIQUE (name)

);
-- ddl-end --
ALTER TABLE public.tag OWNER TO postgres;
-- ddl-end --

-- object: public.comment | type: TABLE --
-- DROP TABLE IF EXISTS public.comment CASCADE;
CREATE TABLE public.comment(
	comment_id bigserial NOT NULL,
	login text NOT NULL,
	post_id bigint NOT NULL,
	body text NOT NULL,
	path ltree NOT NULL,
	created timestamp with time zone NOT NULL DEFAULT now(),
	CONSTRAINT comment_comment_id_pk PRIMARY KEY (comment_id),
	CONSTRAINT post_body_uq UNIQUE (post_id,body)

);
-- ddl-end --
ALTER TABLE public.comment OWNER TO postgres;
-- ddl-end --

-- object: public.book | type: TABLE --
-- DROP TABLE IF EXISTS public.book CASCADE;
CREATE TABLE public.book(
	book_id bigserial NOT NULL,
	login text NOT NULL,
	title text NOT NULL,
	last_updated timestamp with time zone NOT NULL DEFAULT now(),
	date_created timestamp with time zone NOT NULL DEFAULT now(),
	CONSTRAINT book_book_id_pk PRIMARY KEY (book_id)

);
-- ddl-end --
ALTER TABLE public.book OWNER TO postgres;
-- ddl-end --

-- object: public.book_tag | type: TABLE --
-- DROP TABLE IF EXISTS public.book_tag CASCADE;
CREATE TABLE public.book_tag(
	book_tag_id bigserial NOT NULL,
	book_id bigint NOT NULL,
	tag_id bigint NOT NULL,
	CONSTRAINT book_tag_book_tag_id_pk PRIMARY KEY (book_tag_id),
	CONSTRAINT book_tag_uq UNIQUE (book_id,tag_id)

);
-- ddl-end --
ALTER TABLE public.book_tag OWNER TO postgres;
-- ddl-end --

-- object: public.post_tag | type: TABLE --
-- DROP TABLE IF EXISTS public.post_tag CASCADE;
CREATE TABLE public.post_tag(
	post_tag_id bigserial NOT NULL,
	post_id bigint NOT NULL,
	tag_id bigint NOT NULL,
	CONSTRAINT post_tag_post_tag_id_pk PRIMARY KEY (post_tag_id),
	CONSTRAINT post_tag_uq UNIQUE (post_id,tag_id)

);
-- ddl-end --
ALTER TABLE public.post_tag OWNER TO postgres;
-- ddl-end --

-- object: post_member_id_fk | type: CONSTRAINT --
-- ALTER TABLE public	.post DROP CONSTRAINT IF EXISTS post_member_id_fk CASCADE;
ALTER TABLE public.post ADD CONSTRAINT post_login_id_fk FOREIGN KEY (login)
REFERENCES public.user (login) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_book_id_fk | type: CONSTRAINT --
-- ALTER TABLE public.post DROP CONSTRAINT IF EXISTS post_book_id_fk CASCADE;
ALTER TABLE public.post ADD CONSTRAINT post_book_id_fk FOREIGN KEY (book_id)
REFERENCES public.book (book_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: comment_member_id_fk | type: CONSTRAINT --
-- ALTER TABLE public.comment DROP CONSTRAINT IF EXISTS comment_member_id_fk CASCADE;
ALTER TABLE public.comment ADD CONSTRAINT comment_login_id_fk FOREIGN KEY (login)
REFERENCES public.user (login) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: comment_post_id_fk | type: CONSTRAINT --
-- ALTER TABLE public.comment DROP CONSTRAINT IF EXISTS comment_post_id_fk CASCADE;
ALTER TABLE public.comment ADD CONSTRAINT comment_post_id_fk FOREIGN KEY (post_id)
REFERENCES public.post (post_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: book_member_id_fk | type: CONSTRAINT --
-- ALTER TABLE public.book DROP CONSTRAINT IF EXISTS book_member_id_fk CASCADE;
ALTER TABLE public.book ADD CONSTRAINT book_login_id_fk FOREIGN KEY (login)
REFERENCES public.user (login) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: book_tag_book_id_fk | type: CONSTRAINT --
-- ALTER TABLE public.book_tag DROP CONSTRAINT IF EXISTS book_tag_book_id_fk CASCADE;
ALTER TABLE public.book_tag ADD CONSTRAINT book_tag_book_id_fk FOREIGN KEY (book_id)
REFERENCES public.book (book_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: book_tag_tag_id_fk | type: CONSTRAINT --
-- ALTER TABLE public.book_tag DROP CONSTRAINT IF EXISTS book_tag_tag_id_fk CASCADE;
ALTER TABLE public.book_tag ADD CONSTRAINT book_tag_tag_id_fk FOREIGN KEY (tag_id)
REFERENCES public.tag (tag_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_tag_post_id_fk | type: CONSTRAINT --
-- ALTER TABLE public.post_tag DROP CONSTRAINT IF EXISTS post_tag_post_id_fk CASCADE;
ALTER TABLE public.post_tag ADD CONSTRAINT post_tag_post_id_fk FOREIGN KEY (post_id)
REFERENCES public.post (post_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_tag_tag_id_fk | type: CONSTRAINT --
-- ALTER TABLE public.post_tag DROP CONSTRAINT IF EXISTS post_tag_tag_id_fk CASCADE;
ALTER TABLE public.post_tag ADD CONSTRAINT post_tag_tag_id_fk FOREIGN KEY (tag_id)
REFERENCES public.tag (tag_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --
