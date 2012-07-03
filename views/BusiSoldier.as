class BusiSoldier extends MyNode
{
    var isBuilding = 0;
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
    var attSpeed;
    var attRange;
    
    var exp;
    var dead;
    var level;
    const showSize = 50;

    var recoverSpeed;
    //当前只有士兵才有特征色
    //var featureColor;
    //var featureMov;


    /*
    需要在行走的时候开始动画
    updateMap 是view相关数据是由动作生成的
    战斗页面生命值不能回复 只有在经营页面生命值才回复
    用户在游戏中 才回复 还是 上次回复的时间计算生命值回复时间
    战斗中不会计算生命值回复

    生命值上限 由 基础职业+等级增加+装备

    等级分成两种：
    职业等级
    普通等级

    攻击速度1500 慢 1000 中等 500 快
    */
    function initData(privateData)
    {
        if(privateData == null)
            privateData = dict();

        level = privateData.get("level", 0);
        setHealthBoundary();
        //healthBoundary = data.get("health")+level*data.get("addHealth");
        health = privateData.get("health", healthBoundary);//新购买的士兵生命值满 
        
        //healthBoundary = privateData.get("healthBoundary", 0); 


        //attack = privateData.get("attack", 0); 
        //defense = privateData.get("defense", 0); 
        exp = privateData.get("exp", 0);
        dead = privateData.get("dead", 0);
        
        initAttackAndDefense();
        recoverSpeed = data.get("recoverSpeed")*1000;

        attSpeed = data.get("attSpeed");
        attRange = data.get("range");
    }
    var recoverTime = 0;
    function initAttackAndDefense()
    {
        attack = data.get("attack")+level*data.get("addAttack");
        defense = data.get("defense")+level*data.get("addDefense");
        
        var equips = global.user.getSoldierEquip(sid);
        for(var i = 0; i < len(equips); i++)
        {
            var e = getData(EQUIP, equips[i]);
            attack += e.get("attack");
            defense += e.get("defense");
        }
    }

    //攻击药水 防御药水 在闯关的1个回合中暂时提升士兵能力
    function useDrug(tid)
    {
        var dd = getData(DRUG, tid);    
        health += dd.get("health");
        health = min(healthBoundary, health);
        //exp += dd.get("exp");
        changeExp(dd.get("exp"));
        global.user.updateSoldiers(this);
    }
    //参数  -1 表示去掉某件装备
    //其它表示 装备某个类型的装备
    function useEquip(tid)
    {
        initAttackAndDefense();
        global.user.updateSoldiers(this);
    }
    /*
    计算士兵的转职需要等级 但是怪兽不能转职100-190
    士兵0-90 可以转职 0 1 2 3
    */
    function getTransferLevel()
    {
        var proLevel = id%10;
        if(proLevel < 3 && id < 100)
        {
            return (proLevel+1)*5;
        }
        return 0;
    }

    function updateStaticData(d)
    {
        data = d;
        id = data.get("id");
        var colStr = "red";
        load_sprite_sheet("soldierm"+str(id)+colStr+".plist");
        changeDirNode.texture("soldierm"+str(id)+colStr+".plist/ss"+str(id)+"m0.png");
        if(movAni != null)
        {
            movAni.stop();
            //featureMov.stop();
        }
        movAni = repeat(animate(1500, "soldierm"+str(id)+colStr+".plist/ss"+str(id)+"m0.png", "soldierm"+str(id)+colStr+".plist/ss"+str(id)+"m1.png","soldierm"+str(id)+colStr+".plist/ss"+str(id)+"m2.png","soldierm"+str(id)+colStr+".plist/ss"+str(id)+"m3.png","soldierm"+str(id)+colStr+".plist/ss"+str(id)+"m4.png","soldierm"+str(id)+colStr+".plist/ss"+str(id)+"m5.png","soldierm"+str(id)+colStr+".plist/ss"+str(id)+"m6.png"));

    }
    //杀死该士兵后
    //view 消失 user 场景对象消失
    function killMonster()
    {
        dead = 1;
        global.user.updateSoldiers(this);//更新死亡状态
        map.removeChild(this); 
    }
    //闯关页面士兵死亡  经营页面 在进入场景的时候会根据数据重新生成士兵

    function doTrain()
    {
        //killMonster();
    }
    var changeDirNode;
    /*
    所有和bg 相关的 需要改变方向的需要修改成changeDirNode
    改变纹理的movAni
    改变方向的setDir
    改变位置的shift不变
    添加子节点不变
    */
    function BusiSoldier(m, d, privateData, s)
    {
        sid = s;
        data = d;
        map = m;
        id = data.get("id");
        var colStr = "red";
        load_sprite_sheet("soldierm"+str(id)+colStr+".plist");

        bg = node().scale(showSize);
        init();
        changeDirNode = bg.sprite("soldierm"+str(id)+colStr+".plist/ss"+str(id)+"m0.png").anchor(50, 100);

        var bSize = changeDirNode.prepare().size();
        bg.size(bSize).anchor(50, 100).pos(465, 720);
        changeDirNode.pos(bSize[0]/2, bSize[1]);

        shadow = sprite("roleShadow.png").pos(bSize[0]/2, bSize[1]).anchor(50, 50).size(data.get("shadowSize"), 32);

        changeDirNode.add(shadow, -1);
        initData(privateData);


        var nPos = normalizePos(bg.pos(), sx, sy);
        setPos(nPos);
        curMap = global.user.updateMap(this);

        movAni = repeat(animate(1500, "soldierm"+str(id)+colStr+".plist/ss"+str(id)+"m0.png", "soldierm"+str(id)+colStr+".plist/ss"+str(id)+"m1.png","soldierm"+str(id)+colStr+".plist/ss"+str(id)+"m2.png","soldierm"+str(id)+colStr+".plist/ss"+str(id)+"m3.png","soldierm"+str(id)+colStr+".plist/ss"+str(id)+"m4.png","soldierm"+str(id)+colStr+".plist/ss"+str(id)+"m5.png","soldierm"+str(id)+colStr+".plist/ss"+str(id)+"m6.png"));
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
        global.director.pushView(new SellDialog(this), 1, 0);
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
        //exp += 100;
        changeExp(10);
        global.user.updateSoldiers(this);
        var nPos = bg.node2world(0, -10);
        global.director.curScene.addChild(new TrainBanner(nPos, 100));
    }
    /*
    被其它内部函数调用 更新士兵数据库 由其它函数进行
    士兵的bg 应该和changeDirNode 区分开来
    */
    function setHealthBoundary()
    {
        healthBoundary = data.get("health")+level*data.get("addHealth");
    }
    function changeExp(add)
    {
        exp += add;
        var ne = getLevelNeedExp(data.get("expId"), level);
        if(exp >= ne)
        {
            for(; 1; )
            {
                var ne = getLevelNeedExp(data.get("expId"), level);
                if(exp >= ne)
                {
                    exp -= ne;
                    level += 1;
                }
                else 
                    break;
            }
            setHealthBoundary();
            health = healthBoundary;
        }

        var temp = bg.addnode();
        temp.addsprite("exp.png").anchor(0, 50).pos(0, -30).size(30, 30);
        temp.addlabel("+"+str(add), null, 25).anchor(0, 50).pos(35, -30).color(0, 0, 0);
        temp.addaction(sequence(moveby(500, 0, -40), fadeout(1000), callfunc(removeTempNode)));
    }

    /*
    修改士兵的id
    修改士兵的攻击力 防御力 经验
    修改士兵的显示状态
    */
    function doTransfer()
    {
        var proLevel = id%10;
        if(proLevel < 3 && (proLevel+1)*5 <= level && id < 100)//每5级可以转职一次
        {
        //改变形象bg  改变数据 id 
            id += 1;
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
            [map[0]+0, map[1]+-2],
            [map[0]+-1, map[1]+-1],
            [map[0]+-2, map[1]+0],
            [map[0]+-1, map[1]+1],
            [map[0]+0, map[1]+2],
            [map[0]+1, map[1]+1],
            [map[0]+2, map[1]+0],
            [map[0]+1, map[1]+-1],
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
            changeDirNode.scale(showSize, showSize);
        else
            changeDirNode.scale(-showSize, showSize);
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
    function doMove()
    {
        shiftAni.stop();
        var oldPos = bg.pos();
        setPos(oldPos);
        var dist = distance(bg.pos(), tar);
        if(oldPos[0] == tar[0] && oldPos[1] == tar[1])
        {
            movAni.stop();
            //featureMov.stop();
            state = SOL_FREE;
            return;
        }
        var t = dist*100/speed;
        shiftAni = moveto(t, tar[0], tar[1]);
        bg.addaction(shiftAni);
    }
    function update(diff)
    {
        recoverTime += diff;
        if(recoverTime >= recoverSpeed)
        {
            health += 1;
            health = min(health, healthBoundary);
            recoverTime = 0;
        }
        if(inspire == 0)
        {
            inspireTime += diff;
            if(inspireTime >= 10000)
            {
                inspire = 1;
                showInspire();
            }
        }

        if(showMenuYet == 1)//显示全局菜单停止移动
            return;

        if(state == SOL_FREE)
        {
            tar = getTar();
            //trace("moveTarPos", tar);
            if(tar != null)
            {
                state = SOL_MOVE; 
                global.user.clearMap(this);
                curMap = global.user.updatePosMap([sx, sy, tar[0], tar[1], this]);
                changeDirNode.addaction(movAni);
                //featureColor.addaction(featureMov);
                setDir();
                doMove();
            }
        }
        else if(state == SOL_MOVE)
        {
            doMove();
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
