//different dialog scene view 
class Scene extends MyNode
{
    function Scene()
    {
        bg = node();
        init();
    }
    function quitScene()
    {

    }
}
/*
确保当前最高的对话框 自己关闭自己 
1: 当前已经弹出对话框则不再弹出对话框
2: 对话框关闭时传入自己作为参数用于在堆栈中寻找
*/
class Director
{
    var curScene;
    var sceneStack;
    var disSize;
    var Display;
    var stack;
    var quitState = 0;
    function Director()
    {
        trace("init director");
        stack = [];
        disSize = [800, 480];
        v_scale(disSize[0], disSize[1]);
        sceneStack = new Array();
        curScene = new Scene();

        getscene().add(curScene.bg);
        curScene.bg.setevent(EVENT_KEYDOWN, quitGame);
        curScene.bg.focus(1);
        curScene.enterScene();
    }

    function clearQuitState()
    {
        quitState = 0;
    }

    function quitGame(n, e, p, kc)
    {
        trace("KeyEVENT", n, e, p, kc);
        /*
        退出战斗页面
        if(global.map != null)
        {
            global.director.popScene();
            return;
        }
        */
        if(quitState == 0)
        {
            if(kc == KEYCODE_BACK)
            {
                quitState = 1;
                global.director.pushView(new QuitBanner());
            }
        }
        else if(quitState == 1)
        {
            if(kc == KEYCODE_BACK)
            {
                trace("quitGame now");
                quitgame();
            }
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
        curScene = view;
        stack = []

        getscene().add(curScene.bg);
        curScene.bg.setevent(EVENT_KEYDOWN, quitGame);
        curScene.bg.focus(1);
        curScene.enterScene();

    }
    function getPid()
    {
        curScene.bitmap(shotScreen, 1);
    }
    function shotScreen(n, b, p)
    {
        ppy_upload(dict([["photo", b.bitmap2bytes("png")]]), shotOver, null);
    }
    function shotOver(rid, rc, con, para)
    {
        trace("shotOver", rid, rc, con, para);
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
