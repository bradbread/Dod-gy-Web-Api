﻿CREATE TABLE CLIENTACCOUNT3815(
    ACCOUNTID INTEGER IDENTITY(30001, 1),
    ACCTNAME NVARCHAR(100) NOT NULL,
    BALANCE MONEY NOT NULL,
    CREDITLIMIT MONEY NOT NULL,
    CONSTRAINT PK_CLIENTACCOUNT PRIMARY KEY(ACCOUNTID),
    CONSTRAINT CHK_CLIENTACCOUNT_BALANCE_CREDIT CHECK(BALANCE<=CREDITLIMIT),
    CONSTRAINT UQ_CLENTACCOUNT_NAME UNIQUE(ACCTNAME)
);