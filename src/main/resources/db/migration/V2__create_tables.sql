create table if not exists users (
    id SERIAL CONSTRAINT users_pk PRIMARY KEY,
    email VARCHAR(128) NOT NULL CHECK (email like '%@%'),
    user_name VARCHAR(128) NOT NULL,

    CONSTRAINT users_email_uq UNIQUE (email),
    CONSTRAINT users_user_name_uq UNIQUE (user_name)
);

create table if not exists advisors (
    user_id INTEGER,
    role advisor_role_enum NOT NULL,

    CONSTRAINT advisors_pk PRIMARY KEY (user_id),
    CONSTRAINT advisors_user_id_fk FOREIGN KEY (user_id) REFERENCES users ON DELETE CASCADE
);

create table if not exists applicants (
    user_id INTEGER,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    social_security_number INTEGER NOT NULL,

    CONSTRAINT applicants_pk PRIMARY KEY (user_id),
    CONSTRAINT applicants_user_id_fk FOREIGN KEY (user_id) REFERENCES users ON DELETE CASCADE,
    CONSTRAINT applicants_social_security_number_uq UNIQUE (social_security_number)
);

create table if not exists addresses (
    id SERIAL,
    applicant_id INTEGER NOT NULL,
    city VARCHAR(255) NOT NULL,
    street VARCHAR(255) NOT NULL,
    number VARCHAR(255) NOT NULL,
    zip INTEGER NOT NULL,
    apt VARCHAR(255) NOT NULL,

    CONSTRAINT addresses_pk PRIMARY KEY (id),
    CONSTRAINT addresses_applicant_id_fk FOREIGN KEY (applicant_id) REFERENCES applicants ON DELETE CASCADE
);

CREATE INDEX addresses_applicant_id_idx ON addresses(applicant_id);

create table if not exists phone_numbers (
    id SERIAL,
    applicant_id INTEGER NOT NULL,
    number INTEGER NOT NULL,
    type phone_number_enum NOT NULL,

    CONSTRAINT phone_numbers_pk PRIMARY KEY (id),
    CONSTRAINT phone_numbers_applicant_id_fk FOREIGN KEY (applicant_id) REFERENCES applicants ON DELETE CASCADE
);

CREATE INDEX phone_numbers_applicant_id_idx ON phone_numbers(applicant_id);

create table if not exists applications (
    id SERIAL,
    applicant_id INTEGER NOT NULL,
    advisor_id INTEGER,
    amount MONEY NOT NULL,
    status status_enum NOT NULL DEFAULT 'new',
    created timestamp NOT NULL DEFAULT now(),
    assigned timestamp,

    CONSTRAINT applications_pk PRIMARY KEY (id),
    CONSTRAINT applications_applicant_id_fk FOREIGN KEY (applicant_id) REFERENCES applicants,
    CONSTRAINT applications_advisor_id_fk FOREIGN KEY (advisor_id) REFERENCES advisors
);

CREATE INDEX applications_applicant_id_idx ON applications(applicant_id);
CREATE INDEX applications_advisor_id_idx ON applications(advisor_id);
