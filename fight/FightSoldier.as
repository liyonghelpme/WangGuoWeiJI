/*
checkPosCollision
clearMap
根据uid 作为键寻找
*/
class FightSoldier extends MoveSoldier
{
    var privateData;
    var nameBanner;
    var isArena = 0;

    function FightSoldier(m, pri, a)
    {
        map = m;
        privateData = pri;
        id = 0;
        isArena = a;

        data = getData(SOLDIER, id);
        bg = node().scale(showSize);
        init();

        load_sprite_sheet("soldierm"+str(id)+".plist");
        
        changeDirNode = bg.addsprite("soldierm"+str(id)+".plist/ss"+str(id)+"m0.png").anchor(50, 100);

        var bSize = changeDirNode.prepare().size();

        var rx = rand(map.moveZone[0][2]-100)+map.moveZone[0][0]+50;
        var ry = rand(map.moveZone[0][3]-100)+map.moveZone[0][1]+50;

        bg.size(bSize).anchor(50, 100).pos(rx, ry);
        

        changeDirNode.pos(bSize[0]/2, bSize[1]);
        shadow = sprite("roleShadow.png").pos(bSize[0]/2, bSize[1]).anchor(50, 50).size(data.get("shadowSize"), 32);

        changeDirNode.add(shadow, -1);

        movAni = repeat(animate(1500, "soldierm"+str(id)+".plist/ss"+str(id)+"m0.png", "soldierm"+str(id)+".plist/ss"+str(id)+"m1.png","soldierm"+str(id)+".plist/ss"+str(id)+"m2.png","soldierm"+str(id)+".plist/ss"+str(id)+"m3.png","soldierm"+str(id)+".plist/ss"+str(id)+"m4.png","soldierm"+str(id)+".plist/ss"+str(id)+"m5.png","soldierm"+str(id)+".plist/ss"+str(id)+"m6.png"));
        shiftAni = moveto(0, 0, 0);
        
        state = SOL_FREE;
        

        nameBanner = bg.addnode().pos(bSize[0]/2, -5).anchor(50, 100);
        var col;
        if(isArena)
            col = [0, 0, 100];
        else
            col = [100, 0, 0];

        var pic = nameBanner.addlabel(getStr("nameLev", ["[NAME]", privateData.get("name"), "[LEV]", str(privateData.get("level"))]), null, 18).color(col);
        var lSize = pic.prepare().size();
        nameBanner.size(lSize);

        bg.setevent(EVENT_TOUCH|EVENT_MULTI_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }

    override function enterScene()
    {
        super.enterScene();
        map.solTimer.addTimer(this);
    }
    //如果场景已经退出 再更新士兵数据 则存在问题
    override function exitScene()
    {
        if(map.solTimer != null)
            map.solTimer.removeTimer(this);
        super.exitScene();
    }
    
    var accMove;
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
        map.touchMoved(n, e, p, x, y, points)
    }
    function touchEnded(n, e, p, x, y, points)
    {
        if(accMove < 20)
            map.scene.menu.setCurChooseSol(this);
        else
            map.touchEnded(n, e, p, x, y, points);
    }
    var chooseStar = null;
    //成功设定当前士兵为 选择士兵
    function setCurSolFinish()
    {
        if(chooseStar == null)
        {
            var bSize = bg.size();
            chooseStar = sprite().anchor(50, 50).pos(bSize[0]/2, bSize[1]);
            if(isArena)//挑战其它擂主
                chooseStar.addaction(repeat(animate(1500, 
                    "greenStar0.png", "greenStar1.png", "greenStar2.png", "greenStar3.png", "greenStar4.png", "greenStar5.png", "greenStar6.png", "greenStar7.png", "greenStar8.png", "greenStar9.png", "greenStar10.png", "greenStar11.png", "greenStar12.png", "greenStar13.png", "greenStar14.png", "greenStar15.png", "greenStar16.png", "greenStar17.png", "greenStar18.png"
                    , UPDATE_SIZE)));
            else//防守我方擂台
                chooseStar.addaction(repeat(animate(1500, "redStar0.png", "redStar1.png", "redStar2.png", "redStar3.png", "redStar4.png", "redStar5.png", "redStar6.png", "redStar7.png", "redStar8.png", "redStar9.png", "redStar10.png", UPDATE_SIZE)));
            bg.add(chooseStar, -1);

            state = SOL_WAIT;
            shiftAni.stop();//停止移动 
        }
    }
    override function update(diff)
    {
        if(state == SOL_FREE)
        {
            tar = getTar();
            if(tar != null)
            {
                state = SOL_MOVE; 
                map.mapGridController.clearSolMap(this);
                curMap = map.mapGridController.updatePosMap([sx, sy, tar[0], tar[1], this]);
                //停止移动动画 接着重新开始移动动画
                changeDirNode.stop();
                changeDirNode.addaction(movAni);
                setDir();
                doMove();
            }
        }
        else if(state == SOL_MOVE)
        {
            doMove();
        }
        else if(state == SOL_WAIT)
        {
        }
        
    }
    function clearChoose()
    {
        if(chooseStar != null)
        {
            chooseStar.removefromparent();
            chooseStar = null;
            state = SOL_FREE;
        }
    }
}
    
