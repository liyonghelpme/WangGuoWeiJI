
class BuildAnimate extends MyNode
{
    var cus;
    var build;
    //pics pos time kind anchor
    function BuildAnimate(b)
    {
        build = b;
        var ani = getAni(build.data.get("id"));
        trace("building animate", ani);
        bg = sprite(ani[0][0], ARGB_8888).pos(ani[1][0], ani[1][1]).anchor(ani[4][0], ani[4][1]);
        init();
        cus = null;
        var aniKind = ani[3];
        if(aniKind == 0)
        {
            cus = new MyAnimate(ani[2], ani[0], bg);
        }
        else
        {
            bg.addaction(repeat(rotateby(ani[2], 360)));
        }
            
    }
    /*
    切换帧动画的位置播放
    切换旋转动画的纹理和旋转方向
    */
    function changeDir()
    {
        var ani = getAni(build.data.get("id")+build.dir);
        var aniKind = ani[3];
        if(aniKind == 0)
        {
            bg.pos(ani[1][0], ani[1][1]);
        }
        else if(aniKind == 1)
        {
            bg.texture(ani[0][0]); 
            var deg = 360;
            if(build.dir == 1)
                deg = -360;
            bg.addaction(sequence(stop(), repeat(rotateby(ani[2], deg)))); 
        }
        global.user.updateBuilding(this);
    }
    override function enterScene()
    {
        trace("animate enter scene");
        super.enterScene();
        if(cus != null)
            cus.enterScene();
    }
    override function exitScene()
    {
        if(cus != null)
            cus.exitScene();
        super.exitScene();
    }
}

class Building extends MyNode
{
    //move rotate 
    var map;
    var data;
    var bid;

    var state;
    var lastPoints;

    var id;
    var sx;
    var sy;
    //建造初始化位置
    var kind;
    //建筑物功能
    var funcs;
    var dir;
    //缓存冲突标记
    var oldPos;
    //first check in full

    //提供建筑类型相关特殊功能的代理 Farm House
    var funcBuild = null;
    

    var bottom = null;

    /*
    在设置完特殊建筑之后设置相应的建筑的
    锚点 50 100
    左上角坐标  (sx+sy)/2*sizeX  (sx+sy)*sizeY
    要保证左上角和sizeX sizeY 网格
    所有建筑都有方向属性， 只是农田不能改变方向而已
    */
    var aniNode = null;
    function Building(m, d, privateData)
    {
        map = m;
        data = d;
        id = data.get("id");
        sy = data.get("sy");
        sx = data.get("sx");
        kind = data.get("kind");
        funcs = data.get("funcs");

        if(funcs == FARM_BUILD)
            funcBuild = new Farm(this);
        else if(funcs == HOUSE_BUILD)
            funcBuild = new House(this);
        else if(funcs == DECOR_BUILD)
            funcBuild = new Decor(this);
        else 
            funcBuild = new Castle(this);

        trace("init building", data);
        bg = sprite("build"+str(id)+".png", ARGB_8888, ALPHA_TOUCH).pos(ZoneCenter[kind][0], ZoneCenter[kind][1]).anchor(50, 100);
        init();
        if(privateData != null)//初始化数据建筑
        {
            dir = privateData.get("dir", 0);
            setState(privateData.get("state", Moving));
        }
        else//新建建筑
        {
            dir = 0;
            setState(Moving);
        }
        setDir(dir);





        var npos = normalizePos(bg.pos(), sx, sy);
        setPos(npos);
        setColPos();

        /*
        初始化农作物 工作状态
        */
        funcBuild.initWorking(privateData);
        /*
        初始化动画
        */
        if(data.get("hasAni") == 1 )
        {
            aniNode = new BuildAnimate(this);
            addChild(aniNode);
        }
        //global.user.updateMap(this);

        bg.setevent(EVENT_TOUCH|EVENT_MULTI_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);

    }
    function getObjectId()
    {
        return funcBuild.getObjectId();
    }
    function getStartTime()
    {
        return funcBuild.getStartTime();
    }
    function setBid(b)
    {
        bid = b;
    }
    function setMap(m)
    {
        map = m;
    }
    /*
    override function enterScene()
    {
        super.enterScene();
        //global.user.updateMap(this);
    }
    override function exitScene()
    {
        //global.user.clearMap(this);
        super.exitScene();
    }
    */
    function setDir(d)
    {
        dir = d;
        if(dir == 0)
            bg.scale(100, 100);
        else 
            bg.scale(-100, 100);
    }
    function onSwitch()
    {
        if(data.get("changeDir") == 0)
            return;
        dir = 1-dir;
        //bg.texture("build"+str(id+dir)+".png");
        //bg.texture("build"+str(id)+".png");
        if(dir == 0)
            bg.scale(100, 100);
        else 
            bg.scale(-100, 100);
        //if(aniNode != null)
        //    aniNode.changeDir();
        
    }
    //remove OldPosition map 
    //set NewPosition map
    function setZord()
    {
        var zOrd = bg.pos()[1];
        var par = bg.parent();
        bg.removefromparent();
        par.add(bg, zOrd);
    }

