Welcome to Data Build Tool(DBT)
-------------------------------------------
Data transformation using POSTGRESQL in DBT 
-------------------------------------------

#       DBT Installation

        1)  Install dbt in local for postgres DB with dbt-postgres adapter.
                
                ``` pip install dbt-postgres ```


##      Create bare GIT repository and clone

        1)  Created a bare repository in Github medbelle_dbt.

                -   Create an account in github and create a new repository, it's quite simple :)
                
        3)  Created a directory medbelle_project in local (I've used Git bash instead of cmd which is user friendly).

                -   Cloned the repository using https which can be found under Code(green color drop down) in medbelle_dbt repository.
                    https://github.com/RevaRaj/medbelle_dbt.git 

                -   Now git repo can be found in local -  medbelle_project/medbelle_dbt/
                    

###     Intialize DBT and change schema

        1)  Run below under the git repository  medbelle_project/medbelle_dbt/

                -    ``` dbt init project_dbt ```

                -   which initializes macros and models for the new project_dbt.

                -   Provided the number for DB selection , in my case 1

        2)  Updated C:\Users\my pc\.dbt\profiles.yml file with default configuration, which can be found here.
                -   https://docs.getdbt.com/dbt-cli/configure-your-profile   

                -   Changed my profile as postgress_conn and other DB configuration in profiles.yml , 
                    the same need to done in medbelle_project/medbelle_dbt/project_dbt/dbt_project.yml

        3) Define the custom schema since default schema is public which is not preferable.

                -   Under project_dbt/macros create a generate_schema_name.sql file .

                -   Coppied the default schema template from below to .sql file
                    https://docs.getdbt.com/docs/building-a-dbt-project/building-models/using-custom-schemas#:~:text=Changing%20the%20way%20dbt%20generates%20a%20schema%20name%E2%80%8B&text=Therefore%2C%20to%20change%20the%20way,then%20define%20your%20own%20logic.

                -   Removed the {{ default_schema }}_ in else part which creates the schema with public if custom schema has been specified
                    then it comes with public_customeschema which is not preferable hence removed that.
                
                -   Added new custom schema(staging1) in dbt_project.yml under models, so my new schema will be staging1
                    where the tables and views will be created for my dbt project.


####    Data Transformations using PostgreSQL and DBT

        1)  First step to check all files are updated correctly, 
       
                -   Run  ``` dbt debug ``` inside the dbt project

                -   If the connection to the DB from DBT is successful and profiles/files are updated properly
                    "All checks passed" message will be dispalyed.

        2)  Now it's time to work with models , which are .sql files. 

                -   Created 4 .sql files for my project under macros/staging .
                    (it was example I've changed it to staging, updated in dbt_project.yml file as well).
                    models:
                        project_dbt:
                            "staging":

        3)  raw_data.sql 
                
                -   Loading raw data from database which was loaded from my python module to DB.

                -   Done transformations on directly accessible data like
                    callguid, callstart time to timestamp, call end reason, participating agent id's.

                -   Taking these data from all level and combining them using union all.

        4)  event_data.sql

                -   Processing with only events data which is again inner level of data.

                -   Events data contains different call stages like Ringing, Connected, CallRecording, Held, Wrap, Delivery Failed
                    and their duration.

                -   Extracted each stage data separately and combined them in single table
                    which will have duration for each stage and their call_guid(can have duplicates).

                -   Which can be viewed in event_data view in staging1 schema.

        5)  final_events_data.sql

                -   Segregating each calls stage and their respective duration as different tables and joining them all 
                    by filling up the values with null, if the specific call stage not present in call.

                -   Finally calculating the total call duration by adding "Ringing", "Connected", "Wrap".

        6)  full_final_data.sql

                -   Uniting all data from raw_data and final_events_data then sorting them by call_guid.

        7)  Below are being used in this project

                -   CTE - Common Table Expressions, {{ref()}} used to refer other models with in one model, 
                    and variables - which are defined in dbt_project.yml and can be used over all models with syntax {{ var() }}.


        Data transformation done!!!!!!!!!!!


#####   Data check and Tests

        1)  Run ``` dbt run ``` command , if all ok "Completed Successfully" message will be displayed.

        2)  Execution can be checked from project_dbt\target\run\project_dbt\models\staging, which is query only.

        2)  In DBeaver check staging1/tables/full_final_data table for results which are annalysis ready.

        3)  Now time for tests,

                -   Updated the schema.yml file under macros with different tests and models.

        4)  Tests are
                    accepted values -   column should have values with in these only
                    unique          -   vaues in column should not be repeasted
                    not_null        -   should not contain null values
                    expression      -   values in that column shoud be >= 0

        5)  Check the tests result under project_dbt\target\compiled\project_dbt\models\staging\schema.yml

        6)  For each stage of development push the code to GitHub.
                -   First check the status, add, commit then push

                
######  Commands used :
           
            DBT     -   
                    ```
                    dbt init    -   Initializes dbt project
                    dbt debug   -   Check for config/dependencies/connection
                    dbt compile -   Used to generate executable files
                    dbt run     -   Runs and produces the required result in DB
                    dbt test    -   Used to run tests
                    ```
            GitHub  -
                    ```
                    git status  -   Checks the status of files that needs to added/commited
                    git add     -   Add the changed files to staging
                    git commit -m "commit message" - Captures the current changes in staging
                    git push    -   Pushes all code into GitHub