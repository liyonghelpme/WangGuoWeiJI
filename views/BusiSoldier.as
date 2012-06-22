class BusiSoldier extends MyNode
{
    /*
    和建筑物应该在同一个图层上面 这样有正常的遮挡关系
    */
    var map; 
    var kind;
    var sid;
    var id;
    var sx = 1;
    var sy = 1;
    var state = SOL_FREE;
    var tar = null;
    //var mobj;
    //var cus = null;
    var myName;
    var shadow;
    var speed = 5;

    var movAni;
    var shiftAni;
    var data;

    var inspire = INSPIRE;
    var inspirePic = null;

    var healthBoundary;
    var health;

    var attack;
    var defense;
    var exp;
    var dead;
    var level;
    const showSize = 50;

    /*
    需要在行走的时候开始动画
    updateMap 是view相关数据是由动作生成的
    */
    function initData(privateData)
    {
        if(privateData == null)
            privateData = dict();
        health = privateData.get("health", 0); 
        healthBoundary = privateData.get("healthBoundary", 0); 
        attack = privateData.get("attack", 0); 
        defense = privateData.get("defense", 0); 
        exp = privateData.get("exp", 0);
        dead = privateData.get("dead", 0);
        level = privateData.get("level", 0);
    }
    function updateStaticData(d)
    {
        data = d;
        id = data.get("id");
        load_sprite_sheet("soldierm"+str(id)+".plist");
        bg.texture("soldierm"+str(id)+".plist/ss"+str(id)+"m0.png");
        if(movAni != null)
            movAni.stop();
        movAni = repeat(animate(1500, "soldierm"+str(id)+".plist/ss"+str(id)+"m0.png", "soldierm"+str(id)+".plist/ss"+str(id)+"m1.png","soldierm"+str(id)+".plist/ss"+str(id)+"m2.png","soldierm"+str(id)+".plist/ss"+str(id)+"m3.png","soldierm"+str(id)+".plist/ss"+str(id)+"m4.png","soldierm"+str(id)+".plist/ss"+str(id)+"m5.png","soldierm"+str(id)+".plist/ss"+str(id)+"m6.png"));

    }
    //杀死该士兵后
    //view 消失 user 场景对象消失
    function killMonster()
    {
        dead = 1;
        global.user.updateSoldiers(this);//更新死亡状态
        map.removeChild(this); 
    }
    function doTrain()
    {
        killMonster();
    }
    function BusiSoldier(m, d, privateData, s)
    {
        sid = s;
        data = d;
        map = m;
        id = data.get("id");
        load_sprite_sheet("soldierm"+str(id)+".plist");
        bg = sprite("soldierm"+str(id)+".plist/ss"+str(id)+"m0.png").pos(465, 720).anchor(50, 100).scale(showSize, showSize);
        init();
        bg.prepare();
        var bSize = bg.size();
        shadow = sprite("roleShadow.png").pos(bSize[0]/2, bSize[1]).anchor(50, 50);
        bg.add(shadow, -1);
        initData(privateData);


        var nPos = normalizePos(bg.pos(), sx, sy);
        setPos(nPos);
        curMap = global.user.updateMap(this);
        //mobj = new MoveObject();
        //mobj.speed = 5;
        //var ani = getMoveAnimate(id);
        //cus = new MyAnimate(ani[1], ani[0], bg);

        movAni = repeat(animate(1500, "soldierm"+str(id)+".plist/ss"+str(id)+"m0.png", "soldierm"+str(id)+".plist/ss"+str(id)+"m1.png","soldierm"+str(id)+".plist/ss"+str(id)+"m2.png","soldierm"+str(id)+".plist/ss"+str(id)+"m3.png","soldierm"+str(id)+".plist/ss"+str(id)+"m4.png","soldierm"+str(id)+".plist/ss"+str(id)+"m5.png","soldierm"+str(id)+".plist/ss"+str(id)+"m6.png"));
        shiftAni = moveto(0, 0, 0);
        if(privateData != null)
            myName = privateData.get("name", "");
        else
            myName = "";
        showInspire();

        bg.setevent(EVENT_TOUCH|EVENT_MULTI_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }
    function setSid(s)
    {
        sid = s;
    }
    function doSell()
    {
        global.director.pushView(new SellDialog(this));
    }
    function sureToSell()
    {
        global.director.curScene.addChild(new FlyObject(bg, getBuildCost(data.get("id")), sellOver));
        //修改view
        map.removeChild(this); 
        //修改数据
        global.user.sellSoldier(this);
    }
    function sellOver()
    {
    }
    function inspireMe()
    {
        inspire = 0;
        inspireTime = 0;
        inspirePic.removefromparent();
        inspirePic = null;
        exp += 100;
        global.user.updateSoldiers(this);
        var nPos = bg.node2world(0, -10);
        global.director.curScene.addChild(new TrainBanner(nPos, 100));
    }

    /*
    修改士兵的id
    修改士兵的攻击力 防御力 经验
    修改士兵的显示状态
    */
    function doTransfer()
    {
        var needExp = data.get("needExp");
        var level = id%10;
        if(exp >= needExp && level < 3)
        {
        //改变形象bg  改变数据 id 
            id += 1;
            exp = 0;
            var d = getData(SOLDIER, id);
            updateStaticData(d);
            global.user.updateSoldiers(this);
        }
    }
    var accMove = 0;
    var lastPoints;
    function touchBegan(n, e, p, x, y, points)
    {
        accMove = 0;
        lastPoints = n.node2world(x, y);
        map.touchBegan(n, e, p, x, y, points);
    }
    function touchMoved(n, e, p, x, y, points)
    {
        var oldPos = lastPoints;
        lastPoints = n.node2world(x, y);
        var difx = lastPoints[0] - oldPos[0];
        var dify = lastPoints[1] - oldPos[1];
        accMove += abs(difx)+abs(dify);
        map.touchMoved(n, e, p, x, y, points); 
    }
    function showGlobalMenu()
    {
        showMenuYet = 1;
        var func1 = ["photo", "drug", "equip"];
        var func2 = ["train", "gather"];
        if(inspire == INSPIRE)
            func2 = ["inspire", "train", "gather"];
            
        global.director.pushView(new SoldierMenu(this, func1, func2), 0, 0); 
    }
    function closeGlobalMenu()
    {
        showMenuYet = 0;
    }
    var showMenuYet = 0;
    function touchEnded(n, e, p, x, y, points)
    {
        if(showMenuYet == 0)
        {
            global.director.curScene.showGlobalMenu(this, showGlobalMenu);
        }
        map.touchEnded(n, e, p, x, y, points);
    }

    function setName(n)
    {
        myName = n;
        global.user.updateSoldiers(this);
    }
    override function enterScene()
    {
        super.enterScene();
        map.solTimer.addTimer(this);
    }
    //8 目标位置
    function getTar()
    {
        var curPos = bg.pos();
        var map = getPosMap(sx, sy, curPos[0], curPos[1]);  
        //trace("curMap", map, curPos);
        map = [map[2], map[3]];
        var allPos = [
            [map[0]+0, map[1]+-4],
            [map[0]+-1, map[1]+-3],
            [map[0]+-2, map[1]+-2],
            [map[0]+-3, map[1]+-1],
            [map[0]+-4, map[1]+0],
            [map[0]+-3, map[1]+1],
            [map[0]+-2, map[1]+2],
            [map[0]+-1, map[1]+3],
            [map[0]+0, map[1]+4],
            [map[0]+1, map[1]+3],
            [map[0]+2, map[1]+2],
            [map[0]+3, map[1]+1],
            [map[0]+4, map[1]+0],
            [map[0]+3, map[1]+-1],
            [map[0]+2, map[1]+-2],
            [map[0]+1, map[1]+-3],
        ];
        var start = rand(len(allPos));
        var moveable = 0;
        for(var i = 0; i < len(allPos); i++)
        {
            var cur = (start+i)%len(allPos);
            var curMap = allPos[cur];
            var tPos = setBuildMap([sx, sy, curMap[0], curMap[1]]);
            var col = global.user.checkPosCollision(curMap[0], curMap[1], tPos);
            //trace("sol col", col, tPos, curPos, curMap);
            //var build = global.user.mapDict.get(allPos[i][0]*10000+allPos[i][1], []);
            if(col == null)
            {
                moveable = 1;
                break;   
            }
        }
        //trace("move TarGetPos", start+i);
        //trace("getTar", moveable);
        if(moveable == 1)
        {
            var tmap = allPos[(start+i)%len(allPos)];
            return setBuildMap([sx, sy, tmap[0], tmap[1]]);
        }
        return null;
    }
    /*
    每个人物有不同长度的动画 那么标准API不能静态的处理 只能依赖于custom 但是这个效率比较低
    所以可以设定所有人物动画长度相同
    */
    function setDir()
    {
        var difx = tar[0] - bg.pos()[0];
        if(difx < 0)
            bg.scale(showSize, showSize);
        else
            bg.scale(-showSize, showSize);
    }
    function showInspire()
    {
        if(inspire == 1)
        {
            var bsize = bg.size();
            inspirePic = bg.addsprite("soldierMorale.png").pos(bsize[0]/2, -5).anchor(50, 100);
        }
    }
    var inspireTime = 0;
    //士兵当前占用的map映射格子 
    var curMap = null;
    function update(diff)
    {
        if(inspire == 0)
        {
            inspireTime += diff;
            if(inspireTime >= 10000)
            {
                inspire = 1;
                showInspire();
            }
        }
        if(state == SOL_FREE)
        {
            tar = getTar();
            //trace("moveTarPos", tar);
            if(tar != null)
            {
                state = SOL_MOVE; 
                global.user.clearMap(this);
                curMap = global.user.updatePosMap([sx, sy, tar[0], tar[1], this]);
                //cus.enterScene();
                bg.addaction(movAni);
                setDir();
            }
        }
        else if(state == SOL_MOVE)
        {
            shiftAni.stop();
            //var all = mobj.moveToTar(bg.pos(), tar, diff);
            var oldPos = bg.pos();
            //setPos([oldPos[0]+all[0], oldPos[1]+all[1]]);
            setPos(oldPos);
            var dist = distance(bg.pos(), tar);
            if(oldPos[0] == tar[0] && oldPos[1] == tar[1])
            {
                movAni.stop();
                state = SOL_FREE;
                return;
            }
            var t = dist*100/speed;
            //trace("moveTime", t);
            shiftAni = moveto(t, tar[0], tar[1]);
            bg.addaction(shiftAni);
            //state= SOL_WAIT;
        }
        //休息一段时间
        else if(state == SOL_WAIT)
        {
        }
    }
    /*
    一个对象清空map状态的时候需要清除相应地图块的士兵和建筑物
    */
    function setColPos()
    {
    }
    override function exitScene()
    {
        map.solTimer.removeTimer(this);
        /*
        if(cus != null)
        {
            cus.exitScene();
        }
        */
        super.exitScene();
    }
    override function setPos(p)
    {
        bg.pos(p);
        var par = bg.parent();
        if(par != null)
        {
            bg.removefromparent();
            var zOrd = p[1];
            par.add(bg, zOrd);
        }
    }
    
}
