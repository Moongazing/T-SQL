DECLARE @URL AS VARCHAR(8000)
SET @URL = 'https://www.tcmb.gov.tr/kurlar/today.xml'
DECLARE @OBJ AS INT
DECLARE @RESULT AS INT

EXEC @RESULT = SP_OACREATE 'MSXML2.XMLHttp' , @OBJ OUT
EXEC @RESULT =  SP_OAMethod  @OBJ , 'open' , NULL , 'GET' ,@URL ,false


EXEC @RESULT =  SP_OAMethod @OBJ , SEND , NULL, ' '


CREATE TABLE #XML(STRXML VARCHAR(MAX))
INSERT INTO #XML(STRXML) EXEC @RESULT =  SP_OAGetProperty @OBJ , 'responseXML.xml' 

DECLARE @XML AS XML
SELECT @XML = STRXML FROM #XML
SELECT @XML

DECLARE @HDOC AS INT 
EXEC SP_XML_PREPAREDOCUMENT @HDOC OUTPUT, @XML



CREATE  TABLE CURRENCY (DATE_ DATE, UNIT VARCHAR(50), NAME_ VARCHAR(50), CURRENCYNAME VARCHAR(100), FOREXBUYING FLOAT , 
FOREXSELLING FLOAT, BANKNOTEBUYING FLOAT , BANKNOTESELLING FLOAT)


INSERT INTO CURRENCY (DATE_,UNIT,NAME_,CURRENCYNAME,FOREXBUYING,FOREXSELLING,BANKNOTEBUYING,BANKNOTESELLING)
SELECT CONVERT(DATE,GETDATE()) AS DATE  ,* FROM OPENXML(@HDOC,'Tarih_Date/Currency')
WITH (
Unit varchar(50) 'Unit',
Isim varchar(100) 'Isim',
CurrencyName varchar (100) 'CurrencyName',
ForexBuying float 'ForexBuying',
ForexSelling float 'ForexSelling',
BanknoteBuying float 'BanknoteBuying',
BanknoteSelling float  'BanknoteSelling'
)










--Open sp command
--sp_configure 'show advanced options' ,1
--sp_configure 'Ole Automation Procedures' ,1
--reconfigure with override




