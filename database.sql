--Builds the initial tables for the project
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE users (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  username varchar(20) NOT NULL UNIQUE,
  password varchar(20)
);

CREATE TABLE notes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES users(id) NOT NULL,
  title VARCHAR(100),
  note VARCHAR(5000),
  tag VARCHAR(100),
  created TIMESTAMPTZ NOT NULL,
  last_edited TIMESTAMPTZ NOT NULL
);

CREATE TABLE notes_history (
  note_id UUID REFERENCES users(id) NOT NULL,
  note_version INTEGER NOT NULL,
  title_historic VARCHAR(100),
  note_historic VARCHAR(5000),
  tag_historic VARCHAR(100),
  edited TIMESTAMPTZ NOT NULL,
  PRIMARY KEY(note_id, note_version)
);

--Logic to track and automatically increment a note's version number in the notes_history table
--A table to track the current version of each note
CREATE TABLE notes_version_counter(
  note_id UUID PRIMARY KEY REFERENCES users(id),
  current_version INTEGER NOT NULL
);

--A function to calculate the next version for a note
CREATE FUNCTION next_version(p_note_id UUID)
  RETURNS INTEGER
AS
$$
  INSERT INTO notes_version_counter (note_id, current_version)
  VALUES (p_note_id, 1)
  ON CONFLICT (note_id)
  DO UPDATE
    SET current_version = notes_version_counter.current_version + 1
  RETURNING current_version;
$$
language sql
volatile;

--A function to increment the version of a note
CREATE FUNCTION increment_version()
  RETURNS TRIGGER
AS
$$
BEGIN
  new."note_version" := next_version(new."note_id");
  RETURN new;
END;
$$
language plpgsql;

--A trigger when inserting a note into the history table to call the increment_version function
CREATE TRIGGER TR_notes_history_increment_version
  BEFORE INSERT ON notes_history
  FOR EACH ROW
  EXECUTE PROCEDURE increment_version();
