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
        bg = sprite("buildMenuBack.png").pos(0, global.director.disSize[1]).anchor(0, 100);


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
        trace("setBuilding", b);
        if(b != null)
        {
            opKind = b[0];
            building = b[1].data;
        }
        else
        {
            building = null;
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
                buttonNode.addsprite("buildOk0.png").anchor(0, 0).pos(669, 8).size(50, 48).setevent(EVENT_TOUCH, buildOk);
            buttonNode.addsprite("buildCancel1.png").anchor(0, 0).pos(727, 9).size(45, 45).setevent(EVENT_TOUCH, buildCancel);
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
        if(opKind == PLAN_SOLDIER)//规划士兵
        {
            trace("SolbuildOk", buildOk);
            buttonNode.addsprite("buildOk0.png").anchor(0, 0).pos(669, 8).size(50, 48).setevent(EVENT_TOUCH, buildOk);
            buttonNode.addsprite("buildCancel1.png").anchor(0, 0).pos(727, 9).size(45, 45).setevent(EVENT_TOUCH, buildCancel);
            buttonNode.addlabel(getStr("dragBuild", null), "fonts/heiti.ttf", WORD_SZ).anchor(0, 50).pos(W_X, BUT_Y).color(100, 100, 100);
        }
        else if(opKind == PLAN_BUILDING)//规划建筑物
        {
            var kind = building.get("kind");

            if(building.get("changeDir") == 0)//不能旋转
            {
                var butNum = 2;
                if(kind == FARM_ZONE)//农田
                {
                    if(inPlan)
                    {
                        buttonNode.addsprite("buildSell0.png").anchor(0, 0).pos(726, 8).size(48, 48).setevent(EVENT_TOUCH, onSell);
                        butNum = 3;
                    }
                }
                if(butNum == 3)
                {
                    buttonNode.addsprite("buildOk0.png").anchor(0, 0).pos(611, 8).size(50, 48).setevent(EVENT_TOUCH, buildOk);
                    buttonNode.addsprite("buildCancel1.png").anchor(0, 0).pos(669, 9).size(45, 45).setevent(EVENT_TOUCH, buildCancel);
                }
                else
                {
                    buttonNode.addsprite("buildOk0.png").anchor(0, 0).pos(669, 8).size(50, 48).setevent(EVENT_TOUCH, buildOk);
                    buttonNode.addsprite("buildCancel1.png").anchor(0, 0).pos(727, 9).size(45, 45).setevent(EVENT_TOUCH, buildCancel);
                }

                buttonNode.addlabel(getStr("dragBuild", null), "fonts/heiti.ttf", WORD_SZ).anchor(0, 50).pos(W_X, BUT_Y).color(100, 100, 100);
            }
            else
            {
                trace("buildOk", buildOk);
                buttonNode.addsprite("buildOk0.png").anchor(0, 0).pos(611, 8).size(50, 48).setevent(EVENT_TOUCH, buildOk);
                buttonNode.addsprite("buildSwitch0.png").anchor(0, 0).pos(668, 8).size(48, 48).setevent(EVENT_TOUCH, onSwitch);
                buttonNode.addsprite("buildCancel1.png").anchor(0, 0).pos(727, 9).size(45, 45).setevent(EVENT_TOUCH, buildCancel);

                buttonNode.addlabel(getStr("dragBuild", null), "fonts/heiti.ttf", WORD_SZ).anchor(0, 50).pos(W_X, BUT_Y).color(100, 100, 100);
            }
        }
    }
    //农田建筑第一次卖出不设置为空 第二次卖出设置为空
    //第一次卖出 不设置 为空选项
    //第二次卖出才设置
    //卖出建筑物
    function onSell()
    {
        trace("onSell", scene.curBuild.selled);
        if(scene.curBuild.selled == 1)
            setBuilding(null);
        scene.onSell();   
        //卖出建筑成功后 清空当前控制条的显示
    }

    function finishPlan(n, e, p, x, y, points)
    {
        trace("finishPlan");
        scene.finishPlan();
    }
    function cancelPlan(n, e, p, x, y, points)
    {
        scene.cancelPlan();
    }
    function onOk(n, e, p, x, y, points)
    {   
        trace("finisBuilding");
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
