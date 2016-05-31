-- This change is backward incompatible - you can't do A/B testing
ALTER TABLE PERSON CHANGE last_name surname VARCHAR;