--Builds the initial tables for the project

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE "photos" (
  "id" uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  "title" varchar(50) NOT NULL
);

CREATE TABLE "users" (
  "id" uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  "username" varchar(20) NOT NULL UNIQUE,
  "password" varchar(20) NOT NULL
);

CREATE TABLE "captions" (
  "id" uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  "photo_id" uuid REFERENCES photos(id) NOT NULL,
  "user_id" uuid REFERENCES users(id) NOT NULL,
  "caption" varchar(500) NOT NULL
);