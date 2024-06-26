import json
import azure.functions as func
from azure.data.tables import TableServiceClient
from azure.data.tables import TableClient
from azure.data.tables import UpdateMode
import logging
from azure.core.exceptions import HttpResponseError
from azure.core.exceptions import ResourceExistsError

class CosmosOperations(object):     
                       
    def __init__(self):        
        self.connection_string = "DefaultEndpointsProtocol=https;AccountName=cosmoscrctopcug;AccountKey=<key>;TableEndpoint=https://cosmoscrctopcug.table.cosmos.azure.com:443/;"
        self.table_name = "cloudres"
        self.entity = {
            "PartitionKey" : "cloud",
            "RowKey" : "id",
            "count": 0 
        }
                
        self.user_agent= "azsdk-python-data-tables/12.4.2 Python/3.9.16 (Linux-5.10.102.2-microsoft-standard-x86_64-with-glibc2.31)"
        self.my_filter = "PartitionKey eq 'cloud'"
        
        def create_table(self):
            # table_service_client = TableServiceClient.from_connection_string(conn_str=connectionString)
            with TableServiceClient.from_connection_string(self.connection_string) as tsc:
                try:
                    table_name = "cloudres"
                    tsc = tsc.create_table(table_name)
                    print("Created table {}!".format(table_name))
                except ResourceExistsError:
                    print("Table with name {} already exists. Skipping...".format(table_name))                    
                    
               
    def create_entity(self):        
        with TableClient.from_connection_string(self.connection_string, self.table_name, self.user_agent) as tc:            
            try:
                resp = tc.create_entity(entity=self.entity)
                my_filter = "PartitionKey eq 'cloud'" 
                entities = tc.query_entities(my_filter)
                for entity in entities:
                    for key in entity.keys():
                        print("Key: {}, Value: {}".format(key, entity[key]))                
                print("Created entity: {}".format(resp))
            except HttpResponseError:
                print("Entity already exists. Skipping...")

                
    def update_entity(self):
        
        with TableClient.from_connection_string(self.connection_string, self.table_name) as tc:
            entity = {
                "PartitionKey" : "cloud",
                "RowKey" : "id",
                "count": 0 
            }            
            my_filter = "PartitionKey eq 'cloud'"             
            entities = tc.query_entities(my_filter)
            currentVisitorsCount = (list(entities)[0]['count'])
            print(type(currentVisitorsCount))
            updatedVisitorsCount = currentVisitorsCount + 1
            print (currentVisitorsCount)
            updated = tc.get_entity(partition_key=entity["PartitionKey"], row_key=entity["RowKey"])
            updated["count"] = updatedVisitorsCount
            tc.update_entity(mode=UpdateMode.REPLACE, entity=updated)

def main(req: func.HttpRequest, visitorCount) -> func.HttpResponse:
    try:
        operation = CosmosOperations()
        operation.update_entity()
        response = json.loads(visitorCount)
        count = response[0]['count']

        code = req.params.get('code')
        if not code:
            raise ValueError("code parameter is missing from the request URL")

        if req.method != 'GET':
            raise ValueError("Method Not Allowed")

        return func.HttpResponse(f"{count}", status_code=200)

    except ValueError as e:
        return func.HttpResponse(str(e), status_code=400)

    except Exception as e:
        logging.error(str(e))
        return func.HttpResponse("Internal Server Error", status_code=500)

if __name__ == "__main__":
    main()

