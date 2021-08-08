CREATE TABLE "Tweets" (
    id                  character varying(255) PRIMARY KEY NOT NULL,
    account_id          character varying(255) NOT NULL,
    favorite_count      bigint,
    retweet_count       bigint,
    content             text NOT NULL,
    created_at          timestamp with time zone NOT NULL,
    updated_at          timestamp with time zone NOT NULL
)
