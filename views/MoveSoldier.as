/*
checkPosCollision
clearMap
*/
class MoveSoldier extends MyNode
{
    const showSize = 50;
    var map;
    var changeDirNode;
    var shadow;
    var id;
    //var privateData;
    var movAni;
    var shiftAni;
    var state;
    var sx = 1;
    var sy = 1;
    var tar;
    var data;
    var speed = 5;
    var curMap = null;


    /*
    function MoveSoldier(m)
    {
        id = 0;
        data = getData(SOLDIER, id);
        map = m;
        bg = node().scale(showSize);
        init();

        load_sprite_sheet("soldierm"+str(id)+".plist");
        
changeDirNode = bg.addsprite(((("soldierm" + str(id)) + ".plist/ss") + str(id)) + "m0.png", ARGB_8888).anchor(50, 100);

        var bSize = changeDirNode.prepare().size();

        bg.size(bSize).anchor(50, 100).pos(571, 356);

        changeDirNode.pos(bSize[0]/2, bSize[1]);
shadow = sprite("roleShadow.png", ARGB_8888).pos(bSize[0] / 2, bSize[1]).anchor(50, 50).size(data.get("shadowSize"), 32);

        changeDirNode.add(shadow, -1);

        movAni = repeat(animate(1500, "soldierm"+str(id)+".plist/ss"+str(id)+"m0.png", "soldierm"+str(id)+".plist/ss"+str(id)+"m1.png","soldierm"+str(id)+".plist/ss"+str(id)+"m2.png","soldierm"+str(id)+".plist/ss"+str(id)+"m3.png","soldierm"+str(id)+".plist/ss"+str(id)+"m4.png","soldierm"+str(id)+".plist/ss"+str(id)+"m5.png","soldierm"+str(id)+".plist/ss"+str(id)+"m6.png"));
        shiftAni = moveto(0, 0, 0);
        
        state = SOL_FREE;

        bg.setevent(EVENT_TOUCH|EVENT_MULTI_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }
    */

    function setDir()
    {
        var oldSca = changeDirNode.scale();
        oldSca[0] = abs(oldSca[0]);
        var difx = tar[0] - bg.pos()[0];
        if(difx > 0)
            changeDirNode.scale(-oldSca[0], oldSca[0]);
        else 
            changeDirNode.scale(oldSca[0], oldSca[0]);

        var bSize = changeDirNode.size();
        var shadowOffX = data["shadowOffX"];
        var shadowOffY = data["shadowOffY"];

        if(changeDirNode.scale()[0] < 0)
            shadow.pos(bSize[0]/2+shadowOffX, bSize[1]+shadowOffY);
        else
            shadow.pos(bSize[0]/2-shadowOffX, bSize[1]+shadowOffY);
    }

    function getTar()
    {
        var curPos = bg.pos();
        var solMap = getPosMap(sx, sy, curPos[0], curPos[1]);  
        solMap = [solMap[2], solMap[3]];
        var allPos = [
            [solMap[0]+0, solMap[1]+-2],
            [solMap[0]+-1, solMap[1]+-1],
            [solMap[0]+-2, solMap[1]+0],
            [solMap[0]+-1, solMap[1]+1],
            [solMap[0]+0, solMap[1]+2],
            [solMap[0]+1, solMap[1]+1],
            [solMap[0]+2, solMap[1]+0],
            [solMap[0]+1, solMap[1]+-1],
        ];
        var start = rand(len(allPos));
        var moveable = 0;
        for(var i = 0; i < len(allPos); i++)
        {
            var cur = (start+i)%len(allPos);
            var curMap = allPos[cur];
            var tPos = setBuildMap([sx, sy, curMap[0], curMap[1]]);
            var col = map.checkPosCollision(curMap[0], curMap[1], tPos);
            if(col == null)
            {
                moveable = 1;
                break;   
            }
        }
        if(moveable == 1)
        {
            var tmap = allPos[(start+i)%len(allPos)];
            return setBuildMap([sx, sy, tmap[0], tmap[1]]);
        }
        return null;
    }
    override function enterScene()
    {
        super.enterScene();
    }
    override function exitScene()
    {
        super.exitScene();
    }
    /*
    override function enterScene()
    {
        super.enterScene();
        map.solTimer.addTimer(this);
    }
    override function exitScene()
    {
        map.solTimer.removeTimer(this);
        super.exitScene();
    }
    */
    
    function update(diff)
    {
        if(state == SOL_FREE)
        {
            tar = getTar();
            if(tar != null)
            {
                state = SOL_MOVE; 
                map.mapGridController.clearSolMap(this);
                curMap = map.mapGridController.updatePosMap([sx, sy, tar[0], tar[1], this]);
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
    function doMove()
    {
        shiftAni.stop();
        var oldPos = bg.pos();
        setPos(oldPos);
        var dist = distance(bg.pos(), tar);
        if(oldPos[0] == tar[0] && oldPos[1] == tar[1])
        {
            movAni.stop();
            state = SOL_FREE;
            return;
        }
        var t = dist*100/speed;
        shiftAni = moveto(t, tar[0], tar[1]);
        bg.addaction(shiftAni);
    }
    /*
    function touchBegan(n, e, p, x, y, points)
    {
    }
    function touchMoved(n, e, p, x, y, points)
    {
    }
    function touchEnded(n, e, p, x, y, points)
    {
    }
    */
}
    
