CREATE DATABASE IF NOT EXISTS SF_CORTEX_MFG_DB;
CREATE SCHEMA IF NOT EXISTS PROCUREMENT_DEMO;
CREATE OR REPLACE FILE FORMAT CSV_FORMAT
        TYPE = 'CSV'
        FIELD_DELIMITER = ','
        RECORD_DELIMITER = '\n'
        SKIP_HEADER = 1
        FIELD_OPTIONALLY_ENCLOSED_BY = '"'
        TRIM_SPACE = TRUE
        ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE
        ESCAPE = 'NONE'
        ESCAPE_UNENCLOSED_FIELD = '\134'
        DATE_FORMAT = 'YYYY-MM-DD'
        TIMESTAMP_FORMAT = 'YYYY-MM-DD HH24:MI:SS'
        NULL_IF = ('NULL', 'null', '', 'N/A', 'n/a');

CREATE OR REPLACE STAGE INTERNAL_DATA_STAGE
        FILE_FORMAT = CSV_FORMAT
        COMMENT = 'Internal stage for copied demo data files'
        DIRECTORY = ( ENABLE = TRUE)
        ENCRYPTION = (   TYPE = 'SNOWFLAKE_SSE');

COPY FILES
    INTO @INTERNAL_DATA_STAGE/data/
    FROM @ADMINDB.PUBLIC.SF_BUILD_2025_REPO/branches/main/data/;

-----------------------
-- Tables Creation and Data Load

create or replace TABLE COMMODITY_PRICE_FERTILIZER (
	COMMODITIES VARCHAR(16777216),
	UNITS VARCHAR(16777216),
	"Actual_Market_Prices_for_Non-Fuel_and_Fuel_Commodities_2021-2025" NUMBER(38,1),
	"2022" NUMBER(38,1),
	"2023" NUMBER(38,1),
	"2024" NUMBER(38,1),
	"2025Q1" NUMBER(38,1),
	"2025Q2" NUMBER(38,1),
	"2025Q3" VARCHAR(16777216)
);

copy into COMMODITY_PRICE_FERTILIZER
from '@internal_data_stage/data/Commodity price - Fertilizer (1).csv'
file_format = (format_name = 'csv_format')
on_error = continue;


create or replace TABLE GLOBAL_CERTIFICATION (
	GLOBAL_CERTIFICATION_ID VARCHAR(16777216),
	GLOBAL_CERTIFICATION_NAME VARCHAR(16777216)
);

copy into GLOBAL_CERTIFICATION from @internal_data_stage/data/GLOBAL_CERTIFICATION.csv 
file_format = csv_format 
on_error = continue;


create or replace TABLE GLOBAL_MATERIAL (
	GLOBAL_MATERIAL_ID VARCHAR(16777216),
	GLOBAL_MATERIAL_NAME VARCHAR(16777216),
	GLOBAL_MATERIAL_TYPE VARCHAR(16777216)
);

copy into GLOBAL_MATERIAL from @internal_data_stage/data/GLOBAL_MATERIAL.csv 
file_format = csv_format 
on_error = continue;

create or replace TABLE GLOBAL_SUPPLIER (
	GLOBAL_SUPPLIER_ID VARCHAR(16777216),
	GLOBAL_SUPPLIER_NAME VARCHAR(16777216),
	GLOBAL_SUPPLIER_COUNTRY VARCHAR(16777216),
	GLOBAL_SUPPLIER_ADDRESS VARCHAR(16777216),
	GLOBAL_SUPPLIER_PHONENUMBER VARCHAR(16777216),
	GLOBAL_SUPPLIER_WEBSITE VARCHAR(16777216),
	GLOBAL_SUPPLIER_EMAIL VARCHAR(16777216),
	LEAD_TIME NUMBER(38,0),
	WHETHER_EXISITING_VENDOR_FOR_CAPCHEM BOOLEAN,
	GLOBAL_RELIABILITY_SCORE NUMBER(38,0),
	GLOBAL_TRADE_RESTRICTIONS BOOLEAN,
	GLOBAL_SUPPLIER_CAPACITY NUMBER(38,0)
);

copy into GLOBAL_SUPPLIER from @internal_data_stage/data/GLOBAL_SUPPLIER.csv 
file_format = csv_format 
on_error = continue;

create or replace TABLE MATERIAL_SUPPLIER (
	GLOBAL_MATERIAL_ID VARCHAR(16777216),
	GLOBAL_MATERIAL_NAME VARCHAR(16777216),
	GLOBAL_MATERIAL_TYPE VARCHAR(16777216),
	GLOBAL_SUPPLIER_ID VARCHAR(16777216),
	GLOBAL_SUPPLIER_NAME VARCHAR(16777216)
);

