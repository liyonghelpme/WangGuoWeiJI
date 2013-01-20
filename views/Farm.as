
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
        global.director.pushView(new PlantChoose(baseBuild), 0, 0);
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
    //出现成熟标志
    function setFlowBanner()
    {
        if(flowBanner == null)
        {
            flowBanner = baseBuild.bg.addsprite("flowBanner.png").pos(64, -11).anchor(50, 100);
            var pl = flowBanner.addsprite("Wplant"+str(planting.id)+".png").anchor(50, 50).pos(33, 20);
            var sca = strictSca(pl, [52, 31]);
            pl.scale(sca);
            flowBanner.addaction(sequence(delaytime(rand(2000)), repeat(moveby(500, 0, -20), delaytime(300), moveby(500, 0, 20))));
            //global.taskModel.showHintArrow(baseBuild.bg, baseBuild.bg.size(), HARVEST_ICON);
        }
    }
    override function initWorking(data)
    {
//        trace("planting", data);
        if(data == null)
            return;
        if(baseBuild.state != PARAMS["buildWork"])
            return;

        trace("initWorking", data);
        var id = data.get("objectId"); 
        var plant = getData(PLANT, id);//getPlant(id);
        
        //var now = time()/1000;//秒为单位
        var startTime = data.get("objectTime");//serverTime 秒为单位
        startTime = server2Client(startTime); 
        
        //是否加速过农作物 用于新手任务放置腐败
        var privateData = dict([["objectTime", startTime], ["acced", data.get("acced", 0)]]);//采用客户端计时

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
        trace("beginPlant0");
        baseBuild.setState(PARAMS["buildWork"]);

        trace("beginPlant1");
        var plant = getData(PLANT, id);//getPlant(id);

        trace("beginPlant2");
        planting = new Plant(baseBuild, plant, null);

        trace("beginPlant3");
        baseBuild.addChild(planting);
        //建筑状态也需要改变

        trace("beginPlant4");
        global.user.updateBuilding(baseBuild);
        trace("planting", id);
    }
    function doHarvest()
    {
        baseBuild.removeLock();

        baseBuild.state = PARAMS["buildFree"];
        planting.removeSelf();

        //魔法农田经验 银币 rate 是2倍
        trace("farmGain", plantGain);

        global.director.curScene.addChild(new FlyObject(baseBuild.bg, plantGain, harvestOver));

        planting = null;
        global.user.updateBuilding(baseBuild);
        global.taskModel.doNewTaskByKey("plant", 1);
        
        //完成收获农作物
        global.taskModel.doAllTaskByKey("harvestFarm", plantGain.get("silver", 0));
    }
    //存储农作物的收获 用于 之后的客户端显示
    var plantGain = null;
    function harvestPlant()
    {
        plantGain = planting.getPlantGain();
        //收获农作物 新手任务数值是要同步的
        global.httpController.addRequest("buildingC/harvestPlant", dict([["uid", global.user.uid], ["bid", baseBuild.bid], ["gain", json_dumps(plantGain)]]), doHarvest, null);
        baseBuild.waitLock("harvesting");
    }
    function harvestOver()
    {
    }
    override function getLeftTime()
    {
        if(baseBuild.state == PARAMS["buildWork"] && planting != null)
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
    override function doAcc()
    {
        var cost = dict([["gold", planting.getAccCost()]]);
        global.user.doCost(cost);
        global.httpController.addRequest("buildingC/accPlant", dict([["uid", global.user.uid], ["bid", baseBuild.bid], ["gold", planting.getAccCost()]]), null, null);
        planting.finish();
        global.user.updateBuilding(baseBuild);

        var showData = cost; 
        showMultiPopBanner(cost2Minus(showData));
    }
}


