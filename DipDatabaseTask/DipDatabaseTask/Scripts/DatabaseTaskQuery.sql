﻿
IF OBJECT_ID('PURCHASEORDER3815') IS NOT NULL
DROP TABLE PURCHASEORDER3815;


IF OBJECT_ID('INVENTORY3815') IS NOT NULL
DROP TABLE INVENTORY3815;

IF OBJECT_ID('ORDERLINE3815') IS NOT NULL
DROP TABLE ORDERLINE3815;

IF OBJECT_ID('ORDER3815') IS NOT NULL
DROP TABLE [ORDER3815];

IF OBJECT_ID('AUTHORISEDPERSON3815') IS NOT NULL
DROP TABLE AUTHORISEDPERSON3815;

IF OBJECT_ID('ACCOUNTPAYMENT3815') IS NOT NULL
DROP TABLE ACCOUNTPAYMENT3815;

IF OBJECT_ID('CLIENTACCOUNT3815') IS NOT NULL
DROP TABLE CLIENTACCOUNT3815;

IF OBJECT_ID('PRODUCT3815') IS NOT NULL
DROP TABLE PRODUCT3815;

IF OBJECT_ID('LOCATION3815') IS NOT NULL
DROP TABLE [LOCATION3815];

IF OBJECT_ID('GENERALLEDGER3815') IS NOT NULL
DROP TABLE GENERALLEDGER3815;

GO

CREATE TABLE GENERALLEDGER3815(
    ITEMID INTEGER,
    DESCRIPTION NVARCHAR(100),
    AMOUNT MONEY,
    CONSTRAINT PK_GENERALLEDGER PRIMARY KEY (ITEMID),
    CONSTRAINT UQ_GENERALEDGER_DESCRIPTION UNIQUE(DESCRIPTION)
);

INSERT INTO GENERALLEDGER3815 (ITEMID, DESCRIPTION, AMOUNT) VALUES
(1, 'ASSETSCASH', 100000.00),
(2, 'ASSETSSTOCK', 0),
(3, 'ASSETSACCOUNT', 0);

CREATE TABLE [LOCATION3815](
    LOCATIONID NVARCHAR(8),
    LOCNAME NVARCHAR(50) NOT NULL,
    ADDRESS NVARCHAR(200) NOT NULL,
    MANAGER NVARCHAR(100),
    CONSTRAINT PK_LOCATION PRIMARY KEY (LOCATIONID)
);

CREATE TABLE PRODUCT3815(
    PRODUCTID INTEGER IDENTITY(10001, 1),
    PRODNAME NVARCHAR(100) NOT NULL,
    BUYPRICE MONEY,
    SELLPRICE MONEY,
    CONSTRAINT PK_PRODUCT PRIMARY KEY(PRODUCTID),
    CONSTRAINT CHK_WHOLESALE_RETAIL CHECK(BUYPRICE < SELLPRICE)
);

CREATE TABLE CLIENTACCOUNT3815(
    ACCOUNTID INTEGER IDENTITY(30001, 1),
    ACCTNAME NVARCHAR(100) NOT NULL,
    BALANCE MONEY NOT NULL,
    CREDITLIMIT MONEY NOT NULL,
    CONSTRAINT PK_CLIENTACCOUNT PRIMARY KEY(ACCOUNTID),
    CONSTRAINT CHK_CLIENTACCOUNT_BALANCE_CREDIT CHECK(BALANCE<=CREDITLIMIT),
    CONSTRAINT UQ_CLENTACCOUNT_NAME UNIQUE(ACCTNAME)
);

CREATE TABLE ACCOUNTPAYMENT3815(
    ACCOUNTID INTEGER,
    DATETIMERECEIVED DATETIME,
    AMOUNT MONEY NOT NULL,
    CONSTRAINT PK_ACCOUNTPAYMENT PRIMARY KEY(ACCOUNTID, DATETIMERECEIVED),
    CONSTRAINT FK_ACCOUNTPAYMENT_ACCOUNT FOREIGN KEY (ACCOUNTID) REFERENCES CLIENTACCOUNT3815,
    CONSTRAINT CHK_ACCOUNTPAYMENT_AMOUNT CHECK(AMOUNT >0)
);

CREATE TABLE AUTHORISEDPERSON3815(
    USERID INTEGER IDENTITY(50001, 1),
    FIRSTNAME NVARCHAR(100) NOT NULL,
    SURNAME NVARCHAR(100) NOT NULL,
    EMAIL NVARCHAR(100) NOT NULL,
    [PASSWORD] NVARCHAR(100) NOT NULL,
    ACCOUNTID INTEGER NOT NULL,
    CONSTRAINT PK_AUTHORISEDPERSON PRIMARY KEY(USERID),
    CONSTRAINT FK_AUTHORISEDPERSON_CLIENTACCOUNT FOREIGN KEY(ACCOUNTID) REFERENCES CLIENTACCOUNT3815,
    CONSTRAINT CHK_AUTHORISEDPERSON_EMAIL CHECK(EMAIL LIKE '%@%')
);

CREATE TABLE [ORDER3815](
    ORDERID INTEGER IDENTITY(70001, 1),
    SHIPPINGADDRESS NVARCHAR(200) NOT NULL,
    DATETIMECREATED DATETIME NOT NULL,
    DATETIMEDISPATCHED DATETIME,
    TOTAL MONEY NOT NULL,
    USERID INTEGER NOT NULL,
    CONSTRAINT PK_ORDER PRIMARY KEY(ORDERID),
    CONSTRAINT FK_ORDER_AUTHORISEDPERSON FOREIGN KEY(USERID) REFERENCES AUTHORISEDPERSON3815,
    CONSTRAINT CHK_ORDER_TOTAL CHECK(TOTAL >= 0)
);


CREATE TABLE ORDERLINE3815(
    ORDERID INTEGER,
    PRODUCTID INT,
    QUANTITY INT NOT NULL,
    DISCOUNT DECIMAL DEFAULT 0,
    SUBTOTAL MONEY NOT NULL,
    CONSTRAINT PK_ORDERLINE PRIMARY KEY(ORDERID, PRODUCTID),
    CONSTRAINT FK_ORDERLINE_ORDER FOREIGN KEY(ORDERID) REFERENCES [ORDER3815],
    CONSTRAINT FK_ORDERLINE_PRODUCT FOREIGN KEY(PRODUCTID) REFERENCES PRODUCT3815,
    CONSTRAINT CHK_ORDER_DISCOUNT CHECK(DISCOUNT >=0 AND DISCOUNT <= 0.25),
    CONSTRAINT CHK_ORDERLINE_SUBTOTAL CHECK(SUBTOTAL > 0)
);

