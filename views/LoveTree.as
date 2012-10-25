class LoveTree extends FuncBuild
{
    function LoveTree(b)
    {
        baseBuild = b;
    }
    function showLoveDialog()
    {
        
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
