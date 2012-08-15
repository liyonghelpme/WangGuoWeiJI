class MyAction
{
    var cus;
    var lastTime;
    var actions;
    function MyAction()
    {
        actions = [];
        lastTime = time();
        //cus = customaction(MAX_INT, start, update);
        cus = c_addtimer(50, update, null, 0, -1);
        //getscene().addaction(cus);
    }
    function stop()
    {
        cus.stop();
    }
    function removeAct(obj)
    {
        for(var i = 0; i < len(actions); i++)
        {
            if(actions[i][0] == obj)
            {
                actions[i][1] = 1;
            }
        }
    }
    function addAct(obj)
    {
        actions.append([obj, 0]);
    }
    function start()
    {
    }
    function update()
    {
        var now = time();
        var diff = now - lastTime;
        lastTime = now;
        for(var i = 0; i < len(actions);)
        {
            if(actions[i][1] == 1)
            {
                actions.pop(i);
            }
            else
            {
                actions[i][0].update(diff);
                i++;
            }
        }
    }
}
class MyAnimate
{
    var bg;
    //var cus;
    var ani;
    //var lastTime;
    var accTime;
    var duration;
    function MyAnimate(d, a, b)
    {
        bg = b;
        duration = d;
        ani = a;
        //cus = customaction(duration, start, update);
        //lastTime = time();
        accTime = 0;


    }
    function setAni(a)
    {
        ani = a[0];
        duration = a[1];
    }
    function enterScene()
    {
        //trace("custome animate enter scene");
        global.myAction.addAct(this);
    }
    function update(diff)
    {
        //var now = time();
        //var diff = now - lastTime;
        //lastTime = now;
        //trace("update ", diff);
        accTime += diff;
        accTime %= duration;
        var curFrame = accTime*len(ani)/duration;
        bg.texture(ani[curFrame], ARGB_8888);
    }
    function exitScene()
    {
//        trace("custom animate exit scene");
        global.myAction.removeAct(this);
    }
}