CREATE TABLE INVENTORY3815(
    PRODUCTID INT,
    LOCATIONID NVARCHAR(8),
    NUMINSTOCK INTEGER NOT NULL,
    CONSTRAINT PK_INVENTORY PRIMARY KEY(PRODUCTID, LOCATIONID),
    CONSTRAINT FK_INVENTORY_PRODUCT FOREIGN KEY(PRODUCTID) REFERENCES PRODUCT3815,
    CONSTRAINT FK_INVENTORY_LOCATION FOREIGN KEY(LOCATIONID) REFERENCES LOCATION3815,
    CONSTRAINT CHK_INVENTORY_NUMINSTOCK CHECK(NUMINSTOCK >=0)
);

CREATE TABLE PURCHASEORDER3815(
    PRODUCTID INT,
    LOCATIONID NVARCHAR(8),
    DATETIMECREATED DATETIME,
    QUANTITY INTEGER,
    TOTAL MONEY,
    CONSTRAINT PK_PURCHASEORDER PRIMARY KEY(PRODUCTID, LOCATIONID, DATETIMECREATED),
    CONSTRAINT FK_PURCHASEORDER_PRODUCT FOREIGN KEY(PRODUCTID) REFERENCES PRODUCT3815,
    CONSTRAINT FK_PURCHASEORDER_LOCATION FOREIGN KEY(LOCATIONID) REFERENCES LOCATION3815,
    CONSTRAINT CHK_PURCHASEORDER_QUANTITY CHECK(QUANTITY > 0)
);

GO


--SELECT * FROM SYS.TABLES;

--------------------------

-- SET UP LOCATION, PRODUCT AND INVENTORY
BEGIN

    INSERT INTO LOCATION3815(LOCATIONID, LOCNAME, ADDRESS, MANAGER)VALUES
    ('MLB3931', 'Melbourne South East', '123 Demon Street, Mornington, 3931', 'Bruce Wayne');

    INSERT INTO PRODUCT3815(PRODNAME, BUYPRICE, SELLPRICE) VALUES
    ('APPLE ME PHONE X', '890.00', 1295.00 );

    DECLARE @PRODID INT = @@IDENTITY;

    INSERT INTO INVENTORY3815(PRODUCTID, LOCATIONID, NUMINSTOCK) VALUES
    (@PRODID, 'MLB3931', 0);

    -- ADD A NEW CLIENT ACCOUNT AND A NEW AUTHORISED USER FOR THAT ACCOUNT

    INSERT INTO CLIENTACCOUNT3815(ACCTNAME, BALANCE, CREDITLIMIT) VALUES
    ('FREDS LOCAL PHONE STORE', '0', 10000.00 );

    DECLARE @ACCOUNTID INT = @@IDENTITY;

    INSERT INTO AUTHORISEDPERSON3815(FIRSTNAME, SURNAME, EMAIL, [PASSWORD], ACCOUNTID) VALUES
    ('Fred', 'Flintstone', 'fred@fredsphones.com', 'secret', @ACCOUNTID);

    DECLARE @USERID INT = @@IDENTITY;

    -----------

    -- BUY SOME STOCK

    -- ADD A PURCHASE ORDER ROW
    INSERT INTO PURCHASEORDER3815(PRODUCTID, LOCATIONID, DATETIMECREATED, QUANTITY, TOTAL) VALUES
    (@PRODID,  'MLB3931', '10-Apr-2020', 50, 44500.00);

    -- UPDATE OUR INVENTORY FOR THAT STOCK
    UPDATE INVENTORY3815 SET NUMINSTOCK = 50 WHERE PRODUCTID = @PRODID AND LOCATIONID = 'MLB3931';

    -- UPDATE THE GENERAL LEDGER INCREASING THE VALUE OF OUR STOCK ASSETS AND DECREASING THE CASH ASSETS
    UPDATE GENERALLEDGER3815 SET AMOUNT = AMOUNT - 44500.00 WHERE DESCRIPTION = 'ASSETSCASH';
    UPDATE GENERALLEDGER3815 SET AMOUNT = AMOUNT + 44500.00 WHERE DESCRIPTION = 'ASSETSSTOCK';

    -----------

    -- CUSTOMER MAKES AN ORDER - (INITIALLY THE ORDER IS NOT FULFILLED)

    INSERT INTO ORDER3815(SHIPPINGADDRESS, DATETIMECREATED, DATETIMEDISPATCHED, TOTAL, USERID) VALUES
    ('7 Lucky Strike, Bedrock, USB, 1111', '20-Apr-2020', NULL, 6151.25, @USERID);

    DECLARE @ORDERID INT = @@IDENTITY;

    INSERT INTO ORDERLINE3815(ORDERID, PRODUCTID, QUANTITY, DISCOUNT, SUBTOTAL) VALUES
    (@ORDERID, @PRODID, 5, 0.05, '6151.25');

    -- WE FULLFILL THE ORDER

    -- UPDATE THE ORDER TO GIVE IT A FULLFUILLED DATE
    UPDATE ORDER3815 SET DATETIMEDISPATCHED = '21-Apr-2020' WHERE ORDERID = @ORDERID;

    -- UPDATE THE CLIENTS ACCOUNT BALANCE TO INCLUDE THE VALUE OF THE ORDER
    UPDATE CLIENTACCOUNT3815 SET BALANCE = BALANCE + 6151.25 WHERE ACCOUNTID = @ACCOUNTID;

    -- UPDATE THE GENERAL LEDGER INCREASING VALUE OF ACCOUNTS, DECEASING VALUE OF STOCK
    UPDATE GENERALLEDGER3815 SET AMOUNT = AMOUNT + 6151.25  WHERE DESCRIPTION = 'ASSETSACCOUNT';
    UPDATE GENERALLEDGER3815 SET AMOUNT = AMOUNT - (5*890) WHERE DESCRIPTION = 'ASSETSSTOCK';

    -------------

    -- CLIENT MAKES AN ACCOUNT OFF THIER ACCOUNT BALANCE

    -- ADD A ROW TO ACCOUNTPAYMENT3815
    INSERT INTO ACCOUNTPAYMENT3815(ACCOUNTID, DATETIMERECEIVED, AMOUNT) VALUES
        (@ACCOUNTID, '25-Apr-2020', '2000.00');

    -- UPDATE THE CLIENT ACCOUNT TO REFLECT THE BALANCE CHANGE
    UPDATE CLIENTACCOUNT3815 SET BALANCE = BALANCE - 2000.00 WHERE ACCOUNTID = @ACCOUNTID;

    -- UPDATE THE GENERAL LEDGER - INCREASE ASSETSCASH AND DECREASE ASSETS ACCOUNT
    UPDATE GENERALLEDGER3815 SET AMOUNT = AMOUNT + 2000.00 WHERE DESCRIPTION = 'ASSETSCASH';
    UPDATE GENERALLEDGER3815 SET AMOUNT = AMOUNT - 2000.00 WHERE DESCRIPTION = 'ASSETSACCOUNT';