copy into MATERIAL_SUPPLIER from @internal_data_stage/data/MATERIAL_SUPPLIER.csv 
file_format = csv_format 
on_error = continue;

create or replace TABLE PRICE_SPECIFICATIONS (
	FERTILIZERS VARCHAR(16777216),
	"World Export Weights (2014-2026)" NUMBER(38,1),
	PRICE_SPECS VARCHAR(16777216),
	UNIT VARCHAR(16777216)
);

copy into PRICE_SPECIFICATIONS from @internal_data_stage/data/Price_Specifications_New.csv 
file_format = csv_format 
on_error = continue;

create or replace TABLE PURCHASE_ORDERS (
	PURCHASE_ORDER_NUMBER VARCHAR(16777216),
	CAPCHEM_VENDOR_ID VARCHAR(16777216),
	CAPCHEM_VENDOR_NAME VARCHAR(16777216),
	CAPCHEM_RAW_MATERIAL_ID VARCHAR(16777216),
	CAPCHEM_RAW_MATERIAL_NAME VARCHAR(16777216),
	CAPCHEM_RAW_MATERIAL_CATEGORY VARCHAR(16777216),
	QUANTITY NUMBER(38,2),
	UNIT_PRICE_OF_RM NUMBER(38,0),
	TOTAL_AMOUNT NUMBER(38,0),
	PURCHASE_ORDER_DATE VARCHAR(16777216)
);

copy into PURCHASE_ORDERS from @internal_data_stage/data/CapChem_Purchase_Orders.csv 
file_format = csv_format 
on_error = continue;

create or replace TABLE RAW_MATERIAL (
	CAPCHEM_RAW_MATERIAL_ID VARCHAR(16777216),
	GLOBAL_MATERIAL_ID VARCHAR(16777216),
	CAPCHEM_RAW_MATERIAL_NAME VARCHAR(16777216),
	CAPCHEM_RAW_MATERIAL_CATEGORY VARCHAR(16777216)
);

copy into RAW_MATERIAL from @internal_data_stage/data/RAW_MATERIAL.csv 
file_format = csv_format 
on_error = continue;


create or replace TABLE SUPPLIER_CERTIFICATIONS (
	GLOBAL_SUPPLIER_ID VARCHAR(16777216),
	GLOBAL_CERTIFICATION_ID VARCHAR(16777216),
	GLOBAL_SUPPLIER_NAME VARCHAR(16777216),
	GLOBAL_CERTIFICATION_NAME VARCHAR(16777216)
);

copy into SUPPLIER_CERTIFICATIONS from @internal_data_stage/data/SUPPLIER_CERTIFICATIONS.csv 
file_format = csv_format 
on_error = continue;

create or replace TABLE SUPPLIER_CONTRACTS (
	GLOBAL_SUPPLIER_ID VARCHAR(16777216),
	GLOBAL_SUPPLIER_NAME VARCHAR(16777216),
	GLOBAL_SUPPLIER_COUNTRY VARCHAR(16777216),
	GLOBAL_SUPPLIER_ADDRESS VARCHAR(16777216),
	GLOBAL_SUPPLIER_EMAIL VARCHAR(16777216),
	GLOBAL_SUPPLIER_PHONENUMBER NUMBER(38,0),
	GLOBAL_SUPPLIER_WEBSITE VARCHAR(16777216),
	GLOBAL_TRADE_RESTRICTIONS BOOLEAN,
	WHETHER_EXISITING_VENDOR_FOR_CAPCHEM BOOLEAN,
	GLOBAL_RELIABILITY_SCORE NUMBER(38,0),
	LEAD_TIME NUMBER(38,0),
	CONTRACT_ID VARCHAR(16777216),
	START_DATE VARCHAR(16777216),
	END_DATE VARCHAR(16777216),
	CONTRACT_VALUE NUMBER(38,0),
	PAYMENT_TERMS VARCHAR(16777216),
	STATUS VARCHAR(16777216),
	DELIVERY_TERMS VARCHAR(16777216),
	DISCOUNT_TERMS VARCHAR(16777216),
	PENALTY_CLAUSES VARCHAR(16777216),
	CURRENCY VARCHAR(16777216),
	RENEWAL_TERMS VARCHAR(16777216)
);

copy into SUPPLIER_CONTRACTS from @internal_data_stage/data/Final_Supplier_Contracts.csv 
file_format = csv_format 
on_error = continue;

create or replace TABLE VENDOR (
	CAPCHEM_VENDOR_ID VARCHAR(16777216),
	GLOBAL_SUPPLIER_ID VARCHAR(16777216),
	CAPCHEM_VENDOR_NAME VARCHAR(16777216)
);

