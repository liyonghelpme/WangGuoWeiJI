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
    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;

        temp = bg.addsprite("back.png").anchor(0, 0).pos(148, 96).size(520, 312).color(100, 100, 100, 100);
        temp = bg.addsprite("loginBack.png").anchor(0, 0).pos(166, 145).size(480, 250).color(100, 100, 100, 100);
        temp = bg.addsprite("smallBack.png").anchor(0, 0).pos(201, 65).size(418, 57).color(100, 100, 100, 100);
        but0 = new NewButton("closeBut.png", [40, 39], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], closeDialog, null);
        but0.bg.pos(666, 98);
        addChild(but0);


        var ne = getLevelUpExp(soldier.id, soldier.level);
        var leftExp = ne-soldier.exp;

        var tranLevel = getTransferLevel(soldier);
        var career = getCareerLev(soldier.id); 
        //怪兽不能转职
        //士兵可以转职  转职没有到达最高等级
        var trans = "";
        if(soldier.data["solOrMon"] == 0)//士兵需要转职信息
        {
            var totalName = getStr(CAREER_TIT[career], null)+soldier.data.get("name");
            if(tranLevel > 0)
                trans = getStr("transOk", ["[NAME]", totalName, "[LEV]", str(tranLevel)]);
            else
                trans = getStr("noTrans", ["[NAME]", totalName]);
        }
        var attKind;
        if(soldier.physicAttack > soldier.magicAttack)
            attKind = getStr("physicAtt", null);
        else
            attKind = getStr("magicAtt", null);
            
        line = stringLines(
            getStr("solDetail", 
                ["[ATTKIND]",  attKind, 
                    "[ATTACK]", str(max(soldier.physicAttack, soldier.magicAttack)),
                    "[MAGIC]", str(soldier.magicDefense),
                    "[PHYSIC]", str(soldier.physicDefense),
                    "[HEALTH]", str(soldier.health),
                    "[HEALTH_BOUNDARY]", str(soldier.healthBoundary),
                    "[ATT_SPEED]", getAttSpeedLev(soldier.attSpeed),
                    "[ATT_RANGE]", getAttRangeLev(soldier.attRange),
                    "[HEAL_SPEED]", getRecoverLev(soldier.recoverTime),
                    "[LEV0]", str(soldier.level + 1),
                    "[EXP]", str(leftExp),
                    "[LEV1]", str(soldier.level+2),
                    "[TRANS]", trans,
                ]
            ), 15, 25, [0, 0, 0], FONT_NORMAL );
        line.pos(178, 163);
        bg.add(line);
        temp = bg.addsprite(replaceStr(KindsPre[SOLDIER], ["[ID]", str(soldier.id)])).anchor(50, 50).pos(597, 347).color(100, 100, 100, 100);
        sca = getSca(temp, [88, 89]);
        temp.scale(sca);
        bg.addlabel(soldier.myName, "fonts/heiti.ttf", 30).anchor(50, 50).pos(400, 95).color(32, 33, 40);
    }
    function DetailDialog(sol)
    {
        soldier = sol;
        initView();
    }
    function onInfo()
    {
        global.director.popView();
        global.director.pushView(new ProfessionIntroDialog(null, soldier.id), 1, 0);
    }
    function closeDialog()
    {
        global.director.popView();
    }
}
