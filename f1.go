func mainReturn() interface{} {
    bigqueryService, err := getBigqueryService()
    if(err != nil) {
        return "ERROR"
    }
    var useQueryCache bool = true
    billingProjectId := "<var_billingProject>"
    projectId := "<var_projectId>"
    datasetId := "<var_datasetId>"
    tableId := "<var_tableId>"
    var query = "select * from [" + projectId + ":" + datasetId + "." + tableId + "];"
    var request bigquery.QueryRequest = bigquery.QueryRequest{
        Kind: "bigquery#queryRequest",
        Query: query,
        UseQueryCache: &useQueryCache,
        //To turn of legacySql, do this:
        //UseLegacySql:      false,
        //ForceSendFields:   []string{"UseLegacySql"},
    }
    //Run the query, using JobsService
    //https://godoc.org/google.golang.org/api/bigquery/v2#JobsService.Query
    call := bigqueryService.Jobs.Query(billingProjectId, &request)
    //executes the query
    //https://godoc.org/google.golang.org/api/bigquery/v2#JobsQueryCall
    resp, err := call.Do()
    if err != nil {
        return "ERROR"
    }
    var results string = ""
    //loop through the rows, it is a slice of TableRow pointers, []*TableRow
    rows := resp.Rows
    for i :=0 ; i < len(rows); i++ {
        row := rows[i]
        //https://godoc.org/google.golang.org/api/bigquery/v2#TableRow
        //A tableRow is a slice of TableCell pointers []*TableCell
        fields := row.F
        for fi := 0; fi < len(fields); fi++ {
            results = results + xSprintf("Field %v = %v, ", fi, fields[fi].V)
        }
        results = results + "\n"
    }
    return results
}