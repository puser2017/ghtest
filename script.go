func mainReturn() interface{} {
    projectId := "<var_projectId>"
    datasetId := "<var_datasetId>"
    tableId := "<var_tableId>"
    bigqueryService, err := getBigqueryService()
    if(err != nil) {
        return "ERROR"
    }
    call := bigqueryService.Tabledata.List(projectId, datasetId, tableId)
        call.MaxResults(10)
    list, _ := call.Do()
    buf, _ := json.Marshal(list)
    return xSprintln(string(buf))
}