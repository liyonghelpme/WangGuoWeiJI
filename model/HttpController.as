class HttpController
{
    var baseUrl;
    var requestList;
    var busy = 0;
    //基于事件的异步请求

    var registerHandler;
    function HttpController()
    {
        //baseUrl = "http://uhz000738.chinaw3.com:8100/";
        baseUrl = sysinfo(INFO_BASE_URL)+":8100/";
        //baseUrl = "http://192.168.3.102:8100/";
        requestList = [];//请求是有序的
        registerHandler = dict();//注册对应id 请求的处理函数
        global.timer.addTimer(this);
    }
    function addRequest(req, postData, handler, param)
    {
        trace("addRequest", req, handler, postData, param);
        requestList.append([req, handler, postData, param]);
        doRequest();
    }
    //例子: 'login', callback, dict([[], [], []]) null 
    function doRequest()
    {
        if(len(requestList) > 0 && busy == 0)
        {
            busy = 1;
            var req = requestList.pop(0);
            var cmd = req[0];
            var postData = req[2];
            var param = req[3];
            trace("doRequest", req, baseUrl+cmd);
            var id = http_request(baseUrl+cmd, callbackHandler, postData, 15000, param);
            registerHandler.update(id, req);
        }
    }
    function callbackHandler(rid, rcode, con, param)
    {
        busy = 0;
        trace("request Handler", rid, rcode,  param);
        trace("content", con);

        var req = registerHandler.pop(rid);
        var handler = req[1];
        //将所有的请求信息作为 参数传给处理函数
        if(rcode == 0)
        {
            trace("request Failed");
            http_request(baseUrl+"reportError", errorHandler, dict([["uid", global.user.uid], ["errorDetail", [req[0], req[2], req[3]]]]), 15000, null);
            global.director.pushView(new MyWarningDialog(getStr("netError", null), getStr("netErrorCon", null), null), 1, 0);
        }
        if(handler != null)
            handler(rid, rcode, con, param);    
        doRequest();
    }
    function errorHandler(rid, rcode, con, param)
    {
        trace("report Error");
    }

    var passTime = 0;
    function update(diff)
    {
        passTime += diff;
        //1min 同步一次 生命值数据
        if(passTime >= 60000)
        {
            passTime = 0;
            //synHealth();
        }
    }
}