    /*
    更新建筑物的zOrd 根据当前的y值进行排序
    每次设置新的坐标前 清楚旧的坐标map 构建新的坐标map
    可以在移动开始的时候 清楚坐标映射 Moving 状态 和 Planing 状态
    在放下的时候 重新映射

    
    设置位置 检测冲突 设置zord
    */
    override function setPos(p)
    {
        trace("setPos", p);
        var curPos = p;
        var zOrd = curPos[1];
        if(state == Moving || (checkPlaning() && global.director.curScene.curBuild == this))
            zOrd = MAX_BUILD_ZORD;
        trace("setZord", zOrd);
        bg.pos(p);
        var par = bg.parent();
        if(par == null)
            return;
        bg.removefromparent();
        par.add(bg, zOrd);
    }

    /*
    检测所有的建筑的碰撞效率较低， 可以采用hash表的方式
    不在大区域中， 则显示后色底色
    根据建筑当前所在位置的状态设定建筑的颜色
    */
    var colNow = 0;
    function setColPos()
    {
        colNow = 0;
        var z = buildCheckInZone();
        if(z == NotBigZone)
        {
            setColor(NotBigZone);
            colNow = 1;
        }
        else
        {
            var other = global.user.checkCollision(this);
            if(other != null)
            {
                //global.user.setCol(this);
                setColor(NotBigZone);
                colNow = 1;
            }
            else
            {
                setColor(InZone);
            }
        }
    }
    /*
    进入规划模式， 保存旧的坐标 
    */
    function keepPos()
    {
        oldPos = getPos();
    }
    /*
    取消规划模式
    */
    function restorePos()
    {
        setPos(oldPos);
        finishPlan();
    }
    /*
    状态可以做成 位与的形式
    */
    function setState(s)
    {
        state = s;
        if((state == Moving) || checkPlaning())
        {
            bg.prepare();
            var bSize = bg.size();

            trace("back Size", bSize, (sx+sy)/2*sizeY);
            /*
            如果方块的大小恰好和建筑物的底座一样大小 那么要求建筑物底座必须要一定大小
            +40 +20
            */
            bottom = sprite().pos(bSize[0]/2, bSize[1]-(sx+sy)/2*sizeY).anchor(50, 50).size((sx+sy)*sizeX+20, (sx+sy)*sizeY+10).color(100, 100, 100, 100);
            bg.add(bottom, -1);
            //half transparent + color
        }

    }

    function buildCheckInZone()
    {
        var ret = checkInZone(bg.pos());
        if(ret == 0)
        {
            //not in big zone
            return NotBigZone;
        }
        return InZone;
    }
    /*
    建造时，防止重叠， 将建筑物放在最高层，建造结束调整建筑物的位置
    */
    function finishBuild()
    {
        setState(Free);
        finishBottom();
        setZord();
        global.user.updateBuilding(this);
    }
    /*
    建造结束 或者 规划结束需要清理 底层图标
    */
    function finishBottom()
    {
        bg.color(100, 100, 100, 100);
        bottom.removefromparent();
        bottom = null;
    }
    /*
    被点击， 且在规划模式，则设置背景
    每次移动的时候都要首先清楚建筑当前的map映射
    放下之后，立即又要生成建筑的新坐标map映射

    每次touchBegan 向 父亲节点传播
    */
    var accMove = 0;
    function touchBegan(n, e, p, x, y, points)
    {
        //accDifX = 0;
        //accDifY = 0;
        accMove = 0;
        lastPoints = n.node2world(x, y);         
        
        map.touchBegan(n, e, p, x, y, points); 

        if(checkPlaning())
        {
            var setSuc = global.director.curScene.setBuilding(this);
            if(setSuc == 0)
                return;
            if(bottom == null)
            {
                setState(state);
            }
        }

        if(state == Moving || checkPlaning())
        {
            global.user.clearMap(this);
        }


    }
    function finishPlan()
    {
        if(bottom != null)
        {
            finishBottom();
            setZord();
            //bottom.removefromparent();
            //bottom = null;
        }
    }
    function setColor(inZ)
    {
        trace("setColor", inZ);
        if(bottom == null)
            return;
        if(inZ != InZone)
        {
            //bg.color(93, 4, 1, 30);//red
            bottom.texture("red2.png");
        }
        else
        {
            //bg.color(3, 93, 81, 30);//green
            bottom.texture("green2.png");
        }
    }
    /*
    移动量积累到一定程度才移动建筑物
    生成新的网格位置
    判断新位置是否越界 如果是 则回复旧位置
    手指位置最近的有效位置 

    A B 对象之间存在冲突， 应该存在一个冲突对象列表
    构成冲突关系
    */
    //var accDifX = 0;
    //var accDifY = 0;
    function moveBack(newPos)
    {
        //accDifX += difx;
        //accDifY += dify;

        //var curPos = bg.pos();
        setPos(newPos);
    }
    /*
    规范化当前的手指位置， 测试位置是否合法

    如果建筑物自身不在移动状态则将touch 事件 向父亲传播
    多点触摸的话也要传递给父亲
    */
    function touchMoved(n, e, p, x, y, points)
    {

        var oldPos = lastPoints;
        lastPoints = n.node2world(x, y);
        var difx = lastPoints[0] - oldPos[0];
        var dify = lastPoints[1] - oldPos[1];
        if(state == Moving || checkPlaning())
        {
            if(global.director.curScene.curBuild != this)
                return;
            var parPos = bg.parent().world2node(lastPoints[0], lastPoints[1]);
            var newPos = normalizePos(parPos, sx, sy)
            moveBack(newPos);
            setColPos();
            if(len(points) >= 3)//-1 0 1
            {
                map.touchMoved(n, e, p, x, y, points);
            }
        }
        else
        {
            accMove += abs(difx) + abs(dify);
            map.touchMoved(n, e, p, x, y, points);
        }
    }