copy into VENDOR from @internal_data_stage/data/VENDOR.csv 
file_format = csv_format 
on_error = continue;

create or replace TABLE VENDOR_PERFORM (
	CAPCHEM_VENDOR_ID VARCHAR(16777216),
	CAPCHEM_VENDOR_NAME VARCHAR(16777216),
	ON_TIME_PERFORMANCE_LAST_5_YEARS NUMBER(38,0),
	IN_FULL_PERFOMANCE_LAST_5_YEARS NUMBER(38,0),
	QUALITY_SCORE_LAST_5_YEARS NUMBER(38,0),
	PRICING_PERFORMANCE_PERCENTAGE_TIMES_LOWEST_COST_AMONG_VENDORS_IN_LAST_5_YEARS NUMBER(38,0),
	PAYMENT_TERMS_IN_DAYS_FROM_INVOCIE NUMBER(38,0),
	CONTINGENCY_SUPPORT BOOLEAN,
	COMPOSITE_SUPPLIER_PERFORMANCE_SCORE NUMBER(38,0)
);

copy into VENDOR_PERFORM from @internal_data_stage/data/VENDOR_PERFORM.csv 
file_format = csv_format 
on_error = continue;




CREATE OR REPLACE PROCEDURE SF_CORTEX_MFG_DB.PROCUREMENT_DEMO.GENERATE_STREAMLIT_APP("USER_INPUT" VARCHAR)
RETURNS VARCHAR
LANGUAGE PYTHON
RUNTIME_VERSION = '3.11'
PACKAGES = ('snowflake-snowpark-python')
HANDLER = 'generate_app'
EXECUTE AS OWNER
AS '
def generate_app(session, user_input):
    import re
    import tempfile
    import os

