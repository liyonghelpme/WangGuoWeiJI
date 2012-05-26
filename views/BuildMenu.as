class BuildMenu extends MyNode
{
    var scene;
    var building;
    var buttonNode;
    //util getBuild
    //kind = 0 farm
    var inPlan = 0;
    function BuildMenu(s, b)
    {
        scene = s;
        building = b;
        trace("building data", building);
        //移动建筑
        if(building == null)
        {
            inPlan = 1;
            //bg = sprite("buildMenu0.png").pos(0, global.director.disSize[1]).anchor(0, 100);
        }
        /*
        //新建建筑 或者 点击建筑属性
        else {
            //新建建筑
            if(building.get("state", null) == 0)
                bg = sprite("buildMenu0.png").pos(0, global.director.disSize[1]).anchor(0, 100);
            //点击建筑属性
            else
                bg = sprite("buildMenu1.png").pos(0, global.director.disSize[1]).anchor(0, 100);
        }
        */
        bg = sprite("buildMenu0.png").pos(0, global.director.disSize[1]).anchor(0, 100);


        buttonNode = null;
        //规划模式初始化数据为空

        setBuilding(b);
        /*
        buttonNode = bg.addnode();
        if(building.get("kind") == 0)
        {
            bg.addsprite("buildOk.png").pos(687, 37).anchor(50, 50).setevent(EVENT_TOUCH, onOk);
            bg.addsprite("buildCancel.png").pos(744, 37).anchor(50, 50).setevent(EVENT_TOUCH, onCancel);
            bg.addlabel(building.get("name"), null, 30).anchor(0, 50).pos(112, 453).color(0, 0, 0);
        }
        else
        {
            bg.addsprite("buildOk.png").pos(633, 37).anchor(50, 50).setevent(EVENT_TOUCH, onOk);
            bg.addsprite("buildSwitch.png").pos(687, 37).anchor(50, 50).setevent(EVENT_TOUCH, onSwitch);
            bg.addsprite("buildCancel.png").pos(744, 37).anchor(50, 50).setevent(EVENT_TOUCH, onCancel);
            bg.addlabel(building.get("name"), null, 30).anchor(0, 50).pos(112, 453).color(0, 0, 0);
        }
        */

    }
    /*
    在规划模式下， 每次点击新的建筑的时候就显示新的关于建筑的信息
    */
    function setBuilding(b)
    {
        building = b;
        if(buttonNode != null)
        {
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

        if(building == null)
        {
            buttonNode.addsprite("buildCancel.png").pos(744, 37).anchor(50, 50).setevent(EVENT_TOUCH, buildCancel);
            return;
        }


        if(building.get("kind") == 0)
        {
            buttonNode.addsprite("buildOk.png").pos(687, 37).anchor(50, 50).setevent(EVENT_TOUCH, buildOk);
            buttonNode.addsprite("buildCancel.png").pos(744, 37).anchor(50, 50).setevent(EVENT_TOUCH, buildCancel);
            buttonNode.addlabel(building.get("name"), null, 30).anchor(0, 50).pos(112, 37).color(100, 100, 100);
        }
        else
        {
            buttonNode.addsprite("buildOk.png").pos(633, 37).anchor(50, 50).setevent(EVENT_TOUCH, buildOk);
            buttonNode.addsprite("buildSwitch.png").pos(687, 37).anchor(50, 50).setevent(EVENT_TOUCH, onSwitch);
            buttonNode.addsprite("buildCancel.png").pos(744, 37).anchor(50, 50).setevent(EVENT_TOUCH, buildCancel);
            buttonNode.addlabel(building.get("name"), null, 30).anchor(0, 50).pos(112, 37).color(100, 100, 100);
        }
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
