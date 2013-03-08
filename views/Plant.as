/*
如果所有建筑都有一个底层node 是菱形拼接图形
那么就可以绝对定位
现在的定位是已经知道农田的2*2 所以直接设置位置

*/

class Plant extends MyNode
{
    var building;
    var curState;
    var data;
    var passTime;
    var id;
    var objectTime;

    //采用客户端计时
    function Plant(b, d, privateData)
    {
        //客户端时间
        if(privateData != null) {
            objectTime = privateData.get("objectTime");
            acced = privateData["acced"];
        } else {
            objectTime = time()/1000;
            acced = 0;
        }


        building = b;
        data = d;
        id = data.get("id");
        var sx = building.data.get("sx");
        var sy = building.data.get("sy");
        
        var bSize = building.bg.size();
        bg = sprite("p0.png").anchor(50, 100).pos((sx+sy)/2*SIZEX, (sx+sy)*SIZEY);
        init();

        curState = 0;
    }

    function getPlantGain()
    {
        var rate = building.data.get("rate", 100);
        var gain = getGain(PLANT, id);
        if(getState() == ROT)//2倍时间没有收获则腐烂 收获1/3
        {
            gain = dict([["exp", gain["exp"]]]);
        }

        var keys = gain.keys();
        for(var k = 0; k < len(keys); k++)
        {
            var v = gain[keys[k]];
            v *= rate/100;
            gain[keys[k]] = v;
        }
        return gain;
    }

    function getLeftTime()
    {
        return (data.get("time")*1000-passTime)/1000;
    }
    //计算开始工作的服务器时间单位秒
    function getStartTime()
    {
        return client2Server((time()-passTime)/1000);
    }
    var acced = 0;
    function finish()
    {
        acced = 1;
        passTime = data.get("time")*1000;
        setState();
    }
    function getAccCost()
    {
        //LeftTime s
        var leftTime = getLeftTime();
        return calAccCost(leftTime);
    }
    function getState()
    {
        return curState;
    }
    function setState()
    {
        var needTime = data.get("time")*1000;
        var newState = passTime*3/needTime;
        newState = min(MATURE, max(SOW, newState));

        if((newState == MATURE) && (passTime >= getParam("rotTime")*needTime) && acced == 0)
        {
            newState = ROT; 
        }

        if(newState != curState)
        {
            curState = newState;
            //building.changeState(curState);
            /*
            农作物的播种 幼苗  枯萎状态 相同 
            */
            if(curState == SOW || curState == SEED ||  curState == ROT)
                bg.texture("p"+str(curState)+".png", UPDATE_SIZE);
            else
                bg.texture("p"+str(data.get("id"))+"_"+str(curState)+".png", UPDATE_SIZE);
            if(curState == MATURE || curState == ROT)
            {
                building.funcBuild.setFlowBanner();
            }
        }

    }
    function update(diff)
    {
        passTime += diff;
        setState();
    }
    //每次重新进入场景 会 重新计算 过去的时间
    override function enterScene()
    {
        super.enterScene();
        var now = time()/1000;
        passTime = (now-objectTime)*1000;//客户端时间
        global.timer.addTimer(this);
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
        super.exitScene();
    }
}