    function showGlobalMenu()
    {
        showMenuYet = 1;
        var func = getBuildFunc(funcs);
        trace("getFunc", func, funcs);
        global.director.pushView(new BuildWorkMenu(this, func[0], func[1]), 0, 0);
    }
    var showMenuYet = 0;
    /*
    如果用户手指移动 一定的范围 表示没有意图打开建筑物对话框
    当前移动建筑不是 自身不能处理

    */
    function touchEnded(n, e, p, x, y, points)
    {

        var ret;
        trace("building State", state, accMove, kind, funcs);
        if((state == Moving) || checkPlaning())
        {
            if(global.director.curScene.curBuild != this)
                return;
            if(colNow == 0 && state != Moving)//无冲突规划状态 清除zord 和 底座
            {
                setZord();
                //finishBottom();
            }
                
            //var npos = normalizePos(bg.pos(), sx, sy);
            //setPos(npos);
            //colNow = setColPos();
            global.user.updateMap(this);
        }
        /*
        如果移动过多则不打开建筑物菜单
        建筑物私有对象如果没有处理改功能， 那就采用统一的弹出功能菜单的方案
        例如 城堡 民居 装饰物
        */
        else if(state == Free && accMove < 20)
        {
            ret = funcBuild.whenFree();
            if(ret == 0)
            {
                if(showMenuYet == 0)
                {
                    global.director.curScene.showGlobalMenu(this, showGlobalMenu);
                }
            }
        }
        /*
        工作中的农田显示
        */
        else if(state == Working)
        {
            if(showMenuYet == 0)
            {
                ret = funcBuild.whenBusy();
                if(ret == 0)
                {
                    //showMenuYet = 1;
                    global.director.curScene.showGlobalMenu(this, showGlobalMenu);
                }
            }
        }
        //父亲节点移动结束
        map.touchEnded(n, e, p, x, y, points);
    }
    /*
    来自上层的点击信息，关闭打开的全局菜单
    应该由场景的 来关闭view
    */
    function closeGlobalMenu()
    {
        showMenuYet = 0;
        //global.director.popView();
    }


    /*
    返回当前工作状态的剩余时间 和建筑物类型相关
    */
    function getLeftTime()
    {
        return funcBuild.getLeftTime();
    }
    //view Value
    /*
    建筑物加速
    只提供功能 但是不会操作 view
    */
    function doAcc()
    {
        trace("doAcc state", state);
        if(state == Working)
        {
            global.director.pushView(new AccDialog(this));
            //funcBuild.doAcc();
        }
    }
    function getAccCost()
    {
        return funcBuild.getAccCost();
    }
    function sureToAcc()
    {
        trace("doAcc state", state);
        if(state == Working)
        {
            funcBuild.doAcc();
        }
    }
    /*
    当buildLayer 加入 和清楚建筑物的时候， 相应的处理建筑物的状态
    通过 点击子菜单的 sell按钮来卖出 子菜单 直接 调用 建筑物的卖出函数 子菜单 再关闭自己
    通过 点击规划菜单的按钮来卖出

    建筑的函数 只提供功能， 但是 不会 去操作view
    */
    function doSell()
    {
        global.director.pushView(new SellDialog(this));
    }
    function sureToSell()
    {
        global.director.curScene.addChild(new FlyObject(bg, getBuildCost(data.get("id")), sellOver));
        map.removeChild(this); 
        global.user.sellBuild(this);
    }
    function sellOver()
    {
        trace("sellOver");
    }
    function doPhoto()
    {
        global.director.getPid(); 
    }
}
