class WarHttpController
{
    var map;
    var requestList = [];
    var baseUrl;
    var cursor = null;
    var gameStart = 0;
    var myColor = MYCOLOR;
    //开始游戏
    //放置敌方士兵
    //放置我方士兵

    function WarHttpController(m)
    {
        map = m;
        baseUrl = sysinfo(INFO_BASE_URL)+":9000/";
    }
    function connectGame()
    {
        var id = http_request(baseUrl+"connectGame?uid="+str(global.user.papayaId), initOver, null, 15000, null);
    }
    function initOver(rid, rcode, con, param)
    {
        trace("myColor", myColor);
        con = json_loads(con);
        myColor = con["myColor"];
        startGame();
    }

    function startGame()
    {
        http_request(baseUrl+"startGame?uid="+str(global.user.papayaId), receiveMsg, null, 15000, null);
    }

    function receiveMsg(rid, rcode, con, param)
    {
        //超时重连
        if(rcode != 0)
        {
            con = json_loads(con);
            trace("con", con);
            var messages = con["messages"];
            for(var i = 0; i < len(messages); i++)
            {

                var body = messages[i]["body"];
                trace("messages", messages[i]);
                var cmd = body["cmd"];
                if(cmd == "startGame")
                    gameStart = 1;
                else if(cmd == "sendSol" && messages[i]["from"] != str(global.user.papayaId))//敌方消息
                {
                    map.putEnemySol(body);
                }
            }
            if(len(messages) > 0)
                cursor = messages[i-1]["id"];
        }

        if(cursor == null)
            http_request(baseUrl+"receiveMsg", receiveMsg, null, 15000, null);
        else
            http_request(baseUrl+"receiveMsg?cursor="+str(cursor), receiveMsg, null, 15000, null);
    }
    function sendMsg(op, kind, level, mx, my)
    {
        var req = baseUrl+"sendMsg?uid="+str(global.user.papayaId)+"&body="+json_dumps(dict([["cmd", "sendSol"], ["kind", kind], ["level", level], ["mx", mx], ["my", my]]));
        trace("req", req);
        http_request(req, null, null, 15000, null);
    }
}
