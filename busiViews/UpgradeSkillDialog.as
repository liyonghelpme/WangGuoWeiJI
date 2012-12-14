/*
非全屏对话框 使用 roleNameClose png
全屏对话框使用close2 png
*/
class UpgradeSkillDialog extends MyNode
{
    var scene;
    var curChoose = -1;

    const initX = 147;
    const offX = 132;
    const initY = 183;

    var words;
    var but1;
    var soldierId;
    var skillId;
    var panels = [];
    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
        temp = bg.addsprite("back.png").anchor(50, 50).pos(401, 247).size(604, 344).color(100, 100, 100, 100);
        temp = bg.addsprite("loginBack.png").anchor(0, 0).pos(122, 124).size(557, 277).color(100, 100, 100, 100);
        temp = bg.addsprite("scroll.png").anchor(0, 0).pos(130, 97).size(541, 67).color(100, 100, 100, 100);
        temp = bg.addsprite("smallBack.png").anchor(0, 0).pos(159, 45).size(484, 62).color(100, 100, 100, 100);
        words = bg.addlabel(getStr("magicStoneLevel", null), "fonts/heiti.ttf", 19).anchor(50, 50).pos(411, 363).color(66, 46, 28);
        but0 = new NewButton("roleNameBut0.png", [190, 60], getStr("buyMagic", null), null, 30, FONT_NORMAL, [100, 100, 100], onBuy, null);
        but0.bg.pos(251, 416);
        addChild(but0);
        but0 = new NewButton("roleNameBut1.png", [190, 60], getStr("upgrade", null), null, 30, FONT_NORMAL, [100, 100, 100], onUpgrade, null);
        but0.bg.pos(545, 417);
        addChild(but0);
        but1 = but0;

        bg.addlabel(getStr("skillPower", null), "fonts/heiti.ttf", 20).anchor(50, 50).pos(400, 135).color(43, 25, 9);
        bg.addlabel(getStr("upgradeSkill", null), "fonts/heiti.ttf", 33).anchor(50, 50).pos(400, 78).color(32, 33, 40);

        but0 = new NewButton("closeBut.png", [41, 41], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], closeDialog, null);
        but0.bg.pos(697, 80);
        addChild(but0);   


        var i;
        var skillLevel = global.user.getSolSkillLevel(soldierId, skillId); 
        var CURX = initX;
        var CURY = initY;
        for(i = 0; i < 4; i++)
        {
            var sdata = getData(MAGIC_STONE, i);
            var possible = sdata.get("possible");
            var posi = possible[min(skillLevel, len(possible)-1)];

            temp = bg.addsprite("whiteBox.png").anchor(0, 0).pos(CURX, CURY).size(109, 153).color(100, 100, 100, 100).setevent(EVENT_TOUCH, setChoose, i);
            panels.append(temp);
            temp = bg.addsprite(replaceStr(KindsPre[MAGIC_STONE], ["[ID]", str(i)])).anchor(50, 50).pos(CURX+54, 265).size(63, 58).color(100, 100, 100, 100);

            bg.addlabel(getStr("sucPos", ["[POS]", str(posi)]), "fonts/heiti.ttf", 21).anchor(50, 50).pos(CURX+54, 201).color(30, 17, 5);


            var num = global.user.getGoodsNum(MAGIC_STONE, i);
            bg.addlabel(getStr("treaNum", ["[NUM]", str(num)]), "fonts/heiti.ttf", 21).anchor(50, 50).pos(CURX+54, 314).color(30, 17, 5);
            CURX += offX;
        }
    }
    function UpgradeSkillDialog(s, sid, skid)
    {
        scene = s;
        soldierId = sid;
        skillId = skid;
        initView();

        setChoose(null, null, 0, null, null, null);

    }
    //检测石头是否可用

    function setChoose(n, e, p, x, y, points)
    {
        if(p >= 4)
            return;
        if(curChoose == p)
            return;

        if(curChoose != -1)
        {
            panels[curChoose].texture("whiteBox.png");
        }
        curChoose = p;
        panels[curChoose].texture("blueBox.png");

        var sdata = getData(MAGIC_STONE, curChoose);
        var level = global.user.getSolSkillLevel(soldierId, skillId);
        
        var possible = sdata.get("possible");
        var posi = possible[min(level, len(possible)-1)];

        words.text(getStr("magicStoneLevel", ["[NAME]", sdata.get("name"), "[LEV0]", str(level+1+1), 
                                "[POS0]", str(posi)]) );

        var num = global.user.getGoodsNum(MAGIC_STONE, curChoose);

        if(num == 0)
        {
            but1.setGray();
            //but1.setCallback(null);
        }
        else
        {
            but1.setCallback(onUpgrade);
            but1.setWhite();
        }
    }
    function closeDialog()
    {
        global.director.popView();
    }
    function onBuy()
    {
        global.director.popView();

        var store = new Store(global.director.curScene);
        global.director.pushView(store,  1, 0);
        store.changeTab(NEW_GOODS);
    }
    //使用宝石等待服务器返回
    function onUpgrade()
    {
        var num = global.user.getGoodsNum(MAGIC_STONE, curChoose);
        //宝石数量足够
        if(num >= 1)
        {
            global.director.popView();
            global.user.changeGoodsNum(MAGIC_STONE, curChoose, -1);
            global.httpController.addRequest("soldierC/upgradeSkill", dict([["uid", global.user.uid], ["soldierId", soldierId], ["skillId", skillId], ["stoneId", curChoose]]), upgradeFinish, null);
            global.taskModel.doAllTaskByKey("upgradeSkill", 1);
        }
        else
        {
            var objData = getData(MAGIC_STONE, curChoose);
            global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("sorryNum", ["[NAME]", objData["name"]]), [100, 100, 100], null));
        }
    }

    function upgradeFinish(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            con = json_loads(con);
            if(con.get("id") != 0)
            {
                if(con.get("suc") == 1)
                {
                    global.user.upgradeSkill(soldierId, skillId);
                    global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("sucUpgradeSkill", null), [0, 100, 0], null));
                }
                else
                {
                    global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("failUpgradeSkill", null), [100, 0, 0], null));
                }
            }
        }
    }
}
