#   -------------------------------------------------------------------------------------------------------------------------------------------
#   Demonstrates accessing shared google sheet using python OAUTH client
#   
#   Load the raw data into postgresql data base created in aws
#   Testing the same with unit test cases
#
#   developed by revathi13887@gmail.com
#   -------------------------------------------------------------------------------------------------------------------------------------------   

import unittest,os,psycopg2
import sqlalchemy
from apiclient.discovery import build
from httplib2 import Http
from oauth2client import file, client, tools
import pandas as pd
from sqlalchemy import  create_engine
from configparser import ConfigParser
from sqlalchemy.exc import SQLAlchemyError



class Trades:

    def getGoogleSheet(self,spreadsheetId,scopes,secretFile,credFile):
        """ Retrieve sheet using OAuth credentials. """
       
        # Scopes enables users to access google drive
        # Stores oauth credentials to access google resources in credFile which is credentials.json
        store = file.Storage(credFile)  
        creds = store.get()
        
        # Checks the user credentials if not there then authentication flow will be initiated 
        # Creating new credentials post successful authentication
        if not creds or creds.invalid:
            flow = client.flow_from_clientsecrets(secretFile, scopes)
            creds = tools.run_flow(flow, store)
        service = build('sheets', 'v4', http=creds.authorize(Http()))

        # Call to the Sheets API and gets the sheets name for the file in google
        sheetMetadata = service.spreadsheets().get(spreadsheetId=spreadsheetId).execute()
        sheets = sheetMetadata.get('sheets', '')
        sheetName = sheets[0]['properties']['title']  # fetch the sheet name

        # Creating an object to get all the values from the sheet
        gsheet = service.spreadsheets().values().get(spreadsheetId=spreadsheetId, range=sheetName).execute()
       
        return sheetName,gsheet
       

     
    def sheetToDataframe(self,gsheet):
        """  Google sheet rawdata to a  DataFrame."""
       
        allRowsValue = []
        # Getting all rows values and calculating total rows count(includes columns name as well)
        googleSheetValues = gsheet.get('values', [])
        numberOfRows = len(googleSheetValues)
        
                        
        # Getting all rows values and adding them to dataframe to load into DB
        allRowsValue = [googleSheetValues[i] for i in range(1,numberOfRows)]
        callsData = pd.DataFrame(allRowsValue,columns=['start_time','duration','channel'])
            
        return callsData           
       


    def loadDataToPostgre(self,callsData,configFile):
        """ Loads the data into Postgresql DB which is created in AWS cloud . """

        # Reads database.ini file to read DB config informations
        config = ConfigParser()
        config.read(configFile)


        host = config['postgresql']['host']             #   postgresql host connection
        user = config['postgresql']['user']             #   user name
        passwd = config['postgresql']['password']       #   password
        database = config['postgresql']['database']     #   database name created in aws
        table=config['postgresql']['table']             #   table name

        # Creating connection engine for postgrsql
        engine = create_engine(f"postgresql+psycopg2://{user}:{passwd}@{host}/{database}")
        connection = engine.raw_connection()
        
        # Passing column names since simple start is a reserved keyword in dbt - cannot be accessed as column name
        dbDtypes = {'start_time':sqlalchemy.TEXT,'duration':sqlalchemy.TEXT,'channel':sqlalchemy.TEXT}

        # Checking connection to DB
        try:
            engine.connect()
        except SQLAlchemyError as err:
            print("error ", err.__cause__)
        
        # Table created from here has some dependent objects from dbt models
        # Hence table has to be dropped explicitly   
        engine.execute("DROP TABLE IF EXISTS {} CASCADE".format(table))
        
        # Loading all data into postgresql DB
        callsData.to_sql(table, engine,if_exists='replace' ,index=False,dtype=dbDtypes)
       
        connection.commit()



# Unit Test case for functions       

class TestCases(unittest.TestCase):

    def test_getGoogleSheet(self):
        """ Unit Test cases for google sheet. """

        # Values needed for accessing googlesheets
        scopes = 'https://www.googleapis.com/auth/spreadsheets.readonly'    #   provides authorization access
        SPREADSHEET_ID = "1jsHbDNyv92_EbIHK5sLkMcuNidiQpJUkUKQ1KAZeHj4"     #   google sheet id found in the link of googlesheet
        secretFile = "client_secret.json"                                   #   stores client id and secret key
        credentialsFile = "credentials.json"                                #   have all keys like access, secret keys and token uri,expiry
       

        # This variable needs to be used outside of this testcase hence declaration will be different
        TestCases.configFile = "database.ini" 

        # Client secret and database config files existence check
        secretFileExist = os.path.exists(secretFile)
        databseFileExist = os.path.exists(TestCases.configFile)

        # Unit test for file existance 
        self.assertEqual(secretFileExist, True, " Secret File client_seret.json does not exist")
        self.assertEqual(databseFileExist , True, " Databse configuration file database.ini does not exist")

        # Sheetname - Calls and gheet - values of all rows
        sheetName,TestCases.gsheet = Trades().getGoogleSheet(SPREADSHEET_ID,scopes,secretFile,credentialsFile)
        gsheetValues = len(TestCases.gsheet.get('values', []))

        # Unit test for google sheetname and values        
        self.assertEqual(sheetName, "Calls", " Google sheet does not have a sheet name called Calls")
        self.assertEqual(not gsheetValues, 0, " Problem with extracting data from Google sheets, no data has been extracted" )

    

    def test_sheetToDataframe(self):
        """ Test case for data to postgresql db ."""
        
        TestCases.callsData = Trades().sheetToDataframe(TestCases.gsheet)
        Trades().loadDataToPostgre(TestCases.callsData,TestCases.configFile)

        # Unit test for returned data
        self.assertEqual(TestCases.callsData.empty, False, "No data have been copied from Googlesheets to dataframe")
        
 

# Calling unittest 
if __name__ == '__main__':
    unittest.main()