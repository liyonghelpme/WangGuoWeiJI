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
            quitgame();
        }
        /*
        if(kc == KEYCODE_BACK)
        {
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
        }
        */
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
            trace("begin add");
            curScene.addChild(view); 
            trace("add view");
            stack.append(view);
        }
        trace("director push", len(stack));
    }
    function pushPage(view, z)
    {
        curScene.addChildZ(view, z);
        stack.append(view);
        trace("push Page", len(stack));
    }
    function replaceScene(view)
    {
        curScene.removeSelf();
        //curScene = new Scene();
        curScene = view;
        stack = []

        getscene().add(curScene.bg);
        //getscene().setevent(EVENT_KEYUP, quitGame);
        curScene.enterScene();

        //pushPage(view, 0);
    }
    function pushScene(view)
    {
        sceneStack.append(curScene);
        replaceScene(view);
    }
    function popScene()
    {
        var oldS = sceneStack.pop();
        replaceScene(oldS);
    }
    function popView()
    {
        var v = stack.pop();
        curScene.removeChild(v);
        trace("director pop", len(stack));
    }
}
