/*
非全局菜单显示的时候 隐藏场景菜单
显示结束的时候 回复场景菜单

pushView view
关闭view的时候 需要回复

menu检测自己不是最高层 则消失 当自己是最高层则显示


攻击速度 快慢
攻击范围 大小
生命值回复速度 快慢
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
/*
构建对话框的时候 关闭场景的菜单栏
关闭对话框的时候需要重性显示场景的对话框

如果图形化工具 能够 控制多个元素整体移动 
*/
class DetailDialog extends MyNode
{
    var soldier;
    function DetailDialog(sol)
    {
        soldier = sol;
        bg = sprite("dialogDetail.png").pos(global.director.disSize[0]/2, global.director.disSize[1]/2).anchor(50, 50);
        init();
        bg.addlabel(soldier.myName, null, 30).anchor(50, 50).pos(264, 26).color(0, 0, 0);
        bg.addsprite("roleNameClose.png").pos(499, 9).setevent(EVENT_TOUCH, closeDialog);
        var contentNode = bg.addnode().pos(36, 88);
        var offY = 0;
        var OFFSET = 25;
        var WORD_SIZE = 18;
        contentNode.addlabel(getStr("phyAtt", ["[NUM]", str(sol.physicAttack)]), null, WORD_SIZE).pos(0, offY).color(0, 0, 0);
        contentNode.addlabel(getStr("magAtt", ["[NUM]", str(sol.magicAttack)]), null, WORD_SIZE).pos(150, offY).color(0, 0, 0);
        offY += OFFSET;

        contentNode.addlabel(getStr("phyDef", ["[NUM]", str(sol.physicDefense)]), null, WORD_SIZE).pos(0, offY).color(0, 0, 0);
        contentNode.addlabel(getStr("magDef", ["[NUM]", str(sol.magicDefense)]), null, WORD_SIZE).pos(150, offY).color(0, 0, 0);
        offY += OFFSET;

        contentNode.addlabel(getStr("healthAndBoundary", ["[HEALTH]", str(sol.health), "[BOUND]", str(sol.healthBoundary)]), null, WORD_SIZE).pos(0, offY).color(0, 0, 0);
        offY += OFFSET;
        contentNode.addlabel(getStr("attSpeed", ["[LEV]", getAttSpeedLev(sol.attSpeed)]), null, WORD_SIZE).pos(0, offY).color(0, 0, 0);
        offY += OFFSET;

        contentNode.addlabel(getStr("attRange", ["[LEV]", getAttRangeLev(sol.attRange)]), null, WORD_SIZE).pos(0, offY).color(0, 0, 0);
        offY += OFFSET;
        contentNode.addlabel(getStr("recLife", ["[LEV]", getRecoverLev(sol.recoverTime)]), null, WORD_SIZE).pos(0, offY).color(0, 0, 0);
        offY += OFFSET;

        var ne = getLevelUpExp(sol.id, sol.level);

        contentNode.addlabel(getStr("levVal", ["[LEV1]", str(sol.level+1+1), "[EXP]", str(ne-sol.exp), "[LEV2]", str(sol.level+1+1)]), null, WORD_SIZE).pos(0, offY).color(0, 0, 0);
        offY += OFFSET;

        var tranLevel = getTransferLevel(sol);
        var career = getCareerLev(soldier.id); 
        var totalName = getStr(CAREER_TIT[career], null)+soldier.data.get("name");
        if(tranLevel > 0)
            contentNode.addlabel(getStr("nextTrans", ["[CAREER]", totalName, "[LEV]", str(tranLevel)]), null, WORD_SIZE).pos(0, offY).color(0, 0, 0);
        else
            contentNode.addlabel(getStr("noTransfer", ["[CAREER]", totalName]), null, WORD_SIZE).pos(0, offY).color(0, 0, 0);
        offY += OFFSET;
//        trace("soldierpng", soldier.id);
        var solPic = bg.addsprite("soldier"+str(soldier.id)+".png").pos(460, 283).anchor(50, 50);
        var sca = getSca(solPic, [90, 90]);
        solPic.scale(sca);

        var block = solPic.addsprite("whiteBlock.png").anchor(0, 100).pos(20, 10).scale(-100, 100).setevent(EVENT_TOUCH, onInfo);
        block.addsprite("infoIcon.png").pos(27, 21).anchor(50, 50).scale(-100, 100);

        //global.director.curScene.disableMenu();
        showCastleDialog();
    }
    function onInfo()
    {
        //global.director.popView();
        //global.director.curScene.enableMenu();
        closeCastleDialog();
        global.director.pushView(new ProfessionIntroDialog(null, soldier.id), 1, 0);
    }
    function closeDialog()
    {
        closeCastleDialog();
        //global.director.popView();
        //global.
    }
}
