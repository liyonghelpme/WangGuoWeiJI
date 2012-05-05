class TouchManager
{
    var standardHandlers;
    var targetHandlers;
    var curTargeted;
    var curStandard;
    function TouchManager()
    {
        trace("init touch");
        standardHandlers = new Array();
        targetHandlers = new Array();
        getscene().setevent(EVENT_TOUCH|EVENT_MULTI_TOUCH, touchBegan);
        getscene().setevent(EVENT_MOVE, touchMove);
        getscene().setevent(EVENT_UNTOUCH, touchEnded);
    }
    function addHead(obj, pri, swallow)
    {
        targetHandlers.insert(0, [obj, pri, swallow, 0]);
        trace("addHead", len(targetHandlers), len(standardHandlers));
    }
    function addTargeted(obj, pri, swallow)
    {
        for(var i = 0; i < len(targetHandlers); i++)
            if(targetHandlers[i][1] >= pri)
                break;
        targetHandlers.insert(i, [obj, pri, swallow, 0]);
        trace("addTargetTouch", len(targetHandlers), len(standardHandlers));
    }
    function addStandard(obj)
    {
        standardHandlers.append([obj, 0]);
        trace("addStandardTouch", len(targetHandlers), len(standardHandlers));
    }
    function removeTouch(obj)
    {
        for(var i = 0; i < len(targetHandlers); i++)
        {
            if(targetHandlers[i][0] == obj && targetHandlers[i][3] == 0)
            {
                targetHandlers[i][3] = 1;
                break;
            }
        }
        if(i >= len(targetHandlers))
        {
            for(i = 0; i < len(standardHandlers); i++)
            {
                if(standardHandlers[i][0] == obj)
                {
                    standardHandlers[i][1] = 1;
                    break;
                }
            }
        }
        trace("removeTouch", len(targetHandlers), len(standardHandlers));
    }
    function touchBegan(n, e, p, x, y, points)
    {
        curTargeted = -1;
        curStandard = -1;
        var swallow = 0;
        //trace("handler num", len(targetHandlers), len(standardHandlers));
        for(var i = 0; i < len(targetHandlers);)
        {
            if(targetHandlers[i][3] == 1)//removed?
                targetHandlers.pop(i);
            else
            {
                var ret = targetHandlers[i][0].touchBegan(x, y);
                if(ret == 1)
                {
                    trace("targetHandlers", i);
                    swallow = targetHandlers[i][2];//swallow
                    //trace("swallow", swallow, i);
                    curTargeted = i;
                    break;
                }
                i++;
            }
        }
        //trace("man begin", x, y, points, standardHandlers, swallow, curStandard);
        if(swallow == 0)
        {
            for(i = 0; i < len(standardHandlers);)
            {
                if(standardHandlers[i][1] == 1)
                    standardHandlers.pop(i);
                else
                {
                    ret = standardHandlers[i][0].touchBegan(points);
                    if(ret == 1)
                    {
                        curStandard = i;
                        break;
                    }
                    i++;
                }
            }
        }
    }
    function touchMove(n, e, p, x, y, points)
    {
        if(curTargeted > -1)
            targetHandlers[curTargeted][0].touchMove(x, y);
        if(curStandard > -1)
            standardHandlers[curStandard][0].touchMove(points);
    }
    function touchEnded(n, e, p, x, y, points)
    {
        if(curTargeted > -1)
            targetHandlers[curTargeted][0].touchEnded(x, y);
        if(curStandard > -1)
            standardHandlers[curStandard][0].touchEnded(points);
    }
}
