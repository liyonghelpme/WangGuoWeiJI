/*
非全屏对话框 使用 roleNameClose png
全屏对话框使用close2 png
*/
class UpgradeSkillDialog extends MyNode
{
    var scene;
    var curChoose = -1;

    const initX = 80;
    const offX = 120;
    const initY = 212;
    var words;
    var but1;
    var soldierId;
    var skillId;
    function UpgradeSkillDialog(s, sid, skid)
    {
        scene = s;
        soldierId = sid;
        skillId = skid;

        bg = sprite("dialogDetail.png").anchor(50, 50).pos(global.director.disSize[0]/2, global.director.disSize[1]/2);
        init();
        bg.addlabel(getStr("upgradeSkill", null), null, 30).anchor(50, 50).pos(264, 26).color(33, 34, 40);

        bg.addsprite("roleNameClose.png").pos(499, 9).setevent(EVENT_TOUCH, closeDialog);
        words = bg.addlabel("", null, 18).pos(264, 122).anchor(50, 50).color(0, 0, 0);
        //bg.addlabel(getStr("brokenEquip", null), null, 18).pos(264, 303).anchor(50, 50).color(100, 0, 0);

        var scroll = bg.addsprite("dialogScroll.png").anchor(50, 50).pos(264, 81);
        scroll.addlabel(getStr("useStoneMagic", null), null, 22).pos(252, 32).anchor(50, 50).color(27, 15, 4);


        var i;
        var skillLevel = global.user.getSolSkillLevel(soldierId, skillId); 
        trace("skillLevel", skillLevel, soldierId, skillId);

        for(i = 0; i < 4; i++)
        {
            var sdata = getData(MAGIC_STONE, i);

            var possible = sdata.get("possible");
            var posi = possible[min(skillLevel, len(possible)-1)];


            var pan = bg.addsprite("chooseStone.png", ARGB_8888).pos(initX+offX*i, initY).anchor(50, 50).setevent(EVENT_TOUCH, setChoose, i);
            pan.addsprite(replaceStr(KindsPre[MAGIC_STONE], ["[ID]", str(i)]), ARGB_8888).pos(54, 82).anchor(50, 50);

            pan.addlabel(getStr("sucPos", ["[POS]", str(posi)]), null, 18).pos(57, 20).anchor(50, 50).color(31, 17, 5);

            var num = global.user.getGoodsNum(MAGIC_STONE, i);
            pan.addlabel(getStr("treaNum", ["[NUM]", str(num)]), null, 18).pos(57, 144).anchor(50, 50).color(0, 0, 0);
        }



        var but0 = bg.addsprite("roleNameBut0.png").pos(147, 347).anchor(50, 50).size(214, 65).setevent(EVENT_TOUCH, onBuy);
        but0.addlabel(getStr("buyIt", null), null, 35).pos(107, 32).anchor(50, 50).color(100, 100, 100);

        but1 = bg.addsprite("roleNameBut0.png").pos(377, 347).anchor(50, 50).size(214, 65).setevent(EVENT_TOUCH, onUpgrade);
        but1.addlabel(getStr("upgrade", null), null, 35).pos(107, 32).anchor(50, 50).color(100, 100, 100);

        setChoose(null, null, 0, null, null, null);

    }
    //检测石头是否可用

    var greenPan = null;
    function setChoose(n, e, p, x, y, points)
    {
        if(p >= 4)
            return;
        if(curChoose == p)
            return;
        if(greenPan != null)
        {
            greenPan.removefromparent();
            greenPan = null;
        }
        greenPan = bg.addsprite("stoneChoose.png").pos(initX+offX*p, initY).anchor(50, 50);
        curChoose = p;

        var sdata = getData(MAGIC_STONE, curChoose);
        var level = global.user.getSolSkillLevel(soldierId, skillId);
        
        var possible = sdata.get("possible");
        var posi = possible[min(level, len(possible)-1)];

        words.text(getStr("magicStoneLevel", ["[NAME]", sdata.get("name"), "[LEV0]", str(level+1+1), 
                                "[POS0]", str(posi)]) );

        var num = global.user.getGoodsNum(MAGIC_STONE, curChoose);
        if(num == 0)
        {
            but1.setevent(EVENT_TOUCH, null);
            but1.texture("roleNameBut0.png", GRAY);
        }
        else
        {
            but1.setevent(EVENT_TOUCH, onUpgrade);
            but1.texture("roleNameBut0.png", WHITE);
        }
    }
    function closeDialog()
    {
        global.director.popView();
    }
    function onBuy(n, e, p, x, y, points)
    {
        global.director.popView();

        var store = new Store(global.director.curScene);
        global.director.pushView(store,  1, 0);
        store.changeTab(store.NEW_GOODS);
    }
    //使用宝石等待服务器返回
    function onUpgrade(n, e, p, x, y, points)
    {
        var num = global.user.getGoodsNum(MAGIC_STONE, curChoose);
        //宝石数量足够
        if(num >= 1)
        {
            global.director.popView();
            global.user.changeGoodsNum(MAGIC_STONE, curChoose, -1);
            global.httpController.addRequest("soldierC/upgradeSkill", dict([["uid", global.user.uid], ["soldierId", soldierId], ["skillId", skillId], ["stoneId", curChoose]]), upgradeFinish, null);
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
                    scene.addChild(new UpgradeBanner(getStr("sucUpgradeSkill", null), [0, 100, 0], null));
                }
                else
                {
                    scene.addChild(new UpgradeBanner(getStr("failUpgradeSkill", null), [100, 0, 0], null));
                }
            }
        }
    }
}