END;

GO
----------------------------


IF OBJECT_ID('ADD_LOCATION') IS NOT NULL
DROP PROCEDURE ADD_LOCATION;
GO


CREATE PROCEDURE ADD_LOCATION @PLOCID NVARCHAR(8), @PLOCNAME NVARCHAR(50), @PLOCADDRESS NVARCHAR(200), @PMANAGER NVARCHAR(100) AS
BEGIN
    -- THE FOLLOWING MUST BE COMPLETED AS A SINGLE TRANSACTION
    -- insert the specified values into the table LOCATION3815
    -- ADD A ROW FOR THIS LOCATION TO THE INVENTORY3815 TABLE **FOR EACH** PRODUCT IN THE PRODUCT3815 TABLE
    -- I.E. IF THERE ARE 4 PRODUCTS THIS WILL BE 4 NEW ROWS IN THE INVENTORY TABLE
    -- RETURN THE LOCID OF THE NEW LOCATION

    -- EXCEPTIONS
    -- if the location id is a duplicate throw error: number 51001  message : 'Duplicate Location ID'
    -- for any other errors throw error : number 50000  message:  error_message()
    BEGIN TRAN
	    BEGIN TRY
            IF (SELECT COUNT(LOCATIONID) FROM LOCATION3815 WHERE LOCATIONID = @PLOCID) > 0
                THROW 51001, 'Duplicate location ID', 1

		    INSERT INTO LOCATION3815 (LOCATIONID, LOCNAME, ADDRESS, MANAGER)
		    VALUES (@PLOCID, @PLOCNAME, @PLOCADDRESS, @PMANAGER)

            DECLARE  @PRODID INT
            DECLARE cur CURSOR
            FOR SELECT PRODUCTID
            FROM PRODUCT3815

            OPEN cur
            FETCH NEXT FROM cur INTO @PRODID

            WHILE @@FETCH_STATUS = 0
            BEGIN
                INSERT INTO INVENTORY3815 (PRODUCTID, LOCATIONID, NUMINSTOCK)
                VALUES (@PRODID, @PLOCID, 0)
                FETCH NEXT FROM cur INTO @PRODID
            END

            CLOSE cur
            DEALLOCATE cur

            --locid is given by the user so kinda weird to return it as it would just be an output variable set to @PLOCID
            --SET @OUTLOCID = ( SELECT LOCATIONID FROM LOCATION3815 WHERE @PLOCID = LOCATIONID) why?

		    COMMIT TRAN
	    END TRY

	    BEGIN CATCH
            ROLLBACK TRAN

            IF ERROR_NUMBER() = 51001
                THROW
            ELSE
                BEGIN
                    DECLARE @ERRORMESSAGE NVARCHAR(MAX)  = ERROR_MESSAGE();
                    THROW 50000, @ERRORMESSAGE, 1
                END
	    END CATCH
END;



GO
IF OBJECT_ID('GET_LOCATION_BY_ID') IS NOT NULL
DROP PROCEDURE GET_LOCATION_BY_ID ;
GO


CREATE PROCEDURE GET_LOCATION_BY_ID @PLOCID NVARCHAR(8) AS
BEGIN
    -- return the specified location.

    -- EXCEPTIONS
    -- if the location id is invalid throw error: number 51002  message : 'Location Doesnt Exist'
    -- for any other errors throw error : number 50000  message:  error_message()
    BEGIN TRY
		IF (SELECT COUNT(*) FROM LOCATION3815 WHERE LOCATIONID = @PLOCID) < 1
            THROW 51002, 'LOCATION DOES NOT EXIST', 1

        SELECT * FROM LOCATION3815 WHERE LOCATIONID = @PLOCID;

	END TRY
	BEGIN CATCH
        IF ERROR_NUMBER() = 51002
            THROW;
        ELSE
            BEGIN
                DECLARE @ERRORMESSAGE NVARCHAR(MAX)  = ERROR_MESSAGE();
                THROW 50000, @ERRORMESSAGE, 1
            END
	END CATCH
END;


GO
IF OBJECT_ID('ADD_PRODUCT') IS NOT NULL
DROP PROCEDURE ADD_PRODUCT ;
GO


CREATE PROCEDURE ADD_PRODUCT @PPRODNAME NVARCHAR(100), @PBUYPRICE MONEY, @PSELLPRICE MONEY AS
BEGIN
    -- THE FOLLOWING MUST BE COMPLETED AS A SINGLE TRANSACTION
    -- insert the specified values into the table PRODUCT3815
    -- ADD A ROW FOR THIS PRODUCT TO THE INVENTORY3815 TABLE **FOR EACH** LOCTAION IN THE LOCATION3815 TABLE
    -- I.E. IF THERE ARE 4 LOCATIONS THIS WILL BE 4 NEW ROWS IN THE INVENTORY TABLE
    -- RETURN THE NEW PRODUCTS PRODUCTID

    -- EXCEPTIONS
    -- for any other errors throw error : number 50000  message:  error_message()
    BEGIN TRAN
        BEGIN TRY
            INSERT INTO PRODUCT3815 (PRODNAME, BUYPRICE, SELLPRICE)
            VALUES (@PPRODNAME, @PBUYPRICE, @PSELLPRICE)
            

            DECLARE @PPRODID INT = @@IDENTITY
            DECLARE @PLOCID NVARCHAR(8);
            DECLARE cursor_locations CURSOR
            FOR SELECT LOCATIONID
            FROM LOCATION3815;

            OPEN cursor_locations;

            FETCH NEXT FROM cursor_locations INTO @PLOCID

            WHILE @@FETCH_STATUS = 0
            BEGIN
                INSERT INTO INVENTORY3815(PRODUCTID, LOCATIONID, NUMINSTOCK)
                VALUES(@PPRODID, @PLOCID, 0)
                FETCH NEXT FROM cursor_locations INTO @PLOCID
            END

            CLOSE cursor_locations
            DEALLOCATE cursor_locations
            COMMIT TRAN
            RETURN @PPRODID
        END TRY
        BEGIN CATCH
            ROLLBACK TRAN


            DECLARE @ERRORMESSAGE NVARCHAR(MAX)  = ERROR_MESSAGE();
            THROW 50000, @ERRORMESSAGE, 1

        END CATCH
END;


GO
IF OBJECT_ID('GET_PRODUCT_BY_ID') IS NOT NULL
DROP PROCEDURE GET_PRODUCT_BY_ID ;
GO


