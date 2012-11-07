class ParamController 
{
    var initYet = 0;
    var AnimateParams = dict();
    function ParamController()
    {
        global.httpController.addRequest("fetchParams", dict(), fetchOver, null);
        global.httpController.addRequest("fetchAnimate", dict(), fetchAni, null);
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
    function fetchAni(rid, rcode, con, param)
    {
        if(rcode != -1)
        {
            con = json_loads(con);
            pureMagicData = dict(con["ani"]);
            magicAnimate = dict(con["sol"]);
        }
    }
}
