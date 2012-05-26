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

    function Plant(b, d)
    {
        building = b;
        data = d;
        var sx = building.data.get("sx");
        var sy = building.data.get("sy");
        
        //bg = sprite("p0.png").anchor(50, 50).pos(sx/2*sizeX+sx%2*sizeX, sy/2*sizeY+sy%2*sizeY);
        var bSize = building.bg.size();
        bg = sprite("p0.png").anchor(50, 100).pos((sx+sy)/2*sizeX, (sx+sy)*sizeY);
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
            /*
            农作物的播种 幼苗  枯萎状态 相同 
            */
            if(curState == SOW || curState == SEED ||  curState == ROT)
                bg.texture("p"+str(curState)+".png", UPDATE_SIZE);
            else
                bg.texture("p"+str(data.get("id"))+"_"+str(curState)+".png", UPDATE_SIZE);

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
    var baseBuild;
    var planting = null;
    function Farm(b)
    {
        baseBuild = b;
    }
    /*
    空闲状态下点击的功能函数
    显示种植页面
    */
    function whenFree()
    {
        global.director.pushView(new PlantChoose(baseBuild), 1, 0);
    }
    function whenBusy()
    {
        if(planting.getState() >= MATURE)
        {
            harvestPlant();
            return 1;
        }
        return 0;
    }
    /*
    农作物选择的回调函数
    */
    function beginPlant(id)
    {
        baseBuild.state = Working;
        trace("planting", id);
        var plant = getData(PLANT, id);//getPlant(id);
        plant.update("passTime", 0);
        planting = new Plant(baseBuild, plant);
        baseBuild.addChild(planting);
    }
    function harvestPlant()
    {
        baseBuild.state = Free;
        planting.removeSelf();

        if(planting.getState() == ROT)
        {
            global.director.curScene.addChild(new FlyObject(baseBuild.bg, dict([["silver", planting.data.get("silver")/2]]), harvestOver));
        }
        else
            global.director.curScene.addChild(new FlyObject(baseBuild.bg, dict([["silver", planting.data.get("silver")]]), harvestOver));
        //flyObject(bg, dict([["silver", planting.data.get("silver")]]), harvestOver);
        planting = null;
    }
    function harvestOver()
    {
        //global.user.changeValue("silver", planting.data.get("silver"));
        //sil.removefromparent();
        //sil = null;
        //planting = null;
        //global.user.doAdd(getBuildCost(data.get("id")));
    }
    function getLeftTime()
    {
        if(baseBuild.state == Working && planting != null)
        {
            return planting.getLeftTime(); 
        }
        return 0;
    }
    function doAcc()
    {
        planting.finish();
    }
}