CREATE PROCEDURE GET_PRODUCT_BY_ID @PPRODID INT AS
BEGIN
    -- return the specified PRODUCT.

    -- EXCEPTIONS
    -- if the PRODUCT id iis invalid throw error: number 52002  message : 'Product Doesnt Exist'
    -- for any other errors throw error : number 50000  message:  error_message()
    BEGIN TRY
        IF (SELECT COUNT(PRODUCTID) FROM PRODUCT3815 WHERE PRODUCTID = @PPRODID) < 1
            THROW 52002, 'Product Doesnt Exist', 1

        SELECT * FROM PRODUCT3815 WHERE PRODUCTID = @PPRODID;


    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() = 52002
            THROW
        ELSE
            BEGIN
                DECLARE @ERRORMESSAGE NVARCHAR(MAX)  = ERROR_MESSAGE();
                THROW 50000, @ERRORMESSAGE, 1
            END
    END CATCH
END;


GO
IF OBJECT_ID('PURCHASE_STOCK') IS NOT NULL
DROP PROCEDURE PURCHASE_STOCK;
GO


CREATE PROCEDURE PURCHASE_STOCK @PPRODID INT, @PLOCID NVARCHAR(8), @PQTY INT AS
BEGIN

    -- THE FOLLOWING MUST BE COMPLETED AS A SINGLE TRANSACTION

    -- insert the A ROW TO THE PURCHASE ORDER TABLE
    -- USE THE CURRENT SYSTEM DATETIME AS FOR THE DATETIMECREATED FIELD
    -- CALCULATE THE TOTAL BASED ON THE BUYPRICE OF THE PRODUCT SPECIFICED AND THE QUANTITY IN @PQTY
    -- UPDATE INVENTORY3815 FOR THE SPECIFIED PRODUCT IN THE SPECIFIED LOCATION BY THE QTY PURCHASED
    -- DECREASE THE ASSETCASH ROW IN THE GENERAL LEDGER BY THE TOTAL AMOUNT OF THE ORDER
    -- INCREASE THE ASSETSTOCK ROW IN THE GENERAL LEDGER BY THE TOTAL AMOUNT OF THE ORDER

    -- EXCEPTIONS
    -- if the LOCATUON id is invalid throw error: number 51002  message : 'Location Doesnt Exist'
    -- if the PRODUCT id is invalid throw error: number 52002  message : 'Product Doesnt Exist'
    -- IF THERE IS INSUFFICIENT ASSETSCASH IN THE GENERAL LEDGER THEN THROW ERROR: 59001 MESSAGE : 'INSUFFICIENT CASH'
    -- for any other errors throw error : number 50000  message:  error_message()
    BEGIN TRAN
        BEGIN TRY
            IF (SELECT COUNT(LOCATIONID) FROM LOCATION3815 WHERE LOCATIONID = @PLOCID) < 1
                THROW 51001, 'Location Doesnt Exist', 1

            IF (SELECT COUNT(PRODUCTID) FROM PRODUCT3815 WHERE PRODUCTID = @PPRODID) < 1
                THROW 51002, 'Product Doesnt Exist', 1

            DECLARE @COST MONEY = @PQTY * (SELECT BUYPRICE FROM PRODUCT3815 WHERE PRODUCTID = @PPRODID);

            IF @COST > (SELECT AMOUNT FROM GENERALLEDGER3815 WHERE DESCRIPTION = 'ASSETSCASH')
                THROW 59001, 'INSUFFICIENT CASH', 1;

            INSERT INTO PURCHASEORDER3815 (PRODUCTID, LOCATIONID, DATETIMECREATED, QUANTITY, TOTAL)
            VALUES (@PPRODID, @PLOCID, SYSDATETIME(), @PQTY, @COST);

            UPDATE INVENTORY3815 SET NUMINSTOCK = (NUMINSTOCK + @PQTY) WHERE LOCATIONID = @PLOCID AND PRODUCTID = @PPRODID;

            UPDATE GENERALLEDGER3815 SET AMOUNT = AMOUNT - @COST WHERE DESCRIPTION = 'ASSETSCASH';
            UPDATE GENERALLEDGER3815 SET AMOUNT = AMOUNT + @COST WHERE DESCRIPTION = 'ASSETSSTOCK';

        COMMIT TRAN
        END TRY
        BEGIN CATCH
            ROLLBACK TRAN

            IF ERROR_NUMBER() = 51001 OR ERROR_NUMBER() = 51002 OR ERROR_NUMBER() = 59001
                THROW
            ELSE
                BEGIN
                    DECLARE @ERRORMESSAGE NVARCHAR(MAX)  = ERROR_MESSAGE();
                    THROW 50000, @ERRORMESSAGE, 1
                END
        END CATCH

END;

GO
IF OBJECT_ID('ADD_CLIENT_ACCOUNT') IS NOT NULL
DROP PROCEDURE ADD_CLIENT_ACCOUNT;
GO


CREATE PROCEDURE ADD_CLIENT_ACCOUNT @PACCTNAME NVARCHAR(100), @PBALANCE MONEY, @PCREDITLIMIT MONEY AS
BEGIN
    -- insert the specified values into the table CLIENTACCOUNT3815
    -- RETURN THE NEW ACCOUNTS ACCOUNTID

    -- EXCEPTIONS
    -- ACCOUNT NAME ALREADY EXISTS - SEE TABLE CONSTRAINTS - THROW ERROR 53001 : DUPLICATE ACCOUNT NAME
    -- for any other errors throw error : number 50000  message:  error_message()
    BEGIN TRY
        IF (SELECT COUNT(*) FROM CLIENTACCOUNT3815 WHERE ACCTNAME = @PACCTNAME) > 0
            THROW 53001, 'DUPLICATE ACCOUNT NAME', 1
        

        INSERT INTO CLIENTACCOUNT3815 (ACCTNAME, BALANCE, CREDITLIMIT)
        VALUES (@PACCTNAME, @PBALANCE, @PCREDITLIMIT)

        RETURN @@IDENTITY
    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() = 53001
            THROW
        ELSE
            BEGIN
                DECLARE @ERRORMESSAGE NVARCHAR(MAX)  = ERROR_MESSAGE();
                THROW 50000, @ERRORMESSAGE, 1
            END
    END CATCH

END;

GO
IF OBJECT_ID('ADD_AUTHORISED_PERSON') IS NOT NULL
DROP PROCEDURE ADD_AUTHORISED_PERSON;
GO

