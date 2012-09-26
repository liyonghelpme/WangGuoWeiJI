
/*
采用组合的方式 而不是继承的方式 
访问特殊功能 的接口的时候就需要考虑差异性

包含数据  和 功能
baseBuild 基础功能对象的引用
民居朝向:

whenFree:
*/
class House extends FuncBuild
{
    function House(b)
    {
        baseBuild = b;
    }
    /*
    function sureToUpgrade()
    {
        var cost = getUpgradeCost();
        var buyable = global.user.checkCost(cost);
        var people = getAddPeople();
        global.director.pushView(new ResourceWarningDialog(
                        getStr("upgradeHouseTit", null), 
                                getStr("upgradeHouseCon", 
                                        ["[NUM0]", str(people), 
                                        "[NUM1]", str(baseBuild.buildLevel),
                                        "[NUM2]", str(baseBuild.buildLevel),
                                        "[NUM3]", str(cost.values()[0]),
                                        "[KIND]", getStr(cost.keys()[0], null)]), doUpgrade, buyable, cost, "build"+str(baseBuild.id)+".png ), 1, 0);
    }
    function doUpgrade()
    {
        var cost = getUpgradeCost();
        var silver = cost.get("silver", 0);
        var crystal = cost.get("crystal", 0);
        var gold = cost.get("gold", 0);
        var people = getAddPeople();

        global.httpController.addRequest("buildingC/upgradeBuild", dict([["uid", global.user.uid], ["bid", baseBuild.bid], ["silver", silver], ["crystal", crystal], ["gold", gold], ["people", people]]), null, null);

        global.user.doCost(cost);
        global.user.doAdd(dict([["people", people]]));

        baseBuild.buildLevel += 1;
        global.user.updateBuilding(baseBuild);
    }
    function checkUpgradeYet()
    {
        return 1;
    }
    function getUpgradeCost()
    {
        return dict([["gold", 10]]);
    }
    function getAddPeople()
    {
        return 1;
    }
    */
}
class LoveTree extends FuncBuild
{
    function LoveTree(b)
    {
        baseBuild = b;
    }
    /*
    function sureToUpgrade()
    {
        var cost = getUpgradeCost();
        var silver = cost.get("silver", 0);
        var crystal = cost.get("crystal", 0);
        var gold = cost.get("gold", 0);
        var people = getAddPeople();

        global.httpController.addRequest("buildingC/upgradeBuild", dict([["uid", global.user.uid], ["bid", baseBuild.bid], ["silver", silver], ["crystal", crystal], ["gold", gold], ["people", people]]), null, null);

        global.user.doCost(cost);
        global.user.doAdd(dict([["people", people]]));

        baseBuild.buildLevel += 1;
        global.user.updateBuilding(baseBuild);
    }

    function checkUpgradeYet()
    {
        return 1;
    }
    function getUpgradeCost()
    {
        return dict([["gold", 10]]);
    }
    function getAddPeople()
    {
        return 1;
    }
    */
}
class Decor extends FuncBuild
{
    function Decor(b)
    {
        baseBuild = b;
    }
    /*
    override function whenFree()
    {
        return 1; 
    }
    */
}
class Castle extends FuncBuild
{
    function Castle(b)
    {
        baseBuild = b;
    }
}

class RingFighting extends FuncBuild
{
    function RingFighting(b)
    {
        baseBuild = b;
    }
    override function whenFree()
    {
        global.director.pushScene(new RingFightingScene());
        return 1;
    }
}
/*
class StaticBuild extends FuncBuild
{
    var solNum;
    function StaticBuild(b)
    {
        baseBuild = b;
solNum = baseBuild.bg.addlabel("50", "fonts/heiti.ttf", 25, FONT_BOLD).pos(25, 23).anchor(50, 50).color(0, 0, 0);
    }
    override function whenFree()
    {
        global.director.pushView(new SoldierMax(), 1, 0); 
        return 1;
    }
    function receiveMsg(msg)
    {
//        trace("receiveMsg", msg);
        if(msg[0] == BUYSOL)
        {
            solNum.text(str(global.user.getSolNum()));
        }
    }
    override function enterScene()
    {
        global.msgCenter.registerCallback(BUYSOL, this);
        solNum.text(str(global.user.getSolNum()));
    }
    override function exitScene()
    {
        global.msgCenter.removeCallback(BUYSOL, this);
    }
}
*/
