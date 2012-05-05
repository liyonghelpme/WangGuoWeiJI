//different dialog scene view 
class Scene extends MyNode
{
    function Scene()
    {
        bg = node();
        init();
    }
}
class Director
{
    var curScene;
    var sceneStack;
    var disSize;
    var Display;
    var stack;
    function Director()
    {
        trace("init director");
        stack = [];
        disSize = [800, 480];
        v_scale(disSize[0], disSize[1]);
        sceneStack = new Array();
        curScene = new Scene();

        getscene().add(curScene.bg);
        getscene().setevent(EVENT_KEYUP, quitGame);
        curScene.enterScene();
    }
    function quitGame(n, e, p, kc)
    {
        trace("quit game save record");
        if(kc == KEYCODE_BACK)
        {
<<<<<<< HEAD
            quitgame();
=======
            var map = global.map;
            if(map != null)
            {
                var db = c_opendb(0, "lastMap");
                var monsters = map.monsters;
                var mon = [];
                var i;
                for(i = 0; i < len(monsters); i++)
                {
                    mon.append([monsters[i].kind, monsters[i].bg.pos(), monsters[i].health, monsters[i].curPoint, monsters[i].pid]);
                }
                var tow = [];
                var towers = map.towers;
                for(i = 0; i < len(towers); i++)
                {
                    tow.append([towers[i].kind, towers[i]]);
                }
                db.put("lastMap", dict([map.data.get("id"), map.totalHealth, map.curWave, mon, tow]));
            }
>>>>>>> master
        }
    }
    function pushView(view, dark, autoPop)
    {
        if(dark == 1)
        {
            trace("push dark");
            var temp = new MyNode();
            temp.bg = node();
            var d = new Dark(autoPop);
            temp.addChild(d);
            temp.addChild(view);

            curScene.addChild(temp);
            stack.append(temp);
        }
        else
        {
            curScene.addChild(view); 
            trace("add view");
            stack.append(view);
        }
        trace("director push", len(stack));
    }
    function pushPage(view, z)
    {
        if(view == null)
            return;
        curScene.addChildZ(view, z);
        stack.append(view);
        trace("push Page", len(stack));
    }
    function popView()
    {
        var v = stack.pop();
        curScene.removeChild(v);
        trace("director pop", len(stack));
    }
    
    function changePage(view, z)
    {
        if(view == null)
            return;
        var v = stack.pop(0);
        curScene.removeChild(v);
        curScene.addChildZ(view, z);
        stack.insert(0,view);
    }
}