CREATE PROCEDURE ADD_AUTHORISED_PERSON @PFIRSTNAME NVARCHAR(100), @PSURNAME NVARCHAR(100), @PEMAIL NVARCHAR(100), @PPASSWORD NVARCHAR(100), @PACCOUNTID INT AS
BEGIN
    -- insert the specified values into the table AUTHORISEDPERSON3815
    -- RETURN THE NEW USERS USER ID

    -- EXCEPTIONS
    -- EMAIL IS INVALID (DOESN'T CONTAIN AN @ - SEE TABLE CONSTRAINTS)  - THROW ERROR 53003 : INVALID EMAIL ADDRESS
    -- for any other errors throw error : number 50000  message:  error_message()
    BEGIN TRY
        IF (@PEMAIL NOT LIKE '%@%')
            THROW 53003, 'INVALID EMAIL ADDRESS', 1

        INSERT INTO AUTHORISEDPERSON3815 (ACCOUNTID, FIRSTNAME, SURNAME, EMAIL, PASSWORD)
        VALUES (@PACCOUNTID, @PFIRSTNAME, @PSURNAME, @PEMAIL, @PPASSWORD)

        RETURN @@IDENTITY
    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() = 53003
            THROW
        ELSE
            BEGIN
                DECLARE @ERRORMESSAGE NVARCHAR(MAX)  = ERROR_MESSAGE();
                THROW 50000, @ERRORMESSAGE, 1
            END
    END CATCH
END;

GO

IF OBJECT_ID('MAKE_ACCOUNT_PAYMENT') IS NOT NULL
DROP PROCEDURE MAKE_ACCOUNT_PAYMENT;

GO


CREATE PROCEDURE MAKE_ACCOUNT_PAYMENT @PACCOUNTID INT, @PAMOUNT MONEY AS
BEGIN

    -- THE FOLLOWING MUST BE COMPLETED AS A SINGLE TRANSACTION
    -- insert the specified values into the table ACCOUNTPAYMENT3815 (USING THE CURRENT SYS DATETIME)
    -- UPDATE THE RELEVANT ACCOUNT IN CLENTACCOUNT3815 TO RELFECT THE BALANCE REDUCED BY THE PAYMENT
    -- UPDATE THE GENERAL LEDGER TO REDUCE ACCOUNT ASSETS BY THE PAYMENT AMOUNT
    -- UPDATE THE GENERAL LEDGER TO INCREASE CASH ASSETS BY THE PAYMENT AMOUNT

    -- EXCEPTIONS
    -- ACCOUNT DOESNT EXIST THROW ERROR 53002 : ACCOUNT DOES NOT EXIST 
    -- PAYMENT AMOUNT IS NEGATIVE (SEE TABLE CONSTRAINTS) THROW ERROR 53004 :   ACCOUNT PAYMENT AMOUNT MUST BE POSITIVE  
    -- for any other errors throw error : number 50000  message:  error_message()
    BEGIN TRAN
        BEGIN TRY
            IF (SELECT COUNT(ACCOUNTID) FROM CLIENTACCOUNT3815 WHERE ACCOUNTID = @PACCOUNTID) < 1
                THROW 53002, 'ACCOUNT DOES NOT EXIST', 1;

            IF @PAMOUNT < 0
                THROW 53004, 'ACCOUNT PAYMENT MUST BE POSITIVE', 1

            INSERT INTO ACCOUNTPAYMENT3815 (ACCOUNTID, AMOUNT, DATETIMERECEIVED)
            VALUES (@PACCOUNTID, @PAMOUNT, SYSDATETIME());

            UPDATE CLIENTACCOUNT3815 SET BALANCE = BALANCE - @PAMOUNT WHERE ACCOUNTID = @PACCOUNTID;

            UPDATE GENERALLEDGER3815 SET AMOUNT = AMOUNT - @PAMOUNT WHERE DESCRIPTION = 'ASSETSACCOUNT';

            UPDATE GENERALLEDGER3815 SET AMOUNT = AMOUNT + @PAMOUNT WHERE DESCRIPTION = 'ASSETSCASH';



        COMMIT TRAN
        END TRY
        BEGIN CATCH
            ROLLBACK TRAN

            IF ERROR_NUMBER() = 50002 OR ERROR_NUMBER() = 50004
                THROW
            ELSE
                BEGIN
                    DECLARE @ERRORMESSAGE NVARCHAR(MAX)  = ERROR_MESSAGE();
                    THROW 50000, @ERRORMESSAGE, 1
                END
        END CATCH
END;


GO

IF OBJECT_ID('GET_CLIENT_ACCOUNT_BY_ID') IS NOT NULL
DROP PROCEDURE GET_CLIENT_ACCOUNT_BY_ID;

GO


CREATE PROCEDURE GET_CLIENT_ACCOUNT_BY_ID @PACCOUNTID INT AS
BEGIN
    -- return the specified CLIENT ACCOUNT INCLUDING AND ALL AUTHORISED PERSONS DETAILS

    -- EXCEPTIONS
     -- ACCOUNT DOESNT EXIST THROW ERROR 53002 : ACCOUNT DOES NOT EXIST 
    -- for any other errors throw error : number 50000  message:  error_message()
    BEGIN TRY
        IF NOT EXISTS(SELECT * FROM CLIENTACCOUNT3815 WHERE ACCOUNTID = @PACCOUNTID)
            THROW 53002, 'ACCOUNT DOES NOT EXIST', 1

        SELECT C.*, A.USERID, A.FIRSTNAME, A.SURNAME, A.EMAIL, A.PASSWORD FROM CLIENTACCOUNT3815 AS C
        INNER JOIN AUTHORISEDPERSON3815 AS A
        ON C.ACCOUNTID = A.ACCOUNTID WHERE C.ACCOUNTID = @PACCOUNTID;


    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() = 53002
            THROW
        ELSE
            BEGIN
                DECLARE @ERRORMESSAGE NVARCHAR(MAX)  = ERROR_MESSAGE();
                THROW 50000, @ERRORMESSAGE, 1
            END
    END CATCH


END;


GO
IF OBJECT_ID('CREATE_ORDER') IS NOT NULL
DROP PROCEDURE CREATE_ORDER;
GO


CREATE PROCEDURE CREATE_ORDER  @PSHIPPINGADDRESS NVARCHAR(200), @PUSERID INT AS
BEGIN

    -- insert the specified values into the table ORDER3815
    -- SET THE TOTAL TO 0
    -- RETURN THE NEW ORDERS ORDERID

    -- EXCEPTIONS
    -- USER DOES NOT EXIST : THROW ERROR 55002 : USER DOES NOT EXIST
    -- for any other errors throw error : number 50000  message:  error_message()
    BEGIN TRY
        IF NOT EXISTS(SELECT * FROM AUTHORISEDPERSON3815 WHERE USERID = @PUSERID)
            THROW 55002, 'USER DOES NOT EXIST', 1;

        INSERT INTO ORDER3815(SHIPPINGADDRESS, DATETIMECREATED, DATETIMEDISPATCHED, USERID, TOTAL)
        VALUES (@PSHIPPINGADDRESS, SYSDATETIME(), NULL, @PUSERID, 0);

        RETURN @@IDENTITY;
    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() = 55002
            THROW
        ELSE
            BEGIN
                DECLARE @ERRORMESSAGE NVARCHAR(MAX)  = ERROR_MESSAGE();
                THROW 50000, @ERRORMESSAGE, 1
            END
    END CATCH

END;

GO
IF OBJECT_ID('GET_ORDER_BY_ID') IS NOT NULL
DROP PROCEDURE GET_ORDER_BY_ID;

GO


CREATE PROCEDURE GET_ORDER_BY_ID @PORDERID INT AS
BEGIN
    -- return the specified ORDER INCLUDING ALL RELATED ORDERLINES

    -- EXCEPTIONS
     -- ORDER DOES NOT EXIST THROW ERROR 54002 : ORDER DOES NOT EXIST 
    -- for any other errors throw error : number 50000  message:  error_message()
    BEGIN TRY
        IF NOT EXISTS (SELECT * FROM ORDER3815 WHERE ORDERID = @PORDERID)
            THROW 54002, 'ORDER DOES NOT EXIST', 1

    
        SELECT O.*, L.PRODUCTID, L.QUANTITY, L.DISCOUNT, L.SUBTOTAL FROM ORDER3815 AS O
        INNER JOIN ORDERLINE3815 AS L
        ON O.ORDERID = L.ORDERID WHERE O.ORDERID = @PORDERID;

    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() = 54002
            THROW
        ELSE
            BEGIN
                DECLARE @ERRORMESSAGE NVARCHAR(MAX)  = ERROR_MESSAGE();
                THROW 50000, @ERRORMESSAGE, 1
            END
    END CATCH

END;

GO
IF OBJECT_ID('ADD_PRODUCT_TO_ORDER') IS NOT NULL
DROP PROCEDURE ADD_PRODUCT_TO_ORDER;
GO


CREATE PROCEDURE ADD_PRODUCT_TO_ORDER @PORDERID INT, @PPRODID INT, @PQTY INT, @DISCOUNT DECIMAL AS
BEGIN

    -- THE FOLLOWING MUST BE COMPLETED AS A SINGLE TRANSACTION
    -- CHECK IF THE ORDER HAS ALREADY BEEN FULFILLED (HAS A DATETIMEDISATHCED VALUE)
    -- IF IT HAS BEEN FULFULLILLED GENERATE AN ERROR - SEE EXCEPTIONS SECTION
    -- IF IT HAS NOT BEEN FULLFILLED THEN
    -- IF THE PRODUCT HAS NOT ALREADY BEEN ADDED TO THAT ORDER (I.E. PK IS UNIQUE)
        -- insert the specified values into the table ORDERLINE3815
        -- CALCULATE THE SUBTOTAL VALUE BASED ON THE PRODUCTS SELLPRICE, THE QUANTITY AND THE DISCOUNT
        -- UPDATE THE ORDERS TOTAL - INCREASE IT BY THE VALUE OF THE ORDRLINES SUBTOTAL
    -- ELSE -- the product is aleady in that order 
        -- update the relevant orderline by adding the new quantity to the previous quantity,
        -- RE CALCULATE THE SUBTOTAL VALUE BASED ON THE PRODUCTS SELLPRICE, THE QUANTITY AND THE DISCOUNT
        -- UPDATE THE ORDERS TOTAL - INCREASE IT BY THE VALUE OF THE QTY ADDED TO THE ORDERLINE

    -- EXCEPTIONS
    -- ORDER DOES NOT EXIST THROW ERROR 54002 : ORDER DOES NOT EXIST 
    -- ORDER HAS ALREADY BEEN FULFILLED THROW ERROR 54002 : ORDER HAS ALRADY BEEN FULLFILLED
    -- PRODUCT DOES NOT EXIST THROW ERROR 52002 : PRODUCT DOES NOT EXIST
    -- DISCOUNT IS OUT OF PERMITTED RANGE (SEE TABLE CONSTRAINTS) THROW ERROR 54004 : DISCOUNT OUT OF RANGE
    -- for any other errors throw error : number 50000  message:  error_message()
    BEGIN TRAN
        BEGIN TRY

            IF NOT EXISTS(SELECT PRODUCTID FROM PRODUCT3815 WHERE PRODUCTID = @PPRODID)
                THROW 54005, 'PRODUCT DOES NOT EXIT', 1

            IF NOT EXISTS(SELECT ORDERID FROM ORDER3815 WHERE ORDERID = @PORDERID)
                THROW 54002, 'ORDER DOES NOT EXIST', 1

            IF (SELECT DATETIMEDISPATCHED FROM ORDER3815 WHERE ORDERID = @PORDERID) IS NOT NULL
                THROW 54003, 'ORDER  HAS ALREADY BEEN FULFILED', 1

            IF @DISCOUNT > 0.25 OR @DISCOUNT < 0.00
                THROW 54004, 'DISCOUNT IS OUT OF RANGE', 1

            DECLARE @SUBTOTAL MONEY =  @PQTY * (SELECT SELLPRICE FROM PRODUCT3815 WHERE @PPRODID = PRODUCTID) * (1.00 - @DISCOUNT);
            DECLARE @NEWTOTAL MONEY;

            IF NOT EXISTS(SELECT PRODUCTID FROM ORDERLINE3815 WHERE ORDERID = @PORDERID AND PRODUCTID = @PPRODID)
                BEGIN
                    INSERT INTO ORDERLINE3815 (ORDERID, PRODUCTID, QUANTITY, DISCOUNT, SUBTOTAL)
                    VALUES (@PORDERID, @PPRODID, @PQTY, @DISCOUNT, @SUBTOTAL);
                    SET @NEWTOTAL = (SELECT TOTAL FROM ORDER3815 WHERE @PORDERID = ORDERID) + @SUBTOTAL
                    UPDATE ORDER3815 SET TOTAL = @NEWTOTAL WHERE ORDERID = @PORDERID;
                END;
            ELSE
                BEGIN
                    DECLARE @OLDSUBTOTAL MONEY = (SELECT SUBTOTAL FROM ORDERLINE3815 WHERE @PORDERID = ORDERID AND @PPRODID = PRODUCTID);

                    UPDATE ORDERLINE3815 SET QUANTITY = QUANTITY + @PQTY WHERE ORDERID = @PORDERID AND PRODUCTID = @PPRODID;

                    SET @SUBTOTAL = (SELECT QUANTITY FROM ORDERLINE3815 WHERE ORDERID = @PORDERID AND PRODUCTID = @PPRODID) 
                    * (SELECT SELLPRICE FROM PRODUCT3815 WHERE @PPRODID = PRODUCTID) * (1.00 - @DISCOUNT);

                    UPDATE ORDERLINE3815 SET SUBTOTAL = @SUBTOTAL WHERE PRODUCTID = @PPRODID AND ORDERID = @PORDERID;
                    --adjust the total by the difference between the old subtotal and new
                    SET @NEWTOTAL = ((SELECT TOTAL FROM ORDER3815 WHERE @PORDERID = ORDERID) + (@SUBTOTAL - @OLDSUBTOTAL))
                    UPDATE ORDER3815 SET TOTAL = @NEWTOTAL WHERE ORDERID = @PORDERID;
                END;

        COMMIT TRAN
        END TRY
        BEGIN CATCH
            ROLLBACK TRAN

            IF ERROR_NUMBER() = 53003 OR ERROR_NUMBER() = 53004 OR ERROR_NUMBER() = 53002 OR ERROR_NUMBER() = 53005
                THROW
            ELSE
                BEGIN
                    DECLARE @ERRORMESSAGE NVARCHAR(MAX)  = ERROR_MESSAGE();
                    THROW 50000, @ERRORMESSAGE, 1
                END;
        END CATCH

END;

GO
IF OBJECT_ID('REMOVE_PRODUCT_FROM_ORDER') IS NOT NULL
DROP PROCEDURE REMOVE_PRODUCT_FROM_ORDER;
GO


CREATE PROCEDURE REMOVE_PRODUCT_FROM_ORDER @PORDERID INT, @PPRODID INT AS
BEGIN

    -- THE FOLLOWING MUST BE COMPLETED AS A SINGLE TRANSACTION
    -- CHECK IF THE ORDER HAS ALREADY BEEN FULFILLED (HAS A DATETIMEDISATHCED VALUE)
    -- IF IT HAS BEEN FULFULLILLED GENERATE AN ERROR - SEE EXCEPTIONS SECTION
    -- IF IT HAS NOT BEEN FULLFILLED THEN
    -- UPDATE THE ORDERS TOTAL - DECREASE IT BY THE VALUE OF THE ORDRLINES SUBTOTAL
    -- DELETE THE RELEVANT ROW FROM ORDERLINE3815

    -- EXCEPTIONS
    -- ORDER DOES NOT EXIST THROW ERROR 54002 : ORDER DOES NOT EXIST 
    -- ORDER HAS ALREADY BEEN FULFILLED THROW ERROR 54002 : ORDER HAS ALREADY BEEN FULLFILLED
    -- PRODUCT DOES NOT EXIST THROW ERROR 52002 : PRODUCT DOES NOT EXIST
    -- PRODUCT HAS NOT BEEN ADDED TO ORDER THROW ERROR 54005 : PRODUCT NOT ON ORDER
    -- for any other errors throw error : number 50000  message:  error_message()
    BEGIN TRAN
        BEGIN TRY

            IF NOT EXISTS(SELECT ORDERID FROM ORDER3815 WHERE ORDERID = @PORDERID)
                THROW 54002, 'ORDER DOES NOT EXIST', 1

            IF NOT EXISTS(SELECT PRODUCTID FROM PRODUCT3815 WHERE PRODUCTID = @PPRODID)
                THROW 52002, 'PRODUCT DOES NOT EXIST', 1

            IF (SELECT DATETIMEDISPATCHED FROM ORDER3815 WHERE ORDERID = @PORDERID) IS NOT NULL
                THROW 54003, 'ORDER HAS ALREADY BEEN FULFILLED', 1

            UPDATE ORDER3815 SET TOTAL -= (SELECT SUBTOTAL FROM ORDERLINE3815 WHERE ORDERID = @PORDERID AND PRODUCTID = @PPRODID) WHERE ORDERID = @PORDERID;

            DELETE FROM ORDERLINE3815 WHERE ORDERID = @PORDERID AND PRODUCTID = @PPRODID;


        COMMIT TRAN
        END TRY
        BEGIN CATCH
            ROLLBACK TRAN

            IF ERROR_NUMBER() = 54002 OR ERROR_NUMBER() = 52002 OR ERROR_NUMBER() = 54003
                THROW
            ELSE
                BEGIN
                    DECLARE @ERRORMESSAGE NVARCHAR(MAX)  = ERROR_MESSAGE();
                    THROW 50000, @ERRORMESSAGE, 1
                END
        END CATCH
END;


GO
IF OBJECT_ID('GET_OPEN_ORDERS') IS NOT NULL
DROP PROCEDURE GET_OPEN_ORDERS;
GO


CREATE PROCEDURE GET_OPEN_ORDERS AS
BEGIN
    -- RETURN A CURSOR WHICH REFERENCES ALL CURRENTLY OPEN (NOT FULFILLED) ORDERS

    -- EXCEPTIONS
    -- for any other errors throw error : number 50000  message:  error_message()
    BEGIN TRY

        SELECT * FROM ORDER3815 WHERE DATETIMEDISPATCHED IS NULL;


    END TRY
    BEGIN CATCH
        DECLARE @ERRORMESSAGE NVARCHAR(MAX)  = ERROR_MESSAGE();
        THROW 50000, @ERRORMESSAGE, 1
    END CATCH
END;

GO

IF OBJECT_ID('FULLFILL_ORDER') IS NOT NULL
DROP PROCEDURE FULLFILL_ORDER;

GO


CREATE PROCEDURE FULLFILL_ORDER @PORDERID INT AS
BEGIN

    -- THE FOLLOWING MUST BE COMPLETED AS A SINGLE TRANSACTION

    -- CHECK IF THE ORDER HAS ALREADY BEEN FULFILLED (HAS A DATETIMEDISATHCED VALUE)
    -- IF IT HAS BEEN FULFULLILLED GENERATE AN ERROR - SEE EXCEPTIONS SECTION
    -- IF IT HAS NOT BEEN FULLFILLED THEN

    -- UPDATE THE ORDERS DATETIMEDISPATCHED WITH THE CURRENT DATE TIME
    -- ** TRICKY** FOR EACH PRODUCT IN THE ORDER FIND INVENTORY WHICH HAS SUFFICIENT UNITS OF THE PRODUCT IN STOCK 
            -- AND DECREASE THE INVENTORY BY THE AMOUNT OF THE PRODUCT IN TH ORDER
    -- INCREASE THE RELEVANT CLIENTACCOUNTS BALANCE BY THE TOTAL VALUE OF THE ORDER
    -- INCREASE THE GENERAL LEDGER ACCOUNT ASSETS AMOUNT BY THE TOTAL VALUE OF THE ORDER
    -- ** TRICKY** DECREASE THE GENERAL LEDGER STOCK ASSESTS AMOUNT BY THE WHOLESALE (QTY * BUYPRICE) OF ALL THE PRODUCTS IN THE ORDER

    -- EXCEPTIONS
    -- INSUFFICIENT INVENTORY OF ONE OR MORE PRODUCTS TO FULFILL ORDER THROW ERROR 54006: INSUFFUCIENT INVENTORY TO FULFILL
	-- CLIENT ACCOUNT DOES NOT HAVE SUFFICIENT CREDIT REMAINING TO PAY FOR ORDER THROW ERROR 53005 : INSUFFICIENT CREDIT
    -- ORDER HAS ALREADY BEEN FULFILLED THROW ERROR 54002 : ORDER HAS ALREADY BEEN FULLFILLED
    -- ORDER DOES NOT EXIST THROW ERROR 54002 : ORDER DOES NOT EXIST 
    -- for any other errors throw error : number 50000  message:  error_message()
    BEGIN TRAN
        BEGIN TRY
            IF (SELECT DATETIMEDISPATCHED FROM ORDER3815 WHERE ORDERID = @PORDERID) IS NOT NULL
                THROW 54002, 'ORDER HAS ALREADY BEEN FULFILLED', 1;

            IF NOT EXISTS (SELECT * FROM ORDER3815 WHERE ORDERID = @PORDERID)
                THROW 54002, 'ORDER DOES NOT EXIST', 1

            UPDATE ORDER3815 SET DATETIMEDISPATCHED = SYSDATETIME() WHERE ORDERID = @PORDERID;

            DECLARE @PRODID INT,
            @QTY INT,
            @IQTY INT,
            @LOCID NVARCHAR(8),
            @IFOUND INT = 0;

            DECLARE PCUR CURSOR 
            FOR SELECT PRODUCTID, QUANTITY FROM ORDERLINE3815 WHERE ORDERID = @PORDERID;



            OPEN PCUR;


            FETCH NEXT FROM PCUR INTO @PRODID, @QTY;

            WHILE @@FETCH_STATUS = 0
                BEGIN
                    DECLARE ICUR CURSOR
                    FOR SELECT NUMINSTOCK, LOCATIONID FROM INVENTORY3815 WHERE PRODUCTID = @PRODID;
                    OPEN ICUR;
                    FETCH NEXT FROM ICUR INTO @IQTY, @LOCID;
                    WHILE @IFOUND = 0 AND @@FETCH_STATUS = 0
                        BEGIN
                            
                            IF (@IQTY >= @QTY)
                                BEGIN
                                    UPDATE INVENTORY3815 SET NUMINSTOCK -= @QTY WHERE PRODUCTID = @PRODID AND LOCATIONID = @LOCID;
                                    --we can easily just decrease this each time we have found a product in stock
                                    --by the end of the loop we will have decreased the stock assets by the total buyprice of each product
                                    UPDATE GENERALLEDGER3815 SET AMOUNT -= @QTY * (SELECT BUYPRICE FROM PRODUCT3815 WHERE PRODUCTID = @PRODID) 
                                    WHERE DESCRIPTION = 'ASSETSSTOCK';
                                    SET @IFOUND = 1;
                                END;

                            FETCH NEXT FROM ICUR INTO @IQTY, @LOCID;
                        END;

                        IF @IFOUND = 0
                            THROW 53006, 'INSUFFICIENT INVENTORY TO FULFIL ORDER', 1;


                         CLOSE ICUR;
                         DEALLOCATE ICUR;

                 END;

             BEGIN
                DECLARE @ACCTID INT = (SELECT ACCOUNTID FROM CLIENTACCOUNT3815 WHERE ACCOUNTID 
                = (SELECT ACCOUNTID FROM AUTHORISEDPERSON3815 WHERE USERID 
                = (SELECT USERID FROM ORDER3815 WHERE ORDERID = @PORDERID)));

                DECLARE @NEWBALANCE MONEY = ((SELECT BALANCE FROM CLIENTACCOUNT3815 WHERE ACCOUNTID = @ACCTID) + (SELECT TOTAL FROM ORDER3815 WHERE ORDERID = @PORDERID));
                --PRINT @NEWBALANCE; was used for debugging the loop at one point

                IF (SELECT CREDITLIMIT FROM CLIENTACCOUNT3815 WHERE ACCOUNTID = @ACCTID) < @NEWBALANCE
                    THROW 53005, 'INSUFFICENT CREDIT TO FULFIIL ORDER', 1;

                UPDATE CLIENTACCOUNT3815 SET BALANCE += (SELECT TOTAL FROM ORDER3815 WHERE ORDERID = @PORDERID) WHERE ACCOUNTID = @ACCTID;
                UPDATE GENERALLEDGER3815 SET AMOUNT += (SELECT TOTAL FROM ORDER3815 WHERE ORDERID = @PORDERID) WHERE DESCRIPTION = 'ASSETSACCOUNT';
            END;
            CLOSE PCUR;
            DEALLOCATE PCUR;


        COMMIT TRAN
        END TRY
        BEGIN CATCH
            ROLLBACK TRAN

            IF ERROR_NUMBER() = 53005 OR ERROR_NUMBER() = 54002 OR ERROR_NUMBER() = 53006
                THROW
            ELSE
                BEGIN
                    DECLARE @ERRORMESSAGE NVARCHAR(MAX)  = ERROR_MESSAGE();
                    THROW 50000, @ERRORMESSAGE, 1
                END;
        END CATCH
END;




--###############################################################
-- BELLOW CODE IS AN EXAMPLE ONLY - IT IS NOT PART OF THE TASK
--###############################################################
/*

CREATE PROCEDURE ADD_LOCATION @PCUSTID INT, @PCUSTNAME NVARCHAR(100) AS
BEGIN    
    BEGIN TRY        
        IF @PCUSTID < 1 OR @PCUSTID > 499            
        THROW 50020, 'Customer ID out of range', 1        
        INSERT INTO CUSTOMER (CUSTID, CUSTNAME, SALES_YTD, STATUS)         
        VALUES (@PCUSTID, @PCUSTNAME, 0, 'OK');    
    END TRY    
    BEGIN CATCH        
        if ERROR_NUMBER() = 2627            
            THROW 50010, 'Duplicate customer ID', 1        
        ELSE IF ERROR_NUMBER() = 50020            
            THROW        
        ELSE            
            BEGIN                
                DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();                
                THROW 50000, @ERRORMESSAGE, 1            
            END;    
    END CATCH;
END;

GO

EXEC ADD_CUSTOMER @pcustid = 1, @pcustname = 'testdude2';
EXEC ADD_CUSTOMER @pcustid = 500, @pcustname = 'testdude3';select * from customer;

*/