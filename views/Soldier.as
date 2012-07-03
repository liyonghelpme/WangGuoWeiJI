


//default left
/*
布局的时候 拖出 0-24 的范围就认为是归还给系统
*/
class Soldier extends MyNode
{
    //base 由属性决定的 生命值 攻击力 防御力
    //转职增加 大量的属性 包括一些静态属性  攻击速度 攻击范围 生命回复速度 这个由职业属性决定
    //士兵攻击力 = 基础职业攻击力 + 等级对应增加攻击力 + 装备属性攻击力
    //士兵生命回复速度 = 基础职业回复速度
    //士兵攻击范围 = 基础职业范围 + 装备范围
    //士兵防御力 = 基础职业防御力 + 等级对应防御力 + 装备属性防御力
    //士兵生命值 = 基础职业生命值 + 等级对应生命值 + 装备增加生命值

    var map;
    var color;
    var state;
    var tar = null;
    //10000ms 2000*100
    const SPE = 20;
    var speed = 5;
    var lastPoints;
    //var mobj;
    /*
    data:
    color kind
    */
    var movAni;
    var attAni;
    var shiftAni;

    var id;
    //var cus;
    var shadow;
    var kind;
    var funcSoldier;
    var data;

    var health = 100;
    var healthBoundary = 100;

    //var attacker = null;


    const CLOSE_FIGHTING = 0;
    const LONG_DISTANCE = 1;
    const MAGIC = 2;

    /*
    移动动画似乎有些卡
    移动动画7帧
    攻击动画8帧
    */
    var closeIcon;
    var sid;

    //[color kindId] 只有在受到攻击的时候才会显示血条 一会接着消失
    var bloodBanner;

    var bloodTotalLen = 134;
    var bloodHeight = 9;
    var bloodScaX = 72*100/139;//根据怪兽的体积计算血条长度 
    var bloodScaY = 9*100/12;

    var gainexp = 100;//杀死该士兵总的经验
    var hurts = dict();//其它士兵对自己造成的伤害 士兵sid 伤害
    var exp = 0;

    var changeDirNode;
    var sx = 1;
    var sy = 1;

    var attack = 100;
    var defense = 50;
    var attRange = 100;
    //var soldierKind = 0;

    var level = 5;
    var myName;
    var dead;

    //攻击速度 
    function initData()
    {
        sx = data.get("sx");
        sy = data.get("sy");
        gainexp = data.get("gainexp");
        attSpeed = data.get("attSpeed");


        if(sid == -1)//敌对方士兵 地图怪兽 
        {
            level = 0;
            attack = data.get("attack")+level*data.get("addAttack");
            defense = data.get("defense")+level*data.get("addDefense");
            attRange = data.get("range");

            setHealthBoundary();
            health = healthBoundary;

            myName = null;
            dead = 0;

        }
        else
        {
            var privateData = global.user.getSoldierData(sid);
            level = privateData.get("level", 0);

            attack = data.get("attack")+level*data.get("addAttack");
            defense = data.get("defense")+level*data.get("addDefense");

            var equips = global.user.getSoldierEquip(sid);
            for(var i = 0; i < len(equips); i++)
            {
                var e = getData(EQUIP, equips[i]);
                attack += e.get("attack");
                defense += e.get("defense");
            }
            
            attRange = data.get("range");

            setHealthBoundary();
            health = privateData.get("health", healthBoundary);
            health = min(health, healthBoundary);

            myName = privateData.get("name");
            dead = 0;
        }
    }
    function setHealthBoundary()
    {
        healthBoundary = data.get("health")+level*data.get("addHealth");
    }

