--
-- PostgreSQL database dump
--

-- Dumped from database version 11.1
-- Dumped by pg_dump version 11.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: all_notifications(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.all_notifications() RETURNS TABLE(id integer, type character varying, img text, text text, created_date text, read boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY SELECT "Notification".id, "Notification".type, "Notification".img, "Notification".text, "Notification".created_date, "Notification".read  FROM "Notification" where "Notification".read = false order by id desc;
END; $$;


ALTER FUNCTION public.all_notifications() OWNER TO postgres;

--
-- Name: all_users(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.all_users() RETURNS TABLE(id integer, firstname character varying, lastname character varying, phone character varying, username character varying, active boolean, avatar character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY SELECT "User".id, "User".firstname, "User".lastname, "User".phone, "User".username, "User".active, "User".avatar FROM "User" order by id DESC;
END; $$;


ALTER FUNCTION public.all_users() OWNER TO postgres;

--
-- Name: change_status(integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.change_status(_id integer, _new_status boolean) RETURNS TABLE(id integer, firstname character varying, lastname character varying, phone character varying, username character varying, active boolean)
    LANGUAGE plpgsql
    AS $$
begin
	return query UPDATE "User" SET 
					active = _new_status
					WHERE "User".id = _id
					returning "User".id, "User".firstname, "User".lastname, "User".phone, "User".username, "User".active;
END;
$$;


ALTER FUNCTION public.change_status(_id integer, _new_status boolean) OWNER TO postgres;

--
-- Name: create_user(integer, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_user(_id integer, _firstname character varying, _lastname character varying, _username character varying, _avatar character varying DEFAULT 'images/default_avatar.png'::character varying, _phone character varying DEFAULT ''::character varying) RETURNS TABLE(id integer, firstname character varying, lastname character varying, phone character varying, username character varying, avatar character varying)
    LANGUAGE plpgsql
    AS $$
declare
user_exist integer;
BEGIN
	IF _firstname IS NULL OR length(_firstname) = 0 THEN
		RAISE NOTICE 'Name is null or empty';
	END IF;
    IF _lastname IS NULL OR length(_lastname) = 0 THEN
		RAISE NOTICE 'Surname is null or empty';
	END IF;
	
	select count(*) from "User" into user_exist where "User".id = _id;

	if user_exist = 0 then
	
		return query INSERT INTO "User" (id, firstname, lastname, phone, username, avatar)
		VALUES 
		(_id, _firstname, _lastname, _phone, _username, _avatar)
		returning "User".id, "User".firstname, "User".lastname, "User".phone, "User".username, "User".avatar;
	else
		UPDATE "User" SET 
					firstname = _firstname,
					lastname = _lastname,
					username = _username,
					avatar = _avatar,
					active = true
					WHERE "User".id=_id;

		return query select "User".id, "User".firstname, "User".lastname, "User".phone, "User".username, "User".avatar from "User" where "User".id = _id;
	end if;
END;
$$;


ALTER FUNCTION public.create_user(_id integer, _firstname character varying, _lastname character varying, _username character varying, _avatar character varying, _phone character varying) OWNER TO postgres;

--
-- Name: create_user_notification(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_user_notification() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
	IF (TG_OP = 'INSERT') THEN
		INSERT INTO "Notification" (type, img, text)
		VALUES 
		('new_user', '', concat('Добавлен новый пользователь ', new.firstname, ' ', new.lastname));
		RETURN NEW;
	end if;
END;
$$;


ALTER FUNCTION public.create_user_notification() OWNER TO postgres;

--
-- Name: get_messages(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_messages() RETURNS TABLE(schedule text, about text)
    LANGUAGE plpgsql
    AS $$
begin
	return query select "Message".schedule, "Message".about from "Message";
END;
$$;


ALTER FUNCTION public.get_messages() OWNER TO postgres;

--
-- Name: get_newsletter(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_newsletter() RETURNS TABLE(id integer, content text)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY SELECT "Newsletter".id, "Newsletter".content FROM "Newsletter";
END; $$;


ALTER FUNCTION public.get_newsletter() OWNER TO postgres;

--
-- Name: read_all_notification(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.read_all_notification() RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	UPDATE "Notification" SET read = true WHERE read=false;
END;
$$;


ALTER FUNCTION public.read_all_notification() OWNER TO postgres;

--
-- Name: set_user_active(integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_user_active(_id integer, _active boolean) RETURNS TABLE(id integer, firstname character varying, lastname character varying, phone character varying, username character varying, avatar character varying, active boolean)
    LANGUAGE plpgsql
    AS $$
begin
		return query UPDATE "User" SET 
					active = _active
					WHERE "User".id=_id 
					returning "User".id, "User".firstname, "User".lastname, "User".phone, "User".username, "User".avatar, "User".active;
END;
$$;


ALTER FUNCTION public.set_user_active(_id integer, _active boolean) OWNER TO postgres;

--
-- Name: update_about(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_about(_about text) RETURNS TABLE(schedule text, about text)
    LANGUAGE plpgsql
    AS $$
declare
msg_exist integer;
begin
	select count(*) from "Message" into msg_exist;
	IF msg_exist = 1 then
		return query UPDATE "Message" SET 
					about = _about
					WHERE id=1 
					returning "Message".schedule, "Message".about;
	else
		return query insert into "Message" (about) values (_about) returning "Message".schedule, "Message".about;
	end if;
END;
$$;


ALTER FUNCTION public.update_about(_about text) OWNER TO postgres;

--
-- Name: update_messages(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_messages(_schedule text, _about text) RETURNS TABLE(schedule text, about text)
    LANGUAGE plpgsql
    AS $$
declare
msg_exist integer;
begin
	select count(*) from "Message" into msg_exist;
	IF msg_exist = 1 then
		return query UPDATE "Message" SET 
					schedule = _schedule, about = _about 
					WHERE id=1 
					returning "Message".schedule, "Message".about;
	else
		return query insert into "Message" (schedule, about) values (_schedule, _about) returning "Message".schedule, "Message".about;
	end if;
END;
$$;


ALTER FUNCTION public.update_messages(_schedule text, _about text) OWNER TO postgres;

--
-- Name: update_schedule(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_schedule(_schedule text) RETURNS TABLE(schedule text, about text)
    LANGUAGE plpgsql
    AS $$
declare
msg_exist integer;
begin
	select count(*) from "Message" into msg_exist;
	IF msg_exist = 1 then
		return query UPDATE "Message" SET 
					schedule = _schedule
					WHERE id=1 
					returning "Message".schedule, "Message".about;
	else
		return query insert into "Message" (schedule) values (_schedule) returning "Message".schedule, "Message".about;
	end if;
END;
$$;


ALTER FUNCTION public.update_schedule(_schedule text) OWNER TO postgres;

--
-- Name: update_user_active(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_user_active(_id integer) RETURNS TABLE(schedule text, about text)
    LANGUAGE plpgsql
    AS $$
begin
		return query UPDATE "User" SET 
					active = false
					WHERE "User".id=_id 
					returning "User".id, "User".firstname, "User".lastname, "User".phone, "User".username, "User".avatar;
END;
$$;


ALTER FUNCTION public.update_user_active(_id integer) OWNER TO postgres;

--
-- Name: update_user_phone(integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_user_phone(_chatid integer, _phone character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	UPDATE "User" SET 
		phone = _phone
		WHERE id=_chatId;
END;
$$;


ALTER FUNCTION public.update_user_phone(_chatid integer, _phone character varying) OWNER TO postgres;

--
-- Name: user_disabled(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.user_disabled(_id integer) RETURNS TABLE(id integer, firstname character varying, lastname character varying, phone character varying, username character varying, avatar character varying, active boolean)
    LANGUAGE plpgsql
    AS $$
begin
		return query UPDATE "User" SET 
					active = false
					WHERE "User".id=_id 
					returning "User".id, "User".firstname, "User".lastname, "User".phone, "User".username, "User".avatar, "User".active;
END;
$$;


ALTER FUNCTION public.user_disabled(_id integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: Message; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Message" (
    id integer NOT NULL,
    schedule text,
    about text
);


ALTER TABLE public."Message" OWNER TO postgres;

--
-- Name: Newsletter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Newsletter" (
    id integer NOT NULL,
    content text
);


ALTER TABLE public."Newsletter" OWNER TO postgres;

--
-- Name: Notification; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Notification" (
    id integer NOT NULL,
    type character varying,
    img text,
    created_date text DEFAULT to_char(CURRENT_TIMESTAMP, 'HH24:MI DD.MM.YYYY'::text),
    text text,
    read boolean DEFAULT false
);


ALTER TABLE public."Notification" OWNER TO postgres;

--
-- Name: Notification_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Notification_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Notification_id_seq" OWNER TO postgres;

--
-- Name: Notification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Notification_id_seq" OWNED BY public."Notification".id;


--
-- Name: User; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."User" (
    id integer NOT NULL,
    firstname character varying NOT NULL,
    lastname character varying NOT NULL,
    phone character varying,
    username character varying,
    active boolean DEFAULT true,
    avatar character varying
);


ALTER TABLE public."User" OWNER TO postgres;

--
-- Name: User_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."User_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."User_id_seq" OWNER TO postgres;

--
-- Name: User_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."User_id_seq" OWNED BY public."User".id;


--
-- Name: message_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.message_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.message_id_seq OWNER TO postgres;

--
-- Name: message_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.message_id_seq OWNED BY public."Message".id;


--
-- Name: newsletter_column1_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.newsletter_column1_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.newsletter_column1_seq OWNER TO postgres;

--
-- Name: newsletter_column1_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.newsletter_column1_seq OWNED BY public."Newsletter".id;


--
-- Name: Message id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Message" ALTER COLUMN id SET DEFAULT nextval('public.message_id_seq'::regclass);


--
-- Name: Newsletter id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Newsletter" ALTER COLUMN id SET DEFAULT nextval('public.newsletter_column1_seq'::regclass);


--
-- Name: Notification id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Notification" ALTER COLUMN id SET DEFAULT nextval('public."Notification_id_seq"'::regclass);


--
-- Data for Name: Message; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Message" (id, schedule, about) FROM stdin;
1	Выкладываю расписание на следующую неделю. Вот оно какое у нас:\nСмотрите...	Ухуух
\.


--
-- Data for Name: Newsletter; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Newsletter" (id, content) FROM stdin;
1	НОВОСТЬ 1
2	НОВОСТЬ 2
3	НОВОСТЬ 3
4	УХУХУХУХАХАЫХА
\.


--
-- Data for Name: Notification; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Notification" (id, type, img, created_date, text, read) FROM stdin;
8	new_user		19:15 05.02.2019	Добавлен новый пользователь Denis Tsvetkov	t
9	new_user		19:18 05.02.2019	Добавлен новый пользователь Артём Цветков	t
10	new_user		18:17 06.02.2019	Добавлен новый пользователь Denis Tsvetkov	t
11	new_user		18:28 06.02.2019	Добавлен новый пользователь Denis Tsvetkov	t
12	new_user		18:30 06.02.2019	Добавлен новый пользователь Denis Tsvetkov	t
13	new_user		18:31 06.02.2019	Добавлен новый пользователь Denis Tsvetkov	t
14	new_user		18:59 06.02.2019	Добавлен новый пользователь Denis Tsvetkov	t
4	new_user		03:56 03.02.2019	Добавлен новый пользователь тест тестович	t
3	new_user		08:54 03.02.2019	Добавлен новый пользователь Денис2432 Цвfdsетков343	t
5	new_user		22:57 05.02.2019	Добавлен новый пользователь Петя Иванов	t
6	new_user		19:01 05.02.2019	Добавлен новый пользователь Артём Цветков	t
7	new_user		19:13 05.02.2019	Добавлен новый пользователь Светлана Цветкова	t
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."User" (id, firstname, lastname, phone, username, active, avatar) FROM stdin;
242346858	Denis	Tsvetkov		denis_tsvetkov	t	https://api.telegram.org/file/bot571499408:AAEtxaMQ6RqbdpYK80SSa_T0vYNvLASLQ3g/photos/file_0.jpg
\.


--
-- Name: Notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Notification_id_seq"', 14, true);


--
-- Name: User_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."User_id_seq"', 1, false);


--
-- Name: message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.message_id_seq', 1, true);


--
-- Name: newsletter_column1_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.newsletter_column1_seq', 4, true);


--
-- Name: Notification Notification_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Notification"
    ADD CONSTRAINT "Notification_pkey" PRIMARY KEY (id);


--
-- Name: User new_user; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER new_user AFTER INSERT ON public."User" FOR EACH ROW EXECUTE PROCEDURE public.create_user_notification();


--
-- PostgreSQL database dump complete
--

