//default left
class Soldier extends MyNode
{
    var map;
    var kind;
    var color;
    var state;
    var tar = null;
    //10000ms 2000*100
    const SPE = 20;
    var speed = 20;
    var lastPoints;
    var mobj;
    function Soldier(m, data)
    {
        map = m;
        //color = data.get("color");
        //kind = data.get("kind");
        color = data;
        kind = 0;
        state = 0;
        bg = sprite("ss0m0.png").anchor(50, 100).pos(102, 186);
        init();
        setDir();
        setPosition();
        mobj = new MoveObject();
        mobj.speed = 5;

        bg.setevent(EVENT_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }
    function startState4()
    {
        tar = null;
        bg.addaction(stop());
        /*
        bg.addaction(sequence(stop(), repeat(
            animate(
                "ss0m0.png", "ss0m1.png","ss0m2.png","ss0m3.png","ss0m4.png","ss0m5.png","ss0m6.png"))));
        */
        
    }
    function touchBegan(n, e, p, x, y, points)
    {
        state = 4;
        //startState4();
        lastPoints = n.node2world(x, y);
    }
    function touchMoved(n, e, p, x, y, points)
    {
        var oldPos = lastPoints;
        lastPoints = n.node2world(x, y);
        var difx = lastPoints[0]-oldPos[0];
        var dify = lastPoints[1]-oldPos[1];
        var curPos = bg.pos();
        bg.pos(curPos[0]+difx, curPos[1]+dify);
    }
    function touchEnded(n, e, p, x, y, points)
    {
        state = 0; 
        bg.addaction(stop());
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
                speed = SPE; 
                bg.scale(-100, 100);
            }
            else
            {
                speed = -SPE;
                bg.scale(100, 100);
            }
        }
    }
    function setPosition()
    {
        if(color == 0)
            bg.pos(102, 186);
        else
            bg.pos(102+938, 186);
    }
    function getTar()
    {
        var t = map.soldiers.get(1-color);
        trace("my tar", this, t);
        if(len(t) > 0)
        {
            return t[0];
        }
        return null;
    }
    function update(diff)
    {
        trace("update soldier", diff, state, tar);
        if(state == 0)
        {
            tar = getTar();
            if(tar != null)
                state = 1;
        }
        else if(state == 1)
        {

            bg.addaction(repeat(
                animate(2000, 
                    "ss0m0.png", "ss0m1.png","ss0m2.png","ss0m3.png","ss0m4.png","ss0m5.png","ss0m6.png")));
            trace("addaction", state);
            setDir();
            state = 2;
        }
        else if(state == 2)
        {

            var all = mobj.MoveToPos(bg.pos(), tar.getPos(), diff);
            var mx = all[0];
            var my = all[1];
            if(all[2] == 0 && all[3] == 0)
            {
                state = 3;
                return;
            }
            var myPos = bg.pos();
            bg.pos(myPos[0]+mx, myPos[1]+my);
            /*
            var move = speed * diff/100; 
            var mx = 0;
            var my = 0;
            var tPos = tar.getPos();
            var myPos = bg.pos();
            var difx = tPos[0] - myPos[0];
            var dify = tPos[1] - myPos[1];
            trace("move ",color,  speed, difx, dify, move, myPos, tPos);
            if(difx*difx + dify*dify < 400)
                state = 3;
            if(abs(difx) > abs(dify))
            {
                mx = move;
            }
            else
            {
                my = move;
            }
            trace("mx, my", mx, my);
            bg.pos(myPos[0]+mx, myPos[1]+my);
            //bg.addaction(stop());
            */
        }
        else if(state == 3)
        {
            bg.addaction(repeat(animate(2000,
                "ss0a0.png", "ss0a1.png", "ss0a2.png", "ss0a3.png", "ss0a4.png", "ss0a5.png", "ss0a6.png", "ss0a7.png")));
            state = 5;
        }
        else if(state == 4)
        {
            tar = null;
            bg.addaction(stop());
            state = 6; 

        }
        else if(state == 5)
        {
        }
        else if(state == 6)
        {
            bg.addaction(repeat(
                animate(2000,
                "ss0m0.png", "ss0m1.png","ss0m2.png","ss0m3.png","ss0m4.png","ss0m5.png","ss0m6.png")));
            state = 7;
        }
        else if(state == 7)
        {
        }

    }
    override function enterScene()
    {
        trace("map", map, map.myTimer);
        super.enterScene();   
        //global.timer.addTimer(this);
        map.myTimer.addTimer(this);
    }
    override function exitScene()
    {
        //global.timer.removeTimer(this);
        map.myTimer.removeTimer(this);
        super.exitScene();   
    }
}
class Map extends MyNode
{
    var kind;
    var touchDelegate;
    var walkZone = [102, 186, 938, 356];

    var soldiers = dict();

    var myTimer;
    //color kind
    function Map(k, s)
    {
        kind = k;
        bg = sprite("map"+str(k)+".png");
        bg.prepare();
        init();
        touchDelegate = new StandardTouchHandler();
        touchDelegate.bg = bg;


        initSoldier(s);
        bg.setevent(EVENT_TOUCH|EVENT_MULTI_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }
    function initSoldier(s)
    {
        for(var i = 0; i < len(s); i++)
        {
            var so = new Soldier(this, s[i]);  
            var myColor = soldiers.get(s[i], []);
            soldiers.update(s[i], myColor);
            myColor.append(so);
            addChild(so);
        }
        trace("soldiers", soldiers);
    }
    function update(diff)
    {
    }
    override function enterScene()
    {
        trace("enterScene map");
        myTimer = new Timer(100);
        super.enterScene();
        //global.timer.addTimer(this);
    }
    override function exitScene()
    {
        trace("exitScene map");
        //global.timer.removeTimer(this);
        super.exitScene();
        myTimer.stop();
        myTimer = null;
    }
    function touchBegan(n, e, p, x, y, points)
    {
        touchDelegate.tBegan(n, e, p, x, y, points);
    }
    function touchMoved(n, e, p, x, y, points)
    {
        touchDelegate.tMoved(n, e, p, x, y, points);
    }
    function touchEnded(n, e, p, x, y, points)
    {
        touchDelegate.tEnded(n, e, p, x, y, points);
    }
}
