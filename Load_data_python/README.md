Welcome to the case study! 
------------------------------------------------
Google Sheet data to Postgrsql DataBase (AWS-RDS)
------------------------------------------------

-------------------------------------------------
Requirements and Assessment about the case  study
-------------------------------------------------

        Requirements    :
                1)      GitHub repository
                2)      AWS hosted PostgresDB
                3)      Python script for loading raw data from google sheet to DB
                4)      Data transformation using Postgresql in DBT
                5)      Table shoud contain below:
                                a. call guid
                                b. timestamp of call start
                                c. participating agent id
                                d. total duration
                                e. duration of different stages in the call (Ringing, Connected, Wrap)
                                f. call end reason

        Assessment      :
                1)      Provided data is for call center(Call Detailed Report).
                2)      In the calls not all the participants are agents.
                3)      Agents are participating in mutiple calls as well.
                4)      Different call handling stages are provided for each call.
                5)      Call disconnect reason for calls are among Released, Unreachable and no reason(null).
                6)      Some of the calls are not succeeded.
                7)      Call transformation is happening for few calls.
                8)      Not all the connected calls are being recorded.
                9)      Overall 65 agents are being involved in call handling.
                10)     4+ years of data has been given.


Software Requirements:
---------------------
        Python
        AWS-RDS
        PostgreSQL
        GitHub
        DBEaver/Any DB tool
        DBT
        Google Oauth credentials


#       Google Developer console - OAUTH client secret creation

        1)  Created a project in google developer console. 
                
                -   Use gmail id to login -> https://console.developers.google.com. 

        2)  In library(under APIs and Services) , search for  google sheets api and google drive api and enable it.

        3)  OAuth consent screen pane need to provide below details

                -   App name - any name
                    User support email - Gmail
                    developer contact information(email address) - Gmail
                    save and continue to next screen

                -   Click ADD OR REMOVE SCOPES
                    add Google Drive API and Google Sheets API , which was added already to the project
                    need to be added here.l

                -   ADD USERS - Gmail

        4)  Credentials pane 

                -   CREATE CREDENTIALS -> OAUTH Client id
                    Appication type - web application

                -   Add redirect uri - http://localhost:8080/ , then create user

                -   Credentials will be creatd under OAuth 2.0 Client IDs download and save them.

                -   Name it as client_secret.json in the same directory as of  .py module for google sheet

        Credentials created to connect with googlesheet!!!!!!!!!!


##      Authentication using OAUTH client and credentials

        1)  Created google_sheet_to_postgre_database.py module with function getGoogleSheet.

                -   Update module with scope(Google Sheets API) - added in Oauth consent screen 

                -   Shared google spread sheet id - "1jsHbDNyv92_EbIHK5sLkMcuNidiQpJUkUKQ1KAZeHj4"  found in below link
                    https://docs.google.com/spreadsheets/d/1jsHbDNyv92_EbIHK5sLkMcuNidiQpJUkUKQ1KAZeHj4/edit#gid=0

                -   First execution will navigate to google authentication click with gmail id that was used in google developer console
                        CONNECTED !!!!!!!!!!!!!!

                -   Post successful authentication credentials.json file get created in the same level of google_sheet_to_postgre_database.py

        2)  Luckily we dont need to do any edit on secret/credentials file :) 

        3)  Install all modules mentioned in python module , if not done already using ``` pip install module/package name ```

        4)  Simple pandas dataframe used here to store raw data from Google sheet.


###     Create POSTGRESQL DB in AWS-RDS

        1)  Create an account in AWS cloud console 

        2)  Choose RDS(Managed Relational Database) service - Click Create Database and proceed with beow options.

                -   Standard create , Engine -  Postgresql , Free Tier

                -   DB instance identifier - database-2(user defined) 

                -   Credentials -   UserName(user defined)
                                -   Master password(user defined)
                                -   Confirm password(user defined)   

                -   Connectivity - Make Pubic access "Yes" , Unless DB will not accessible from local

                -   VPC Security group -  create new

                -   Database Authentication - password authentication

                -   Additional Configuration - Initial Database Name - medbelle(user defined) ,
                    leave everything else with default values and Click Create Database

                ** Please make note of all above credentials and database name to connect later

        3)  In the Databases list status of database-2 should be changed to available. 

                -   Once instance is ready make a note of Endpoint under Connectivity & Security, in the same tab
                    VPC Secutiry Group also can be found.
                    EndPoint - "database-2.cnlhrwdfjgkj.ap-south-1.rds.amazonaws.com"

                -   Click the security group link - Postgres (sg-01a0aa4377742a3bb)

                -   Edit the In bound rules of the above security group to allow traffic from public/specific IP                
                    Add one more rule with the existing one and save
                        Type        -   PostgreSQL
                        Protocol    -   TCP
                        Port        -   5432(default port for DB) 
                        Source      -   Custom - 0.0.0.0/0 (Allow all IP, we can add only our IP also)

                -   All set with DB


####    Connect to POSTGRESQL from python and load Data

        1)  Using create_engine module from sqlalchamy , created a engine with postgresql connection string.

                -   Connection configuration informations are avialable in database.ini

        2)  Post successful connection with database using to_sql function in pandas dataframe loading data into PostgreSQL DB.

        3)  Unit test cases have been used to do the unit test.


        4)  Run ```  python3 google_sheet_to_postgre_database.py ``` 


#####   DBeaver tool - Check the loaded data

        1)  Install DBeaver or any other DB tool to connect from local and check the data in DB.

        2)  Create a new connection with PostgreSQL DB from local using

                -  Endpoint is Host, Database name, username, password, port 

        3)  Test the connection , once it's connected check the loaded data under the public schema/tables/



