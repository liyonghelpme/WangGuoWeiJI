/*
士兵可复用，则应该由对象本身提供banner 而不是由这里来推测banner
使用了建筑物的以下属性：
state
kind

*/
class BuildWorkMenu extends MyNode
{
    var build;
    var timeLabel = null;
    function BuildWorkMenu(b, func1, func2)
    {
        build = b;
        bg = node();
        var banner = bg.addsprite("buildMenu1.png").pos(0, global.director.disSize[1]).anchor(0, 100);
        init();
//        trace("name", build.data.get("name"));
        banner.addlabel(build.data.get("name"), null, 18).pos(44, 30).anchor(0, 50).color(100, 100, 100, 100);
        var state = build.state;
        if(state == Working)
        {
            banner.addlabel(getStr("working", null), null, 18).color(100, 100, 100, 100).anchor(0, 50).pos(570, 30);
            timeLabel = banner.addlabel("", null, 18).pos(660, 30).color(100, 100, 100, 100).anchor(0, 50);
        }
        else
        {
            var kind = build.kind;
            if(kind == HOUSE_BUILD)
            {
                banner.addlabel(getStr("peopleCapacity", ["[NUM]", str(build.data.get("people"))]), null, 18).color(100, 100, 100, 100).anchor(0, 50).pos(570, 30);
            }
            else if(kind == CASTLE_BUILD)
            {
                banner.addlabel(getStr("viliDefense", ["[NUM]", str(global.user.getValue("cityDefense"))]), null, 18).color(100, 100, 100, 100).anchor(0, 50).pos(570, 30);
            }
        }

        var left = new ChildMenuLayer(0, func1, build, func2);
        var right = new ChildMenuLayer(1, func2, build, func1);
        addChildZ(left, -1);
        addChildZ(right, -1);
    }

    function update(diff)
    {
        if(timeLabel != null)
        {
            var leftTime = build.getLeftTime();
            var s = getWorkTime(leftTime);
            timeLabel.text(s);
        }
    }
    override function enterScene()
    {
        super.enterScene();
        global.timer.addTimer(this);
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
        super.exitScene();
    }

}