    function isMySoldier()
    {
        return color == 0;
    }
    var attSpeed;
    function Soldier(m, d, s)
    {
        sid = s;
        map = m;
        color = d[0];
        id = d[1];//士兵类型id
        //movAni = getMoveAnimate(id);
        var colStr = "red";
        if(color == 1)
            colStr = "blue";
        load_sprite_sheet("soldierm"+str(id)+colStr+".plist");
        load_sprite_sheet("soldiera"+str(id)+colStr+".plist");

        movAni = repeat(animate(1500, "soldierm"+str(id)+colStr+".plist/ss"+str(id)+"m0.png", "soldierm"+str(id)+colStr+".plist/ss"+str(id)+"m1.png","soldierm"+str(id)+colStr+".plist/ss"+str(id)+"m2.png","soldierm"+str(id)+colStr+".plist/ss"+str(id)+"m3.png","soldierm"+str(id)+colStr+".plist/ss"+str(id)+"m4.png","soldierm"+str(id)+colStr+".plist/ss"+str(id)+"m5.png","soldierm"+str(id)+colStr+".plist/ss"+str(id)+"m6.png", UPDATE_SIZE));
        //attAni = getAttAnimate(id);
        //1500 ms攻击一次 
        //经营页面回复生命值 60s 一次

        data = getData(SOLDIER, id);
        initData();

        attAni = sequence(animate(attSpeed, "soldiera"+str(id)+colStr+".plist/ss"+str(id)+"a0.png", "soldiera"+str(id)+colStr+".plist/ss"+str(id)+"a1.png","soldiera"+str(id)+colStr+".plist/ss"+str(id)+"a2.png","soldiera"+str(id)+colStr+".plist/ss"+str(id)+"a3.png","soldiera"+str(id)+colStr+".plist/ss"+str(id)+"a4.png","soldiera"+str(id)+colStr+".plist/ss"+str(id)+"a5.png","soldiera"+str(id)+colStr+".plist/ss"+str(id)+"a6.png","soldiera"+str(id)+colStr+".plist/ss"+str(id)+"a7.png", UPDATE_SIZE));//, callfunc(finAttack)

        shiftAni = moveto(0, 0, 0);



        kind = data.get("kind");
        if(kind == CLOSE_FIGHTING)
        {
            funcSoldier = new CloseSoldier(this);
        }
        else if(kind == LONG_DISTANCE)
        {
            funcSoldier = new LongDistanceSoldier(this);
        }
        else if(kind == MAGIC)
        {
            funcSoldier = new MagicSoldier(this);
        }

        state = MAP_SOL_ARRANGE;


        //replaceStr(KindsPre[SOLDIER], ["[ID]", str(id)])
        /*
        依赖士兵的位置 计算都采用changeDirNode
        getSolMap getSolPos
        bg 的大小 和 士兵图片完全相同
        切换方向 只切换changeNode
        */
        //bg = sprite("soldierm"+str(id)+".plist/ss"+str(id)+"m0.png").anchor(50, 100).pos(102, 186);
        bg = node();
        changeDirNode = bg.addsprite("soldierm"+str(id)+colStr+".plist/ss"+str(id)+"m0.png").anchor(50, 100);
        changeDirNode.prepare();
        var bSize = changeDirNode.size();

        bg.size(bSize).anchor(50, 100).pos(102, 186);
        changeDirNode.pos(bSize[0]/2, bSize[1]);


        shadow = sprite("roleShadow.png").pos(bSize[0]/2, bSize[1]).anchor(50, 50).size(data.get("shadowSize"), 32);
        changeDirNode.add(shadow, -1);
        init();

        var vol = data.get("volumn");
        if(vol > MIN_VOL && vol < MID_VOL)
        {
            bloodScaX = 120*100/139;//大体积 采用144的长度 中等体积 采用普通长度    
        }
        if(vol > MID_VOL)
        {
            bloodScaX = 150*100/139;
        }

        var banner = bg.addsprite("mapSolBloodBan.png").pos(bSize[0]/2, -10).anchor(50, 100).scale(bloodScaX, bloodScaY);
        bloodBanner = banner.addsprite("mapSolBlood.png").pos(2, 2);

    
        closeIcon = bg.addsprite("buildCancel.png").pos(bSize[0]/2, -10).anchor(50, 100);
        if(color == 0)
            closeIcon.setevent(EVENT_TOUCH, onCancel);
        else
            closeIcon.visible(0);


        initHealth();

        setDir();

        bg.setevent(EVENT_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }
    var attTime = 0;
    function getLevelUp()
    {
        var expId = data.get("expId");
        for(; 1; )
        {
            var ne = getLevelNeedExp(expId, level);
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
    function getKind()
    {
        return kind;
    }

    /*
    士兵升级需要的经验如何表示每种类型的士兵
    例如剑士 系列 ----> 升级需要的经验是 *2 增加
    0kindId ---->20 50 30 60 80 90 100
    10

    只在闯关结束之后 更新所有参战士兵的数据
    经验 等级 生命值 死亡状态 类型
    */

    function changeExp(e)
    {
        trace("changeExp", e);
        exp += e; 
        
        /*
        var needExp = soldierLevelExp.get(data.get("expId"));
        var ne = needExp[len(needExp)-1];
        if(level < len(needExp))//从0级开始
            ne = needExp[level];
        //升级之后清空旧的经验 更新士兵动态数 
        if(exp >= ne)
        {
            exp = 0;
            level += 1;
        }
        */

        //global.user.updateSoldiers(this);
        if(state != MAP_SOL_DEAD)
        {
            var temp = bg.addnode();
            temp.addsprite("exp.png").anchor(0, 50).pos(0, -30).size(30, 30);
            temp.addlabel("+"+str(e), null, 25).anchor(0, 50).pos(35, -30).color(0, 0, 0);
            temp.addaction(sequence(moveby(500, 0, -40), fadeout(1000), callfunc(removeTempNode)));
        }
    }
    function initHealth()
    {
        var sx = bloodTotalLen*health/healthBoundary;
        bloodBanner.size(sx, bloodHeight);
    }

    //不能在callfunc中调用
    //士兵 伤害
    //生命值 < 0 表示死亡
    //死亡之后复活的生命值 >= 0
    function changeHealth(sol, add)
    {
        var val = hurts.get(sol.sid, [sol, 0]);
        val[1] += add;
        hurts.update(sol.sid, val);

        health += add;

        var sx = bloodTotalLen*max(health, 0)/healthBoundary;
        bloodBanner.size(sx, bloodHeight);
        
        var cs = changeDirNode.size();
        if(sol.kind == 0 || sol.kind == 1)//近战远程 物理溅血
        {
            var bl = sprite().pos(50, 50).pos(cs[0]/2, cs[1]/2).addaction(sequence(animate(700, "hurt0.png", "hurt1.png","hurt2.png","hurt3.png","hurt4.png","hurt5.png","hurt6.png", UPDATE_SIZE), callfunc(removeTempNode)));
            changeDirNode.add(bl, 10);
        }
        else//魔法攻击显示变色
        {
            changeDirNode.addaction(sequence(tintto(500, 100, 0, 0), tintto(500, 100, 100, 100)));        
        }
        var bSize = bg.size();
        //bg 的size和图片的size大小相同
        bg.addlabel(str(add), null, 30).pos(bSize[0]/2, -5).color(100, 0, 0).anchor(50, 100).addaction(sequence(moveby(1000, 0, -20), callfunc(removeTempNode)));
    }

    function onCancel()
    {
        map.clearSoldier(this); 
    }

    var inMoving = 0;
    function finMov()
    {
        inMoving = 0;
    }
    var inAttacking = 0;
    function finAttack()
    {
        inAttacking = 0;
    }
    var oldPos = null;
    /*
    移动清除旧的map 
    */
    function touchBegan(n, e, p, x, y, points)
    {
        if(state != MAP_SOL_ARRANGE)
        {
            state = MAP_SOL_TOUCH;
            clearAnimation();
        }
        oldPos = getPos();
        lastPoints = n.node2world(x, y);
        lastPoints = bg.parent().world2node(lastPoints[0], lastPoints[1]);
        map.clearMap(this);
    }
    function setCol()
    {
        var col = map.checkCol(this);
        if(col != null)
            bg.color(93, 4, 1, 30);
        else
            bg.color(100, 100, 100, 100);
    }
    /*
    移动的新位置必须和格子对齐
    判断冲突 检测地图状态
    */
    function touchMoved(n, e, p, x, y, points)
    {
        var oldPos = lastPoints;
        lastPoints = n.node2world(x, y);
        lastPoints = bg.parent().world2node(lastPoints[0], lastPoints[1]);
        //var nPos = normalizeSoldierPos(lastPoints);
        if(color == 0)
        {
            var newMap = getPosSolMap(lastPoints, sx, sy);
            //移动位置不能超过边界
            newMap[0] = max(1, min(6-sx, newMap[0]));
            newMap[1] = max(0, min(5-sy, newMap[1]));
            var nPos = getSolPos(newMap[0], newMap[1], sx, sy);
            setPos(nPos);
            setCol();
        }
    }
    /*
    设定新的map
    */
    function touchEnded(n, e, p, x, y, points)
    {
        if(state != MAP_SOL_ARRANGE)
            state = MAP_SOL_FREE; 
        var col = map.checkCol(this);
        if(col != null)
            setPos(oldPos);
        setCol();//清理冲突状态
        map.setMap(this);
    }
    var addedYet = 0;
    /*
    检测是否已经加入了我方士兵列表如果没有则加入map的我方士兵列表
    */
    function addToMySol()
    {
        if(addedYet == 0)
        {
            addedYet = 1;
            return 0;
        }
        return 1;
    }
    function finishArrage()
    {
        state = MAP_SOL_FREE;
        if(closeIcon != null)
        {
            closeIcon.removefromparent();
            closeIcon = null;
        }
    }
    function setDir()
    {
        if(tar == null)
        {
            if(color == 0)
                changeDirNode.scale(-100, 100);
            else
                changeDirNode.scale(100, 100);
        }
        else
        {
            var tpos = tar.getPos();
            var mpos = bg.pos();
            var difx = tpos[0] - mpos[0];
            if(difx > 0)
            {
                changeDirNode.scale(-100, 100);
            }
            else
            {
                changeDirNode.scale(100, 100);
            }
        }
    }
    /*
    攻击最近的同一条线的对象
    攻击不同线的敌人
    攻击第二近的敌人
    确认了目标 但是还需要 一步一步的移动
    */
    function getTar()
    {
        //同一条线的敌方对象 面前纵格子的对象 
        //如何有纵向的范围攻击 
        var myMap = getSolMap(getPos(), sx, sy);
        var minDist = 10000;
        var minTar = null;
        for(var j = 0; j < sy; j++)
        {
            var t = map.soldiers.get(myMap[1]+j);//row  Soldiers
            //trace("my tar", this, t);
            //var posible = [];

            trace("myTar", t, myMap);
            for(var i = 0; i < len(t); i++)
            {
                trace("eneColor", t[i].color, t[i].state);
                if(t[i].color == color || t[i].state == MAP_SOL_DEAD)
                    continue;
                var p = t[i].getPos();
                var dist = abs(bg.pos()[0]-p[0]);   
                if(dist < minDist)
                {
                    minDist = dist;
                    minTar = t[i];
                }
            }
        }
        return minTar;
    }
    override function setPos(p)
    {
        var zOrd = p[1];
        bg.pos(p);
        var par = bg.parent();
        bg.removefromparent();
        if(par != null)
            par.add(bg, zOrd);
    }
    function clearAnimation()
    {
        movAni.stop();
        attAni.stop();
        inAttacking = 0;
    }
    function getVolumn()
    {
        return data.get("volumn");
    }
    var deadTime = 0;
    const DEAD_TIME = 4000;
    var deadYet = 0;
    var stopNow = 0;
    function stopGame()
    {
        stopNow = 1;
        shiftAni.stop();
    }
    function continueGame()
    {
        stopNow = 0;
    }
    function update(diff)
    {
        //trace("update soldier", diff, state, tar);
        //布局阶段  
        var tPos;
        var dist;
        if(stopNow == 1)
            return;
        if(health < 0 && state != MAP_SOL_DEAD)
        {
            dead = 1;
            health = 0;
            global.user.updateSoldiers(this);
            
            state = MAP_SOL_DEAD;
            shadow.removefromparent();

            shiftAni.stop();
            clearAnimation();

            changeDirNode.texture("soldier"+str(id)+"dead.png", UPDATE_SIZE);
            //增加血液
            var cs = bg.size();
            var blood = sprite("blood.png").anchor(50, 50).pos(cs[0]/2, cs[1]);
            bg.add(blood, -1);
            deadTime = 0;

            changeDirNode.addaction(fadeout(2000));
            blood.addaction(fadeout(DEAD_TIME));

            var par = bg.parent();
            bg.removefromparent();
            par.add(bg, MIN_SOL_ZORD);
            tar = null;
            //增加经验
            deadTime = 0;
            map.calHurts(this);
        }
        if(state == MAP_SOL_ARRANGE)
        {
        }
        else if(state == MAP_SOL_FREE)
        {
            tar = getTar();
            trace("free tar", tar);
            if(tar != null)
            {
                clearAnimation();
                changeDirNode.addaction(movAni);

                setDir();
                state = MAP_SOL_MOVE;
            }
        }
        else if(state == MAP_SOL_MOVE)
        {
            shiftAni.stop();

            tPos = tar.getPos();
            dist = abs(bg.pos()[0]-tPos[0]);//同一行 
            if((dist-tar.getVolumn()) <= attRange)//攻击范围
            {
                //trace("mePos tarPos", bg.pos(), tPos, tar.getVolumn(), attRange );
                state = MAP_SOL_ATTACK;
                clearAnimation();
                //inAttacking = 1;
                changeDirNode.addaction(attAni);
                return;
            }
            
            //在前方存在冲突对象不能移动
            var colObj = map.checkDirCol(this, tar);
            //trace("colObj", colObj);
            if(colObj != null)
            {
                //trace("col now", bg.pos(), colObj.getPos());
                return;
            }
            var t = dist*100/speed;
            shiftAni = moveto(t, tPos[0], bg.pos()[1]); 
            bg.addaction(shiftAni);
        }
        else if(state == MAP_SOL_TOUCH)
        {
            tar = null;
            clearAnimation();
            changeDirNode.addaction(movAni);
            state = MAP_SOL_WATI_TOUCH; 
        }
        /*
        inAttacking = 0 攻击动画结束 ---> 计算伤害 --->重新启动动画
        */
        else if(state == MAP_SOL_ATTACK)
        {
            if(tar.state == MAP_SOL_DEAD)
            {
                state = MAP_SOL_FREE;
                clearAnimation();
                tar = null;
                return;
            }
            tPos = tar.getPos();
            dist = abs(tPos[0]-bg.pos()[0]);
            if((dist- tar.getVolumn())> attRange)
            {
                clearAnimation();
                changeDirNode.addaction(movAni);
                setDir();
                state = MAP_SOL_MOVE; 
                return;
            }
            attTime += diff;
            if(attTime >= attSpeed)
            {
                funcSoldier.doAttack();
                clearAnimation();
                changeDirNode.addaction(attAni);
                attTime -= attSpeed;
            }
            /*
            if(inAttacking == 0)
            {
                funcSoldier.doAttack();
                clearAnimation();
                inAttacking = 1;
                changeDirNode.addaction(attAni);
            }
            */
        }
        else if(state == MAP_SOL_WATI_TOUCH)
        {
        }
        /*
        死亡后士兵实体并不会消失
        保存在其它士兵的hurts 列表中 清空自身的hurt列表
        */
        else if(state == MAP_SOL_DEAD)
        {
            deadTime += diff;
            if(deadTime >= DEAD_TIME && deadYet == 0)
            {
                deadYet = 1;
                map.soldierDead(this); 
                hurts = null;
            }
        }

    }
    override function enterScene()
    {
        trace("map", map, map.myTimer);
        super.enterScene();   
        map.myTimer.addTimer(this);
    }
    override function exitScene()
    {
        map.myTimer.removeTimer(this);
        //cus.exitScene();
        super.exitScene();   
    }
}
