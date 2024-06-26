import unittest
from GetCount import TableClient, TableServiceClient

class TestTableCreation(unittest.TestCase):
    def setUp(self):
        self.connection_string = "DefaultEndpointsProtocol=https;AccountName=cosmoscrctopcug;AccountKey=<key>;TableEndpoint=https://cosmoscrctopcug.table.cosmos.azure.com:443/;"
        self.table_name = "cloudres"
        self.entity = {
            "PartitionKey" : "cloud",
            "RowKey" : "id",
            "count": 0 
        }
        self.user_agent= "azsdk-python-data-tables/12.4.2 Python/3.9.16 (Linux-5.10.102.2-microsoft-standard-x86_64-with-glibc2.31)"
        self.my_filter = "PartitionKey eq 'cloud'"
    def test_query_table(self):
        with TableServiceClient.from_connection_string(self.connection_string) as tsc:
            list_tables = tsc.list_tables()
            for table in list_tables:
                # print("----- Listing tables:{}".format(table.name))
                assert table.name == self.table_name
                print("-----", table.name, "and", self.table_name, "are equal ✅" )
            
    def test_create_entity(self):
        with TableClient.from_connection_string(self.connection_string, self.table_name) as tc:            
            values = tc.query_entities(query_filter=self.my_filter)
            for val in values:
                val1=val['count']
                assert type(val1) is int                
                print("-----", val1, "is integer ✅")
                
        
    def test_update_entity(self):
        with TableClient.from_connection_string(self.connection_string, self.table_name) as tc:
            entity = {
                "PartitionKey" : "cloud",
                "RowKey" : "id",
                "count": 0 
            }
            my_filter = "PartitionKey eq 'cloud'"             
            entities = tc.query_entities(my_filter)
            currentVisitorsCount = (list(entities)[0]['count'])
            updatedVisitorsCount = currentVisitorsCount + 1
            updated = tc.get_entity(partition_key=entity["PartitionKey"], row_key=entity["RowKey"])
            updated["count"]=updatedVisitorsCount
            # print(currentVisitorsCount, updatedVisitorsCount)
            assert currentVisitorsCount < updatedVisitorsCount
            print("-----", updatedVisitorsCount, "is greater than", currentVisitorsCount, "✅")            
        
if __name__ == "__main__":
    unittest.main()