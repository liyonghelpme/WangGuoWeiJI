class BuildAnimate extends MyNode
{
    var cus;
    function BuildAnimate(build)
    {
        var ani = getAni(build.data.get("id"));
        bg = sprite().pos(ani[1][0], ani[1][1]).anchor(50, 100);
        init();
        cus = new MyAnimate(ani[2], ani[0], bg);
    }
    override function enterScene()
    {
        trace("animate enter scene");
        super.enterScene();
        cus.enterScene();
    }
    override function exitScene()
    {
        cus.exitScene();
        super.exitScene();
    }
}
class Building extends MyNode
{
    //move rotate 
    var map;
    var data;

    var state;
    var lastPoints;
    var planting = null;

    var sx;
    var sy;
    //first check in full
    

    var bottom = null;
    /*
    锚点 50 100
    左上角坐标  (sx+sy)/2*sizeX  (sx+sy)*sizeY
    要保证左上角和sizeX sizeY 网格
    */
    function Building(m, d)
    {
        map = m;
        data = d;
        var id = data.get("id");
        sy = data.get("sy");
        sx = data.get("sx");

        //bg = sprite("build"+str(id)+".png", ALPHA_TOUCH).pos(2526, 618+sizeY*sy/2+sizeY/2*sy%2).anchor(50, 100);
        bg = sprite("build"+str(id)+".png", ALPHA_TOUCH).pos(2526, 618+(sx+sy)/2*sizeY).anchor(50, 100);
        init();
        var npos = normalizePos(bg.pos(), sx, sy);
        setPos(npos);
        //bg.pos(npos);
        //map.updateMap(this);

        //state = data.get("state");
        setState(data.get("state"));
        bg.setevent(EVENT_TOUCH|EVENT_MULTI_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }
    //remove OldPosition map 
    //set NewPosition map
    override function setPos(p)
    {
        //map.removeMap(this);
        bg.pos(p);
        //map.setMap(this);
    }
    function setColPos()
    {
        var other = checkCollision(this, global.user.allBuildings);
        if(other != null)
        {
            setColor(NotBigZone);
            var ret = checkPosSame(other.getPos(), getPos());
            if(ret == 1)
            {
                var temp = getPos();
                temp[0] += sizeX;
                setPos(temp);
            }

        }
        else
            setColor(InZone);
    }
    function setState(s)
    {
        state = s;
        if(state == Moving)
        {
            var sx = data.get("sx");
            var sy = data.get("sy");
            //bg = sprite("p0.png").anchor(50, 50).pos(sx/2*sizeX+sx%2*sizeX, sy/2*sizeY+sy%2*sizeY);
            //bottom = sprite().pos(sx/2*sizeX+sx%2*sizeX, sy/2*sizeY+sy%2*sizeY).anchor(50, 50).size(sizeX*sx+AddX, sizeY*sy+AddY);
            bottom = sprite().pos((sx+sy)/2*sizeX, (sx+sy)/2*sizeY).anchor(50, 50).size((sizeX-3)*2*sx, (sizeY-3)*2*sy).color(100, 100, 100, 100);
            bg.add(bottom, -1);
            //half transparent + color
            //setColor(InZone);
            setColPos();

        }
        else if(state == Free)
        {
            trace("has ani", data);
            if(data.get("hasAni") == 1 )
            {
                addChild(new BuildAnimate(this));
                //am.addaction(cus.cus);
            }
        }
    }
    /*
    override function enterScene()
    {
        super.enterScene();
        if(cus != null)
            cus.enterScene();
    }
    override function exitScene()
    {
        if(cus != null)
        {
            cus.exitScene();
        }
        super.exitScene()
    }
    */ 
    function buildCheckInZone()
    {
        var ret = checkInZone(FullZone, bg.pos());
        if(ret == 0)
        {
            //not in big zone
            return NotBigZone;
        }
        return InZone;
        /*
        else
        {
            for(var i = 0; i < len(FarmZone); i++)
            {
                var inW = checkInZone(FarmZone[0], bg.pos());
                if(inW == 1)
                {
                    return InZone;
                }
            }
        }
        //not in small Zone
        return NotSmallZone;
        */
    }
    function finishBuild()
    {
        state = Free;
        bg.color(100, 100, 100, 100);
        bottom.removefromparent();
        bottom = null;
        setState(Free);
    }
    function touchBegan(n, e, p, x, y, points)
    {
        lastPoints = n.node2world(x, y);         
    }
    function setColor(inZ)
    {
        trace("setColor", inZ);
        if(inZ != InZone)
        {
            bg.color(100, 100, 100, 80)
            bottom.texture("red.png");
        }
        else
        {
            bg.color(100, 100, 100, 80);
            bottom.texture("green.png");
        }
    }
    function moveBack(difx, dify)
    {
        if(state == 0)
        {
            var curPos = bg.pos();
            bg.pos(curPos[0]+difx, curPos[1]+dify);
            var z = buildCheckInZone();

            //set offset
            if(z == NotBigZone)
            {
                var dx = curPos[0]+difx - FullZone[0];
                var dy = curPos[1]+dify - FullZone[1];
                if(dx < 0 && difx < 0)
                    difx = 0;
                if(dx > 0 && difx > 0)
                    difx = 0;
                if(dy < 0 && dify < 0)
                    dify = 0;
                if(dy > 0 && dify > 0)
                    dify = 0;
                bg.pos(curPos[0]+difx, curPos[1]+dify);
            }

            
        }
    }
    function touchMoved(n, e, p, x, y, points)
    {
        if(state == 0)
        {
            var oldPos = lastPoints;
            lastPoints = n.node2world(x, y);
            var difx = lastPoints[0] - oldPos[0];
            var dify = lastPoints[1] - oldPos[1];
            moveBack(difx, dify);
            setColPos();
            /*
            var other = checkCollision(this, global.user.allBuildings);
            trace("collision", other);
            if(other != null)
                setColor(NotBigZone);
            else
                setColor(InZone);
            */
        }
    }
    function showPlantView()
    {
        global.director.pushView(new PlantChoose(this), 1, 0);
    }
    function showGlobalMenu()
    {
        //state = ShowMenuing;
        var funcs = getBuildFunc(data.get("funcs"));
        trace("getFunc", funcs);
        //map.showGlobalMenu(this);
        global.director.pushView(new BuildWorkMenu(this, funcs[0], funcs[1]), 0, 0);
    }
    var showMenuYet = 0;
    function touchEnded(n, e, p, x, y, points)
    {
        if(state == Moving)
        {
            /*
            var other = map.checkCollision(this);
            trace("collision", other);
            if(other != null)
                setColor(NotBigZone);
            else
                setColor(InZone);
            */
            var npos = normalizePos(bg.pos(), sx, sy);
            bg.pos(npos);
        }
        else if(state == Free)
        {
            global.director.curScene.showPlantView(this, showPlantView);
            //global.director.pushView(new PlantChoose(this), 1, 0);
        }
        else if(state == Working)
        {
            if(planting.getState() >= MATURE && showMenuYet == 0)
            {
                harvestPlant();
            }
            else if(showMenuYet == 0)
            {
                showMenuYet = 1;
                global.director.curScene.showGlobalMenu(this, showGlobalMenu);
            }
            /*
            state = ShowMenuing;
            var funcs = getBuildFunc(data.get("funcs"));
            trace("getFunc", funcs);
            map.showGlobalMenu(this);
            global.director.pushView(new BuildWorkMenu(this, funcs[0], funcs[1]), 0, 0);
            */
        }
        /*
        else if(state == 3)
        {
            harvestPlant();
        }
        else if(state == ShowMenuing)
        {
        }
        */
    }
    /*
    来自上层的点击信息，关闭打开的全局菜单
    */
    function closeGlobalMenu()
    {
        //state = Working;
        showMenuYet = 0;
        global.director.popView();
    }
    /*
    function changeState(s)
    {
        //if(s == MATURE || s == ROT)
        //    state = 3;
    }
    */
    function beginPlant(id)
    {
        state = Working;
        trace("planting", id);
        var plant = getPlant(id);
        plant.update("passTime", 0);
        planting = new Plant(this, plant);
        addChild(planting);
    }
    //var sil;
    function harvestPlant()
    {
        state = Free;
        planting.removeSelf();

        /*
        var bsize = bg.size();
        var coor2 = bg.node2world(bsize[0]/2, bsize[1]/2);

        sil = getscene().addsprite("silver.png");
        var dis = sqrt(distance(coor2, [256,460]));
        sil.addaction(sequence(sinein(bezierby(
                    500+dis*25,
                    coor2[0], coor2[1], 
                    coor2[0]+100, coor2[1]-100, 
                    coor2[0]+100, coor2[1]+100, 
                    256, 460)),callfunc(pickMe)));
        */
        global.director.curScene.addChild(new FlyObject(bg, dict([["silver", planting.data.get("silver")]]), harvestOver));
        //flyObject(bg, dict([["silver", planting.data.get("silver")]]), harvestOver);
        planting = null;
    }
    function getLeftTime()
    {
        trace("getWorkTime", state, planting);
        if(state == Working && planting != null)
        {
            return planting.getLeftTime(); 
        }
        return 0;
    }
    //view Value
    function harvestOver()
    {
        //global.user.changeValue("silver", planting.data.get("silver"));
        //sil.removefromparent();
        //sil = null;
        //planting = null;
        //global.user.doAdd(getBuildCost(data.get("id")));
    }
    function doAcc()
    {
        trace("doAcc state", state);
        if(state == Working)
        {
            planting.finish(); 
            global.director.curScene.closeGlobalMenu();
            //global.director.popView();
        }
    }
    /*
    //自己关闭全局菜单
    function selfCloseGlobalMenu()
    {
        map.selfCloseGlobalMenu();
        global.director.popView();
    }
    */
    function doSell()
    {
        //var add = getBuildCost(data.get("id"));
        //flyObject(bg, add, pickMe);
        global.director.curScene.addChild(new FlyObject(bg, getBuildCost(data.get("id")), sellOver));
        map.removeChild(this); 
        //selfCloseGlobalMenu();
        global.director.curScene.closeGlobalMenu();
        //global.director.popView();
    }
    function sellOver()
    {
    }
    /*
    function pickMe()
    {
        global.user.doAdd(getBuildCost(data.get("id")));
    }
    */
    function doPhoto()
    {
        global.director.getPid(); 
    }
}
