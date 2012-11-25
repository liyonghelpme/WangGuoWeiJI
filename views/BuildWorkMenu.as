/*
士兵可复用，则应该由对象本身提供banner 而不是由这里来推测banner
使用了建筑物的以下属性：
state
kind

*/
//点击建筑物 士兵菜单
class BuildWorkMenu extends MyNode
{
    var build;
    var timeLabel = null;
    var cw;
    var banner;
    var left;
    var right;
    function BuildWorkMenu(b, func1, func2)
    {
        build = b;
        bg = node();
        banner = bg.addsprite("buildMenu1.png").pos(0, global.director.disSize[1]).anchor(0, 100);
        init();
        //建筑信息
        //var bData = getData(BUILD, build.id);
        var bData = build.data;
        var state = build.state;

        if(bData.get("funcs") == DECOR_BUILD)
        {
            var ct = bData.get("cityDefense", 0);
            var exp = bData.get("exp", 0);
            if(ct != 0)
                cw = colorWordsNode(getStr("decorInfo0", ["[NAME]", build.getName(), "[NUM]", str(ct)]), 21, [100, 100, 100], [89, 72, 18]);
            else 
                cw = colorWordsNode(getStr("decorInfo1", ["[NAME]", build.getName(), "[NUM]", str(exp)]), 21, [100, 100, 100], [89, 72, 18]);
        }
        //空闲中点击是选择农作物菜单
        else if(bData.get("funcs") == FARM_BUILD)
        {
            var rate = bData["rate"];
            if(rate > 1)
            {
                cw = colorWordsNode(getStr("magicFarm", ["[NAME]", build.getName(), "[TIME]", str(0)]), 21, [100, 100, 100], [89, 72, 18]);
            }
            else
            {
                cw = colorWordsNode(getStr("normalFarm", ["[NAME]", build.getName(), "[TIME]", str(0)]), 21, [100, 100, 100], [89, 72, 18]);
            }
        }
        else if(bData.get("funcs") == MINE_KIND)
        {
            cw = colorWordsNode(getStr("mineInfo", ["[LEV]", str(build.buildLevel), "[NAME]", build.getName(), "[TIME]", str(0)]), 21, [100, 100, 100], [89, 72, 18]);
        }
        else if(bData.get("funcs") == LOVE_TREE)
        {
            var leftNum = getLoveTreeLeftNum(build.buildLevel);
            cw = colorWordsNode(getStr("loveInfo", ["[LEV]", str(build.buildLevel+1), "[NUM]", str(leftNum)]), 21, [100, 100, 100], [89, 72, 18]);
        }
        else if(bData.get("funcs") == HOUSE_BUILD)
        {
            cw = colorWordsNode(getStr("houseInfo", ["[NAME]", build.getName(), "[PEOP]", str(bData.get("people"))]), 21, [100, 100, 100], [89, 72, 18]);
        }
        else if(bData.get("funcs") == CASTLE_BUILD)
        {
            cw = colorWordsNode(getStr("castleInfo", ["[LEV]", str(global.user.getValue("level")), "[NUM]", str(global.user.getValue("cityDefense"))]), 21, [100, 100, 100], [89, 72, 18]);
            
            //bg.addsprite("buildDefense.png").anchor(0, 0).pos(322, 21).size(27, 27);
            banner.addsprite("buildDefense.png").anchor(0, 0).pos(322, 21).setevent(EVENT_TOUCH, onDefense);
        }
        else if(bData.get("funcs") == CAMP)
        {
            //空闲兵营只显示 建筑名称
            if(build.state == PARAMS["buildFree"])
            {
                cw = label(build.getName(), "fonts/heiti.ttf", 21);
            }
            //工作兵营显示 招募士兵名称 和 剩余时间
            else
            {
                var sData = getData(SOLDIER, build.funcBuild.objectId);
                cw = colorWordsNode(getStr("campInfo", ["[NAME]", str(sData.get("name")), "[TIME]", getWorkTime(build.getLeftTime())]), 21, [100, 100, 100], [89, 72, 18]);
            }
        }
        else 
        {
            cw = label(build.getName(), "fonts/heiti.ttf", 21);

        }
        cw.pos(31, 32).anchor(0, 50);
        banner.add(cw);

        //bg.addsprite("buildTip.png").anchor(0, 0).pos(737, 14).size(38, 36);

        banner.addsprite("buildTip.png").pos(737, 14).anchor(0, 0).setevent(EVENT_TOUCH, onInfo);


        if(state == PARAMS["buildWork"])
        {
            timeLabel = cw;
        }

        left = new ChildMenuLayer(0, func1, build, func2);
        right = new ChildMenuLayer(1, func2, build, func1);
        addChildZ(left, -1);
        addChildZ(right, -1);
    }
    function onDefense()
    {
    }
    function onInfo()
    {
    }

    //需要显示工作时间
    //普通农田 魔法农田
    //水晶矿
    function update(diff)
    {
        if(timeLabel != null)
        {
            var bData = build.data;

            var leftTime = build.getLeftTime();
            var s = getWorkTime(leftTime);

            if(bData["funcs"] == FARM_BUILD)
            {
                timeLabel.removefromparent();
                var rate = bData["rate"];
                if(rate > 1)
                    cw = colorWordsNode(getStr("magicFarm", ["[NAME]", build.getName(), "[TIME]", s]), 21, [100, 100, 100], [89, 72, 18]);
                else
                    cw = colorWordsNode(getStr("normalFarm", ["[NAME]", build.getName(), "[TIME]", s]), 21, [100, 100, 100], [89, 72, 18]);
                timeLabel = cw;

                cw.pos(31, 32).anchor(0, 50);
                banner.add(cw);
            }
            else if(bData["funcs"] == MINE_KIND)
            {
                timeLabel.removefromparent();
                cw = colorWordsNode(getStr("mineInfo", ["[LEV]", str(build.buildLevel), "[NAME]", build.getName(), "[TIME]", str(s)]), 21, [100, 100, 100], [89, 72, 18]);

                timeLabel = cw;
                cw.pos(31, 32).anchor(0, 50);
                banner.add(cw);
            }
            else if(bData["funcs"] == CAMP)
            {
                timeLabel.removefromparent();

                var sData = getData(SOLDIER, build.funcBuild.objectId);
                cw = colorWordsNode(getStr("campInfo", ["[NAME]", str(sData.get("name")), "[TIME]", getWorkTime(build.getLeftTime())]), 21, [100, 100, 100], [89, 72, 18]);

                timeLabel = cw;
                cw.pos(31, 32).anchor(0, 50);
                banner.add(cw);
            }

            //timeLabel.text(s);
        }
        else if(build.state == PARAMS["buildFree"])//农田空闲中 使用另一个文字
        {
        }
    }
    //关闭两个子菜单
    override function removeSelf()
    {
        left.removeSelf();
        right.removeSelf();
        super.removeSelf();
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
