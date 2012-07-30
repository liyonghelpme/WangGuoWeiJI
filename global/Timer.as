class Timer
{
    var timers; 
    var begin=0;
    var clock;
    var interval; 
    var gstop;

    var slowUpdate;

    var myTimer;
    function Timer(i)
    {
//        trace("init timer", i);
        gstop = 0;
        timers = new Array();
        slowUpdate = [];
        interval = i;
        //clock = c_addtimer(1000, addAction, null, 0, -1);
        //var cus = customaction(MAX_INT, start, update);
        myTimer = c_addtimer(i, update, null, 0, -1);
        //getscene().addaction(cus);
    }
    function stop()
    {
        myTimer.stop();
    }
    function start()
    {
//        trace("start");
    }
    function gameStop()
    {
        gstop = 1;
    }
    function gameRestart()
    {
        gstop = 0;
    }
    function addSlow(obj)
    {
        slowUpdate.append([obj, 0]);
    }
    function removeSlow(obj)
    {
        for(var i = 0; i < len(slowUpdate); i++)
        {
            if(slowUpdate[i][0] == obj && slowUpdate[i][1] == 0 )
            {
                slowUpdate[i][1] = 1;
                break;
            }
        }
    }
    function addAction()
    {
        /*
//        trace("nodes", sysinfo(24));
//        trace("actions", sysinfo(23));
//        trace("timers", sysinfo(22))
//        trace("fps", getfps());
        */
        var actNum = sysinfo(23);
        if(actNum == 0)
        {
            var cus = customaction(MAX_INT, start, update);
            getscene().addaction(cus);
        }
        for(var i = 0 ; i < len(slowUpdate); )
        {
            if(slowUpdate[i][1] == 1)
                slowUpdate.pop(i);
            else
            {
                slowUpdate[i][0].update();
                i++;
            }
        }
    }
    function addTimer(obj)
    {
//        trace("timerNum", len(timers));
        timers.append([obj, 0]);
    }
    /*
    遍历所有删除所有的注册
    */
    function removeTimer(obj)
    {
        //trace("timerNum", len(timers));
        for(var i = 0; i < len(timers); i++)
        {
            if(timers[i][0] == obj)
            {
                timers[i][1] = 1;
            }
        }
    }
    function update()
    {
        var diff;
        if(begin == 0)
        {
            diff = 0;
            begin = time();
        }
        else
        {
            var now = time();
            diff = now - begin;
            begin = now;
        }
        if(gstop == 0)
        {
            for(var i = 0; i < len(timers); )
            {
                if(timers[i][1] == 1)
                    timers.pop(i);
                else{
                    timers[i][0].update(diff);
                    i++;
                }
            }
        }
    }
}
