//different dialog scene view 
class Scene extends MyNode
{
    var dialogController;
    function Scene()
    {
        bg = node();
        init();
        dialogController = new DialogController(this);
    }
    /*
    function quitScene()
    {

    }
    */
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
    var emptyScene;//最底层帮助进行场景切换
    var taskHintDebug;
    function Director()
    {
//        trace("init director");
        taskHintDebug = label("",  null, 20).color(0, 0, 0).pos(10, 10);
        stack = [];
        disSize = [800, 480];
        v_scale(disSize[0], disSize[1]);
        sceneStack = new Array();
        curScene = new Scene();

        emptyScene = new Scene();
        getscene().add(emptyScene.bg);
        emptyScene.enterScene();

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
//        trace("KeyEVENT", n, e, p, kc);
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
                //pushView(new QuitBanner(), 0, 0);
                curScene.dialogController.addBanner(new UpgradeBanner(getStr("quitNow", null), [100, 100, 100], clearQuitState));
            }
        }
        else if(quitState == 1)
        {
            if(kc == KEYCODE_BACK)
            {
                popScene();//关闭场景
                global.timer.stop();//关闭定时器
                global.myAction.stop();//关闭全局动画

//                trace("quitGame now");
                quitgame();
            }
        }
    }
    var controlledStack = []; 
    function pushControlledFrag(view, dark, autoPop)
    {
        if(dark == 1)
        {
            var temp = new MyNode();
            temp.bg = node();
            var d = new Dark(autoPop);
            temp.addChild(d);
            temp.addChild(view);

            curScene.addChild(temp);
            controlledStack.append([view, 1]);
        }
        else
        {
            curScene.addChild(view); 
            controlledStack.append([view, 0]);
        }
    }
    //删除背后的darkNode
    //但是view 需要知道自己是否是dark的 
    function popControlledFrag(view)
    {
        for(var i = len(controlledStack)-1; i >= 0; i--)
        {
            if(controlledStack[i][0] == view)
            {
                if(controlledStack[i][1] == 1)
                    view.bg.parent().get().removeSelf();
                else
                    view.removeSelf();
                controlledStack.pop(i);
                break;
            }
        }
    }

    function pushView(view, dark, autoPop)
    {
        if(dark == 1)
        {
//            trace("push dark");
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
//            trace("begin add");
            curScene.addChild(view); 
//            trace("add view");
            stack.append(view);
        }
//        trace("director push", len(stack));
    }
    function pushPage(view, z)
    {
        curScene.addChildZ(view, z);
        stack.append(view);
//        trace("push Page", len(stack));
    }
    var needMask = 0;
    function setMask(m)
    {
        needMask = m;
        if(needMask == 0)
            removeNewTaskMask();
        //新手剧情完成之后 首先出现 经营场景接着才是初始化数据 信号发送这时候 需要检测经营页面是否已经显示了Mask 没有则显示
        else if(GlobalNewTaskMask == null){//如果当前显示的场景没有添加Mask 则添加
            showNewTaskMask(null, null);
        }
    }
    function replaceScene(view)
    {
        curScene.removeSelf();
        curScene = view;
        if(curScene == null)
            return;
        stack = []

        getscene().add(curScene.bg, 0);
        curScene.bg.setevent(EVENT_KEYDOWN, quitGame);
        curScene.bg.focus(1);

        //罩子自动阻挡系统
        //自动遮挡场景
        if(needMask)
        {
            showNewTaskMask(null, null);
        }

        curScene.enterScene();
        trace("replaceScene");
        if(getParam("debugNewTask"))
        {
            taskHintDebug.removefromparent();
            curScene.bg.add(taskHintDebug, MASK_ZORD);
        }
        //切换场景时新场景也需要有 Mask 怎么办？

    }
    function updateTaskHint(w)
    {
        trace("updateTaskHint", w);
        taskHintDebug.text(w);
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
//        trace("shotOver", rid, rc, con, para);
    }
    function pushScene(view)
    {
        sceneStack.append(curScene);
        replaceScene(view);
    }
    function popScene()
    {
        var oldS;
        if(len(sceneStack) > 0)
            oldS = sceneStack.pop();
        else 
            oldS = null;
        replaceScene(oldS);
    }
    function popView()
    {
        var v = stack.pop();
        curScene.removeChild(v);
//        trace("director pop", len(stack));
    }
}
