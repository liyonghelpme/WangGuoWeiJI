//建造和 规划菜单
class BuildMenu extends MyNode
{
    var scene;
    var building;
    var buttonNode;
    //util getBuild
    //kind = 0 farm
    var inPlan = 0;
    var OFFX = 57;
    //是否刚进入规划功能尚没有改变建筑物状态
    var setYet = 0;
    function BuildMenu(s, b)
    {
        scene = s;
        building = b;
//        trace("building data", building);
        //移动建筑
        if(building == null)
        {
            inPlan = 1;
        }
        bg = sprite("buildMenuBack.jpg").pos(0, global.director.disSize[1]).anchor(0, 100);


        buttonNode = null;
        //规划模式初始化数据为空

        setBuilding(b);
    }
    /*
    在规划模式下， 每次点击新的建筑的时候就显示新的关于建筑的信息
    
    传入建筑物士兵 引用
    传入建筑的getData 的信息

    传入士兵的数据信息

    */
    var opKind = null;
    const BUT_Y = 32;
    const WORD_SZ = 22;
    const W_X = 24;
    function setBuilding(b)
    {
        if(b != null)
        {
            opKind = b[0];
            building = b[1].data;
        }


        if(buttonNode != null)
        {
            setYet = 1;
            buttonNode.removefromparent();
        }
        buttonNode = bg.addnode();
        var buildOk = onOk;
        var buildCancel = onCancel;

        if(inPlan == 1)
        {
            buildOk = finishPlan; 
            buildCancel = cancelPlan;
        }

        /*
        两种情况：
            用户刚开始规划没有选择建筑物
            用户已经规划了一会，卖出了某个建筑
        */
        if(building == null)
        {
            if(setYet == 1)//改变了建筑物状态 所以需要ok
                buttonNode.addsprite("buildOk0.png").pos(687, BUT_Y).anchor(50, 50).setevent(EVENT_TOUCH, buildOk);
            buttonNode.addsprite("buildCancel1.png").pos(744, BUT_Y).anchor(50, 50).setevent(EVENT_TOUCH, buildCancel);
buttonNode.addlabel(getStr("chooseBuild", null), "fonts/heiti.ttf", WORD_SZ).pos(W_X, BUT_Y).anchor(0, 50).color(100, 100, 100);
            return;
        }


        /*
        区分当前是规划 才可以卖出
        kind = 0 农田      可以卖出
        kind = 1 民居      不显示卖出
        kind = 2 装饰      菜单栏目不显示卖出 
        kind = 3 永久建筑  不可卖出
        按钮顺序: 卖出 确认 切换方向 取消
        offX = 744-687 = 57
        或者根据功能 区分
        */
        /*
        士兵只有确认和取消按钮
        */
        if(opKind == PLAN_SOLDIER)
        {
            buttonNode.addsprite("buildOk0.png").pos(687, BUT_Y).anchor(50, 50).setevent(EVENT_TOUCH, buildOk);
            buttonNode.addsprite("buildCancel1.png").pos(744, BUT_Y).anchor(50, 50).setevent(EVENT_TOUCH, buildCancel);
buttonNode.addlabel(getStr("dragBuild", null), "fonts/heiti.ttf", WORD_SZ).anchor(0, 50).pos(W_X, BUT_Y).color(100, 100, 100);
        }
        else if(opKind == PLAN_BUILDING)
        {
            var kind = building.get("kind");
            if(building.get("changeDir") == 0)
            {
                if(kind == FARM_ZONE && inPlan == 1)
                    buttonNode.addsprite("buildSell0.png").pos(687-OFFX*2, BUT_Y).anchor(50, 50).setevent(EVENT_TOUCH, onSell);
                    
                buttonNode.addsprite("buildOk0.png").pos(687, BUT_Y).anchor(50, 50).setevent(EVENT_TOUCH, buildOk);
                buttonNode.addsprite("buildCancel1.png").pos(744, BUT_Y).anchor(50, 50).setevent(EVENT_TOUCH, buildCancel);
buttonNode.addlabel(getStr("dragBuild", null), "fonts/heiti.ttf", WORD_SZ).anchor(0, 50).pos(W_X, BUT_Y).color(100, 100, 100);
            }
            else
            {
                if(kind == FARM_ZONE && inPlan == 1)
                    buttonNode.addsprite("buildSell0.png").pos(633-OFFX*2, BUT_Y).anchor(50, 50).setevent(EVENT_TOUCH, onSell);

                buttonNode.addsprite("buildOk0.png").pos(633, BUT_Y).anchor(50, 50).setevent(EVENT_TOUCH, buildOk);
                buttonNode.addsprite("buildSwitch0.png").pos(687, BUT_Y).anchor(50, 50).setevent(EVENT_TOUCH, onSwitch);
                buttonNode.addsprite("buildCancel1.png").pos(744, BUT_Y).anchor(50, 50).setevent(EVENT_TOUCH, buildCancel);
buttonNode.addlabel(getStr("dragBuild", null), "fonts/heiti.ttf", WORD_SZ).anchor(0, 50).pos(W_X, BUT_Y).color(100, 100, 100);
            }
        }
    }
    function onSell()
    {
        scene.onSell();   
        //卖出建筑成功后 清空当前控制条的显示
        setBuilding(null);
    }

    function finishPlan()
    {
        scene.finishPlan();
    }
    function cancelPlan()
    {
        scene.cancelPlan();
    }
    function onOk(n, e, p, x, y, points)
    {   
        scene.finishBuild();
    }
    function onSwitch(n, e, p, x, y, points)
    {
        scene.onSwitch();
    }
    function onCancel(n, e, p, x, y, points)
    {
        scene.cancelBuild();
    }
}
