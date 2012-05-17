class Plant extends MyNode
{
    var building;
    var curState;
    var data;
    var passTime;

    function Plant(b, d)
    {
        building = b;
        data = d;
        var sx = building.data.get("sx");
        var sy = building.data.get("sy");
        
        //bg = sprite("p0.png").anchor(50, 50).pos(sx/2*sizeX+sx%2*sizeX, sy/2*sizeY+sy%2*sizeY);
        bg = sprite("p0.png").anchor(50, 50).pos((sx+sy)/2*sizeX, (sx+sy)/2*sizeY);
        //bg = sprite("p0.png");
        init();
        passTime = data.get("passTime"); 
        curState = 0;
    }
    /*
    function setPosition()
    {
        var sx = building.data.get("sx");
        var sy = building.data.get("sy");
        //bg.pos(sx/2*sizeX+sx%2*sizeX, sy/2*sizeY+sy%2*sizeY);
        bg.pos((sx+sy)/2*sizeX, (sx+sy)/2*sizeY);
    }
    */
    function getLeftTime()
    {
        trace("leftTime", data.get("time"), passTime);
        return (data.get("time")*1000-passTime)/1000;
    }
    var acced = 0;
    function finish()
    {
        acced = 1;
        passTime = data.get("time")*1000;
        trace("farm Finish", passTime, acced);
        setState();
    }
    function getState()
    {
        return curState;
    }
    function setState()
    {
        var needTime = data.get("time")*1000;
        var newState = passTime*4/needTime;
        newState = min(MATURE, max(SOW, newState));

        if((newState == MATURE) && (passTime >= 2*needTime) && acced == 0)
        {
            newState = ROT; 
        }
        trace("pass Time", passTime, needTime, newState, curState);

        if(newState != curState)
        {
            curState = newState;
            //building.changeState(curState);
            bg.texture("p"+str(curState)+".png", UPDATE_SIZE);

            //var par = bg.parent();
            //bg.removefromparent();
            //bg = sprite("p"+str(curState)+".png").anchor(50, 50);
            //setPosition();
            //bg.init();
            //par.add(bg);
        }

    }
    function update(diff)
    {
        passTime += diff;
        setState();
    }
    override function enterScene()
    {
        trace("plant EnterScene");
        super.enterScene();
        global.timer.addTimer(this);
    }
    override function exitScene()
    {
        trace("exit Timer");
        global.timer.removeTimer(this);
        super.exitScene();
    }
}

class Farm extends MyNode
{
    
}
