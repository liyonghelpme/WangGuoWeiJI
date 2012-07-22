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

    function Plant(b, d, privateData)
    {
        building = b;
        data = d;
        id = data.get("id");
        var sx = building.data.get("sx");
        var sy = building.data.get("sy");
        
        //bg = sprite("p0.png").anchor(50, 50).pos(sx/2*sizeX+sx%2*sizeX, sy/2*sizeY+sy%2*sizeY);
        var bSize = building.bg.size();
        bg = sprite("p0.png").anchor(50, 100).pos((sx+sy)/2*sizeX, (sx+sy)*sizeY);
        //bg = sprite("p0.png");
        init();
        if(privateData != null)
            passTime = privateData.get("passTime"); 
        else 
            passTime = 0;
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
    function getStartTime()
    {
        return time()-passTime;
    }
    var acced = 0;
    function finish()
    {
        acced = 1;
        passTime = data.get("time")*1000;
        trace("farm Finish", passTime, acced);
        setState();
    }
    function getAccCost()
    {
        //LeftTime s
        var leftTime = (data.get("time")*1000-passTime)/1000;
        return leftTime; 
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

        if((newState == MATURE) && (passTime >= 2*needTime) && acced == 0)
        {
            newState = ROT; 
        }
        trace("pass Time", passTime, needTime, newState, curState);

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

class Farm extends FuncBuild
{
    var planting = null;
    function Farm(b)
    {
        baseBuild = b;
    }
    /*
    空闲状态下点击的功能函数
    显示种植页面
    */
    override function whenFree()
    {
        global.director.pushView(new PlantChoose(baseBuild), 1, 0);
        return 1;
    }
    override function getObjectId()
    {
        if(planting != null)
            return planting.id;
        return -1;
    }
    override function whenBusy()
    {
        if(planting.getState() >= MATURE)
        {
            harvestPlant();
            flowBanner.removefromparent();
            flowBanner = null;
            return 1;
        }
        return 0;
    }
    var flowBanner = null;
    function setFlowBanner()
    {
        if(flowBanner == null)
        {
            flowBanner = baseBuild.bg.addsprite("flowBanner.png").pos(64, -11).anchor(50, 100);
            var pl = flowBanner.addsprite("Wplant"+str(planting.id)+".png").anchor(50, 50).pos(43, 30);
            var bsize = pl.prepare().size();
            var sca = min(63*100/bsize[0], 42*100/bsize[1]);
            pl.scale(sca);
            flowBanner.addaction(sequence(delaytime(rand(2000)), repeat(moveby(500, 0, -20), delaytime(300), moveby(500, 0, 20))));
        }
    }
    override function setPos()
    {
    }
    override function initWorking(data)
    {
        trace("planting", data);
        if(data == null)
            return;
        if(baseBuild.state != Working)
            return;
        var id = data.get("objectId"); 
        var plant = getData(PLANT, id);//getPlant(id);
        
        var now = time()/1000;//秒为单位

        var startTime = data.get("objectTime");//serverTime 秒为单位

        startTime = server2Client(startTime); 
        trace("startTime", startTime, now, id);

        
        var privateData = dict([["passTime", (now-startTime)*1000]]);//毫秒为单位

        planting = new Plant(baseBuild, plant, privateData);
        baseBuild.addChild(planting);
    }
    override function getAccCost()
    {
        if(planting != null)
        {
            return planting.getAccCost();
        }
        return 0;
    }
    /*
    农作物选择的回调函数
    */
    function beginPlant(id)
    {
        //baseBuild.state = Working;
        baseBuild.setState(Working);
        trace("planting", id);
        var plant = getData(PLANT, id);//getPlant(id);
        planting = new Plant(baseBuild, plant, null);
        baseBuild.addChild(planting);
        //建筑状态也需要改变
        global.user.updateBuilding(baseBuild);
    }
    function doHarvest()
    {
        baseBuild.removeLock();

        baseBuild.state = Free;
        planting.removeSelf();

        var rate = baseBuild.data.get("rate", 1);
        var gain = getGain(PLANT, planting.id);
        //魔法农田经验 银币 rate 是2倍
        if(planting.getState() == ROT)//2倍时间没有收获则腐烂 收获1/3
        {
            gain = dict([["exp", gain["exp"]]]);
        }

        var keys = gain.keys();
        for(var k = 0; k < len(keys); k++)
        {
            var v = gain[keys[k]];
            v *= rate;
            gain[keys[k]] = v;
        }

        global.director.curScene.addChild(new FlyObject(baseBuild.bg, gain, harvestOver));

        planting = null;
        global.user.updateBuilding(baseBuild);
    }
    function harvestPlant()
    {
        global.httpController.addRequest("buildingC/harvestPlant", dict([["uid", global.user.uid], ["bid", baseBuild.bid]]), doHarvest, null);
        baseBuild.waitLock("harvesting");

        /*
        baseBuild.state = Free;
        planting.removeSelf();

        var rate = baseBuild.data.get("rate", 1);
        var gain = getGain(PLANT, planting.id);
        //魔法农田经验 银币 rate 是2倍
        if(planting.getState() == ROT)//2倍时间没有收获则腐烂 收获1/3
        {
            gain = dict([["exp", gain["exp"]]]);
        }

        var keys = gain.keys();
        for(var k = 0; k < len(keys); k++)
        {
            var v = gain[keys[k]];
            v *= rate;
            gain[keys[k]] = v;
        }

        global.director.curScene.addChild(new FlyObject(baseBuild.bg, gain, harvestOver));

        planting = null;
        global.user.updateBuilding(baseBuild);
        */
    }
    function harvestOver()
    {
        //global.user.changeValue("silver", planting.data.get("silver"));
        //sil.removefromparent();
        //sil = null;
        //planting = null;
        //global.user.doAdd(getBuildCost(data.get("id")));
    }
    override function getLeftTime()
    {
        if(baseBuild.state == Working && planting != null)
        {
            return planting.getLeftTime(); 
        }
        return 0;
    }
    override function getStartTime()
    {
        if(planting != null)
            return planting.getStartTime();
        return 0;
    }
    /*
    override function doAcc()
    {
        planting.finish();
        global.user.updateBuilding(baseBuild);
    }
    */
}