# 🧠 Step 1: Preprocess the user input to handle nested WITH
    if user_input and user_input.strip().upper().startswith("WITH "):
        user_input = re.sub(
        r"(?i)^WITHs+",
        "-- WITH removed for SI context\\nSELECT * FROM (",
        user_input
        )
        user_input += ")"
    
    # Build the prompt for AI_COMPLETE
    prompt = f"""Generate a Streamlit in Snowflake code that has an existing session. 
- Output should only contain the code and nothing else. 

- Total number of characters in the entire python code should be less than 32000 chars

- create session object like this: 
from snowflake.snowpark.context import get_active_session
session = get_active_session()

- Never CREATE, DROP , TRUNCATE OR ALTER  tables. You are only allowed to use SQL SELECT statements.

- Use only native Streamlit visualizations and no html formatting

- ignore & remove VERTICAL=''Retail'' filter in all source SQL queries.

- Use ONLY SQL queries provided in the input as the data source for all dataframes placing them into CTE to generate new ones. You can remove LIMIT or modify WHERE clauses to remove or modify filters. Example:

WITH cte AS (
    SELECT original_query_from_prompt modified 
    WHERE x=1 --this portion can be removed or modified
    LIMIT 5   -- this needs to be removed
)
SELECT *
FROM cte as new_query for dataframe;


- DO NOT use any table or column other than what was listed in the source queries below. 

- all table column names should be in UPPER CASE

- Include filters for users such as for dates ranges & all dimensions discussed within the user conversation to make it more interactive. Queries used for user selections using distinct values should not use any filters for VERTICAL = RETAIL.

- Include dropdown whenever there is a need to filter on suppliers,vendors and all. 

- Can have up to 2 tabs. Each tab can have up maximum 4 visualizatons (chart & kpis)

- Use only native Streamlit visualizations and no html formatting. 

- Never use st.scatter_chart(), st.pyplot(), st.altair_chart(), or st.vega_lite_chart. 
  Snowflake Streamlit does NOT support scatter plots or external visualization libraries.
  Only use these:
  - st.bar_chart
  - st.line_chart
  - st.area_chart
  - st.dataframe
  - st.table
  - st.metric

- If the user asks for a scatter plot, replace it with a bar chart or line chart.


- When generating code that involves loading data from a SQL source (like Snowflake/Snowpark)
into a Pandas DataFrame for use in a visualization library (like Streamlit), you must explicitly ensure all date and timestamp columns are correctly cast as Pandas datetime objects.

Specific Steps:

Identify all columns derived from SQL date/timestamp functions (e.g., DATE, MONTH, SALE_DATE).

Immediately after calling the .to_pandas() method to load the data into the DataFrame df, insert code to apply pd.to_datetime() to these column

- App should perform the following:
<input>
{user_input}
</input>"""
    
    # Escape single quotes for SQL
    escaped_prompt = prompt.replace("''", "''''")
    
    # Execute AI_COMPLETE query
    # query = f"SELECT AI_COMPLETE(''claude-4-sonnet'', ''{escaped_prompt}'')::string as result"

    # Build model_parameters as a separate string to avoid f-string escaping issues
    model_params = "{''temperature'': 0, ''max_tokens'': 8192}"
    
    # Execute AI_COMPLETE query with model parameters
    query = f"""SELECT AI_COMPLETE(model => ''claude-4-sonnet'',
                                prompt => ''{escaped_prompt}'',
                                model_parameters => {model_params}
                                )::string as result"""
    
    result = session.sql(query).collect()
    
    if result and len(result) > 0:
        code_response = result[0][''RESULT'']
        
        # Strip markdown code block markers using regex
        cleaned_code = code_response.strip()
        
        # Remove ```python, ```, or ```py markers at start
        cleaned_code = re.sub(r''^```(?:python|py)?\\s*\\n?'', '''', cleaned_code)
        # Remove ``` at end
        cleaned_code = re.sub(r''\\n?```\\s*$'', '''', cleaned_code)
        
        # Remove any leading/trailing whitespace
        cleaned_code = cleaned_code.strip()
        
        # Prepare environment.yml content
        environment_yml_content = """# Snowflake environment file for Streamlit in Snowflake (SiS)
# This file specifies Python package dependencies for your Streamlit app

name: streamlit_app_env
channels:
  - snowflake

dependencies:
  - plotly=6.3.0
"""
        
        # Write files to temporary directory
        temp_dir = tempfile.gettempdir()
        temp_py_file = os.path.join(temp_dir, ''test.py'')
        temp_yml_file = os.path.join(temp_dir, ''environment.yml'')
        
        try:
            # Write the Python code to temporary file
            with open(temp_py_file, ''w'') as f:
                f.write(cleaned_code)
            
            # Write the environment.yml to temporary file
            with open(temp_yml_file, ''w'') as f:
                f.write(environment_yml_content)
            
            # Upload both files to Snowflake stage
            stage_path = ''@SF_CORTEX_MFG_DB.PROCUREMENT_DEMO.STREAMLIT_APPS''
            
            # Upload Python file
            session.file.put(
                temp_py_file,
                stage_path,
                auto_compress=False,
                overwrite=True
            )
            
            # Upload environment.yml file
            session.file.put(
                temp_yml_file,
                stage_path,
                auto_compress=False,
                overwrite=True
            )
            
            # Clean up temporary files
            os.remove(temp_py_file)
            os.remove(temp_yml_file)
            
            # Create Streamlit app
            app_name = ''PROCUREMENT_APP''
            warehouse = ''compute_wh''
            
            create_streamlit_sql = f"""
            CREATE OR REPLACE STREAMLIT SF_CORTEX_MFG_DB.PROCUREMENT_DEMO.{app_name}
                FROM @SF_CORTEX_MFG_DB.PROCUREMENT_DEMO.STREAMLIT_APPS
                MAIN_FILE = ''test.py''
                QUERY_WAREHOUSE = {warehouse}
            """
            
            try:
                session.sql(create_streamlit_sql).collect()
                
                # Get account information for URL
                account_info = session.sql("SELECT CURRENT_ACCOUNT_NAME() AS account, CURRENT_ORGANIZATION_NAME() AS org").collect()
                account_name = account_info[0][''ACCOUNT'']
                org_name = account_info[0][''ORG'']
                
                # Construct app URL
                app_url = f"https://app.snowflake.com/{org_name}/{account_name}/#/streamlit-apps/SF_CORTEX_MFG_DB.PROCUREMENT_DEMO.{app_name} "
                
                # Return only the URL if successful
                return app_url
                
            except Exception as create_error:
                return f"""✅ Files saved to {stage_path}/
   - test.py
   - environment.yml
⚠️  Warning: Could not auto-create Streamlit app: {str(create_error)}

To create manually, run:
CREATE OR REPLACE STREAMLIT SF_CORTEX_MFG_DB.PROCUREMENT_DEMO.{app_name}
    FROM @SF_CORTEX_MFG_DB.PROCUREMENT_DEMO.STREAMLIT_APPS
    MAIN_FILE = ''test.py''
    QUERY_WAREHOUSE = {warehouse};

--- Generated Code ---
{cleaned_code}"""
            
        except Exception as e:
            # Clean up temp files if they exist
            if os.path.exists(temp_py_file):
                os.remove(temp_py_file)
            if os.path.exists(temp_yml_file):
                os.remove(temp_yml_file)
            return f"❌ Error saving to stage: {str(e)}\\n\\n--- Generated Code ---\\n{cleaned_code}"
    else:
        return "Error: No response from AI_COMPLETE"
';
