/*
非全屏对话框 使用 roleNameClose png
全屏对话框使用close2 png
*/
class UpgradeDialog extends MyNode
{
    var scene;
    var eid;
    var curChoose = -1;

    const initX = 80;
    const offX = 120;
    const initY = 212;
    var words;
    var but1;
    function UpgradeDialog(s, e)
    {
        scene = s;
        eid = e;

        bg = sprite("dialogDetail.png").anchor(50, 50).pos(global.director.disSize[0]/2, global.director.disSize[1]/2);
        init();
        bg.addlabel(getStr("upgradeEquip", null), null, 30).anchor(50, 50).pos(264, 26).color(33, 34, 40);

        bg.addsprite("roleNameClose.png").pos(499, 9).setevent(EVENT_TOUCH, closeDialog);
        words = bg.addlabel("", null, 18).pos(264, 122).anchor(50, 50).color(0, 0, 0);
        bg.addlabel(getStr("brokenEquip", null), null, 18).pos(264, 303).anchor(50, 50).color(100, 0, 0);

        var scroll = bg.addsprite("dialogScroll.png").anchor(50, 50).pos(264, 81);
        scroll.addlabel(getStr("useStoneEquip", null), null, 22).pos(252, 32).anchor(50, 50).color(27, 15, 4);

        var i;
        var ed = global.user.getEquipData(eid);
        trace("eid edata", eid, ed);
        for(i = 0; i < 4; i++)
        {
            var sdata = getData(TREASURE_STONE, i);

            var possible = sdata.get("possible");
            var pos0 = 0;
            var pos1 = 0;
            if(ed.get("level") < len(possible)) 
            {
                pos0 = possible[ed.get("level")][0];
                pos1 = possible[ed.get("level")][1];
            }

            var pan = bg.addsprite("chooseStone.png").pos(initX+offX*i, initY).anchor(50, 50).setevent(EVENT_TOUCH, setChoose, i);
            pan.addsprite("stone"+str(i)+".png").pos(54, 82).anchor(50, 50);
            pan.addlabel(getStr("sucPos", ["[POS]", str(pos0)]), null, 18).pos(57, 20).anchor(50, 50).color(31, 17, 5);

            var num = global.user.getGoodsNum(TREASURE_STONE, i);
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

        var sdata = getData(TREASURE_STONE, curChoose);
        var ed = global.user.getEquipData(eid);
        
        var possible = sdata.get("possible");
        var pos0 = 0;
        var pos1 = 0;
        if(ed.get("level") < len(possible))
        {
            pos0 = possible[ed.get("level")][0];
            pos1 = possible[ed.get("level")][1];
        }

        words.text(getStr("stoneLevel", ["[NAME]", sdata.get("name"), "[LEV0]", str(ed.get("level")+1+1), 
                                "[POS0]", str(pos0), "[POS1]", str(pos1)]) );
        var num = global.user.getGoodsNum(TREASURE_STONE, curChoose);
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
        var num = global.user.getGoodsNum(TREASURE_STONE, curChoose);
        //宝石数量足够
        if(num >= 1)
        {
            global.director.popView();
            global.user.changeGoodsNum(TREASURE_STONE, curChoose, -1);
            global.httpController.addRequest("goodsC/upgradeEquip", dict([["uid", global.user.uid], ["eid", eid], ["tid", curChoose]]), upgradeFinish, eid);
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
                    global.user.upgradeEquip(eid);
                    scene.addChild(new UpgradeBanner(getStr("sucUpgrade", null), [0, 100, 0], null));
                }
                else
                {
                    if(con.get("breakEquip") == 0)
                    {
                        scene.addChild(new UpgradeBanner(getStr("failUpgrade", null), [100, 0, 0], null));
                    }
                    else
                    {
                        global.user.breakEquip(eid);
                        scene.addChild(new UpgradeBanner(getStr("failEquip", null), [100, 0, 0], null));
                    }
                }
            }
        }
    }
}
