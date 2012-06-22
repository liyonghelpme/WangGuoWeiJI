class MagicSoldier
{
    var sol;
    function MagicSoldier(s)
    {
        sol = s;
    }
    function doAttack()
    {
        sol.map.addChildZ(new Magic(sol, sol.tar), MAX_BUILD_ZORD);
    }
}
class LongDistanceSoldier
{
    var sol;

    function LongDistanceSoldier(s)
    {
        sol = s;
    }
    function doAttack()
    {
        sol.map.addChildZ(new Arrow(sol, sol.tar), MAX_BUILD_ZORD);
    }
}
class CloseSoldier 
{
    var sol;
    function CloseSoldier(s)
    {
        sol = s;
    }
    function doAttack()
    {
        if(sol.tar != null)
            sol.tar.changeHealth(-1);
    }
}
//default left
/*
布局的时候 拖出 0-24 的范围就认为是归还给系统
*/
class Soldier extends MyNode
{
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
    var healthBound = 100;

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

    //[color kindId]
    var bloodBanner;

    var bloodTotalLen = 134;
    var bloodHeight = 9;
    var bloodScaX = 72*100/139;
    var bloodScaY = 9*100/12;
    function Soldier(m, d)
    {
        map = m;
        color = d[0];
        id = d[1];
        //movAni = getMoveAnimate(id);
        load_sprite_sheet("soldierm"+str(id)+".plist");
        load_sprite_sheet("soldiera"+str(id)+".plist");

        movAni = repeat(animate(1500, "soldierm"+str(id)+".plist/ss"+str(id)+"m0.png", "soldierm"+str(id)+".plist/ss"+str(id)+"m1.png","soldierm"+str(id)+".plist/ss"+str(id)+"m2.png","soldierm"+str(id)+".plist/ss"+str(id)+"m3.png","soldierm"+str(id)+".plist/ss"+str(id)+"m4.png","soldierm"+str(id)+".plist/ss"+str(id)+"m5.png","soldierm"+str(id)+".plist/ss"+str(id)+"m6.png", UPDATE_SIZE));
        //attAni = getAttAnimate(id);
        attAni = sequence(animate(1500, "soldiera"+str(id)+".plist/ss"+str(id)+"a0.png", "soldiera"+str(id)+".plist/ss"+str(id)+"a1.png","soldiera"+str(id)+".plist/ss"+str(id)+"a2.png","soldiera"+str(id)+".plist/ss"+str(id)+"a3.png","soldiera"+str(id)+".plist/ss"+str(id)+"a4.png","soldiera"+str(id)+".plist/ss"+str(id)+"a5.png","soldiera"+str(id)+".plist/ss"+str(id)+"a6.png","soldiera"+str(id)+".plist/ss"+str(id)+"a7.png", UPDATE_SIZE), callfunc(finAttack));

        shiftAni = moveto(0, 0, 0);

        data = getData(SOLDIER, id);
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
        bg = sprite("soldierm"+str(id)+".plist/ss"+str(id)+"m0.png").anchor(50, 100).pos(102, 186);
        bg.prepare();
        var bSize = bg.size();
        shadow = sprite("roleShadow.png").pos(bSize[0]/2, bSize[1]).anchor(50, 50);
        bg.add(shadow, -1);
        init();

        closeIcon = bg.addsprite("buildCancel.png").pos(bSize[0]/2, -20).anchor(50, 100).setevent(EVENT_TOUCH, onCancel);

        var banner = bg.addsprite("mapMenuBloodBan.png").pos(bSize[0]/2, -10).anchor(50, 100).scale(bloodScaX, bloodScaY);
        bloodBanner = banner.addsprite().pos(2, 2);
        changeHealth(0);

        setDir();

        bg.setevent(EVENT_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }

    function changeHealth(add)
    {
        health += add;
        var sx = health*100/healthBound*bloodTotalLen;
        bloodBanner.size(sx, bloodHeight);
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
            state = MAP_SOL_TOUCH;
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
            var newMap = getPosSolMap(lastPoints);
            newMap[0] = max(1, min(5, newMap[0]));
            newMap[1] = max(0, min(4, newMap[1]));
            var nPos = getSolPos(newMap[0], newMap[1]);
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
    function finishArrage()
    {
        state = MAP_SOL_FREE;
        closeIcon.removefromparent();
        closeIcon = null;
    }
    function setDir()
    {
        if(tar == null)
        {
            if(color == 0)
                bg.scale(-100, 100);
            else
                bg.scale(100, 100);
        }
        else
        {
            var tpos = tar.getPos();
            var mpos = bg.pos();
            var difx = tpos[0] - mpos[0];
            if(difx > 0)
            {
                bg.scale(-100, 100);
            }
            else
            {
                bg.scale(100, 100);
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
        //同一条线的敌方对象
        var myMap = getSolMap(getPos());
        var t = map.soldiers.get(myMap[1]);
        //trace("my tar", this, t);
        var posible = [];
        var minDist = 10000;
        var minTar = null;
        for(var i = 0; i < len(t); i++)
        {
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
    function update(diff)
    {
        //trace("update soldier", diff, state, tar);
        //布局阶段  
        var tPos;
        var dist;
        if(health <= 0 && state != MAP_SOL_DEAD)
        {
            state = MAP_SOL_DEAD;
            shadow.removefromparent();
            clearAnimation();
            bg.texture("soldier"+str(id)+"dead.png", UPDATE_SIZE);
            var par = bg.parent();
            bg.removefromparent();
            par.add(bg, MIN_SOL_ZORD);
            tar = null;
        }
        if(state == MAP_SOL_ARRANGE)
        {
        }
        else if(state == MAP_SOL_FREE)
        {
            tar = getTar();
            if(tar != null)
            {
                clearAnimation();
                bg.addaction(movAni);

                setDir();
                state = MAP_SOL_MOVE;
            }
        }
        else if(state == MAP_SOL_MOVE)
        {
            shiftAni.stop();

            tPos = tar.getPos();
            dist = abs(bg.pos()[0]-tPos[0]);//同一行 
            if((dist-tar.getVolumn()) <= data.get("range"))//攻击范围
            {
                state = MAP_SOL_ATTACK;
                clearAnimation();
                inAttacking = 1;
                bg.addaction(attAni);
                return;
            }
            
            //在前方存在冲突对象不能移动
            var colObj = map.checkDirCol(this, tar);
            trace("colObj", colObj);
            if(colObj != null)
            {
                trace("col now", bg.pos(), colObj.getPos());
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
            bg.addaction(movAni);
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
            if((dist- tar.getVolumn())> data.get("range"))
            {
                clearAnimation();
                bg.addaction(movAni);
                setDir();
                state = MAP_SOL_MOVE; 
                return;
            }
            if(inAttacking == 0)
            {
                funcSoldier.doAttack();
                clearAnimation();
                inAttacking = 1;
                bg.addaction(attAni);
            }
        }
        else if(state == MAP_SOL_WATI_TOUCH)
        {
        }
        else if(state == MAP_SOL_DEAD)
        {
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
