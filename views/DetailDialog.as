/*
非全局菜单显示的时候 隐藏场景菜单
显示结束的时候 回复场景菜单

pushView view
关闭view的时候 需要回复

menu检测自己不是最高层 则消失 当自己是最高层则显示

*/
function getAttSpeedLev(spe)
{
    if(spe >= 1500)
        return getStr("slow", null);
    if(spe >= 1000)
        return getStr("mid", null);
    return getStr("fast", null);
}
function getAttRangeLev(ra)
{
    if(ra <= 64)
        return getStr("near", null);
    if(ra <= 256)
        return getStr("mid", null);
    return getStr("far", null);
}
function getRecoverLev(rc)
{
    if(rc >= 60)
        return getStr("slow", null);
    if(rc >= 30)
        return getStr("mid", null);
    return getStr("fast", null);
}
class DetailDialog extends MyNode
{
    var soldier;
    function DetailDialog(sol)
    {
        soldier = sol;
        bg = sprite("dialogDetail.png").pos(global.director.disSize[0]/2, global.director.disSize[1]/2).anchor(50, 50);
        init();
        bg.addlabel(soldier.myName+"("+soldier.data.get("name")+")", null, 30).anchor(50, 50).pos(280, 26).color(0, 0, 0);
        bg.addsprite("roleNameClose.png").pos(499, 9).setevent(EVENT_TOUCH, closeDialog);
        var contentNode = bg.addnode().pos(36, 88);
        contentNode.addlabel(getStr("attVal", ["[NUM]", str(sol.attack)]), null, 20).pos(0, 0).color(0, 0, 0);
        contentNode.addlabel(getStr("defVal", ["[NUM]", str(sol.defense)]), null, 20).pos(0, 30).color(0, 0, 0);
        contentNode.addlabel(getStr("healthAndBoundary", ["[HEALTH]", str(sol.health), "[BOUND]", str(sol.healthBoundary)]), null, 20).pos(0, 60).color(0, 0, 0);
        contentNode.addlabel(getStr("attSpeed", ["[LEV]", getAttSpeedLev(sol.attSpeed)]), null, 20).pos(0, 90).color(0, 0, 0);
        contentNode.addlabel(getStr("attRange", ["[LEV]", getAttRangeLev(sol.attRange)]), null, 20).pos(0, 120).color(0, 0, 0);
        contentNode.addlabel(getStr("recLife", ["[LEV]", getRecoverLev(sol.recoverTime)]), null, 20).pos(0, 150).color(0, 0, 0);

        var ne = getLevelNeedExp(sol.data.get("expId"), sol.level);

        contentNode.addlabel(getStr("levVal", ["[LEV1]", str(sol.level), "[EXP]", str(ne-sol.exp), "[LEV2]", str(sol.level+1)]), null, 20).pos(0, 180).color(0, 0, 0);

        var tranLevel = sol.getTransferLevel();
        if(tranLevel > 0)
            contentNode.addlabel(getStr("nextTrans", ["[LEV]", str(tranLevel)]), null, 20).pos(0, 210).color(0, 0, 0);
        else
            contentNode.addlabel(getStr("noTransfer", null), null, 20).pos(0, 210).color(0, 0, 0);

        trace("soldierpng", soldier.id);
        var sol = bg.addsprite("soldier"+str(soldier.id)+".png").pos(460, 283).anchor(50, 50);
        var sca = getSca(sol, [90, 90]);
        sol.scale(sca);

        var block = bg.addsprite("whiteBlock.png").anchor(0, 100).pos(20, 10).scale(-100, 100).setevent(EVENT_TOUCH, onInfo);
        block.addsprite("infoIcon.png").pos(27, 21).anchor(50, 50).scale(-100, 100);

        global.director.curScene.disableMenu();
    }
    function onInfo()
    {
        global.director.popView();
        global.director.pushView(new ProfessionIntroDialog(null, sol.id), 1, 0);
    }
    function closeDialog()
    {
        global.director.popView();
        global.director.curScene.enableMenu();
    }
}
