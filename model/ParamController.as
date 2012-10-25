class ParamController 
{
    var initYet = 0;
    var AnimateParams = dict();
    function ParamController()
    {
        global.httpController.addRequest("fetchParams", dict(), fetchOver, null);
    }
    function fetchOver(rid, rcode, con, param)
    {
        if(rcode != -1)
        {
            con = json_loads(con);
            AnimateParams = con;
            initYet = 1;
        }
    }
}
