class DrugDialog extends MyNode
{
    var soldier;
    var healthText;
    var attText;
    var defText;
    var im;
    var nameText;


    var kind;

    //kind EQUIP  eid ---> global.user.equips level, owner, kind 
    //kind DRUG   kindId
    var data;

    /*
    用户当前拥有的药品
    用户当前拥有的装备
    士兵当前拥有的装备
    */


    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
        bg.addsprite("back.png").anchor(0, 0).pos(0, 0).size(800, 480).color(100, 100, 100, 100);
        bg.addsprite("diaBack.png").anchor(0, 0).pos(38, 10).size(705, 64).color(100, 100, 100, 100);
        but0 = new NewButton("closeBut.png", [41, 41], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], closeDialog, null);
        but0.bg.pos(772, 27);
        addChild(but0);
        bg.addsprite("loginBack.png").anchor(0, 0).pos(30, 79).size(739, 386).color(100, 100, 100, 100);

        bg.addsprite("moneyBack.png").anchor(0, 0).pos(274, 27).size(450, 33).color(100, 100, 100, 100);
        bg.addsprite("solDefense.png").anchor(0, 0).pos(584, 30).size(25, 28).color(100, 100, 100, 100);
        bg.addsprite("solAttack.png").anchor(0, 0).pos(438, 30).size(23, 28).color(100, 100, 100, 100);
        bg.addsprite("solHealth.png").anchor(0, 0).pos(279, 31).size(29, 25).color(100, 100, 100, 100);
        attText = bg.addlabel(getStr("attText", null), "fonts/heiti.ttf", 20).anchor(0, 50).pos(464, 43).color(100, 100, 100);
        defText = bg.addlabel(getStr("defText", null), "fonts/heiti.ttf", 20).anchor(0, 50).pos(615, 44).color(100, 100, 100);
        healthText = bg.addlabel(getStr("healthText", null), "fonts/heiti.ttf", 20).anchor(0, 50).pos(315, 43).color(100, 100, 100);
        nameText = bg.addlabel(soldier.myName, "fonts/heiti.ttf", 22).anchor(50, 50).pos(212, 44).color(28, 15, 4);
        im = bg.addsprite(replaceStr(KindsPre[SOLDIER], ["[ID]", str(soldier.id)])).anchor(50, 50).pos(108, 40).color(100, 100, 100, 100);
        sca = getSca(im, [90, 73]);
        im.scale(sca);

        temp = bg.addsprite("dialogMakeDrugBanner.png").anchor(0, 0).pos(46, 90).size(703, 71).color(70, 70, 70, 100);
        temp = bg.addlabel(getStr("drugDes", null), "fonts/heiti.ttf", 18, FONT_NORMAL, 496, 0, ALIGN_LEFT).anchor(0, 0).pos(72, 107).color(100, 100, 100);
        if(kind == EQUIP)
            temp.text(getStr("equipDialog", null));

        but0 = new NewButton("violetBut.png", [113, 42], getStr("buyDrug", null), null, 20, FONT_NORMAL, [100, 100, 100], buyIt, null);
        but0.bg.pos(667, 125);
        addChild(but0);
        if(kind == EQUIP)
        {
            but0.word.setWords(getStr("buyEquipBut", null));
        }

    }
    function onFreeMake()
    {
        if(kind == DRUG)
        {
        }
        else if(kind == EQUIP)
        {
        }
    }

    //s 操作士兵对象 k 药品或者 武器 复活药水
    //DRUG EQUIP RELIVE
    function DrugDialog(s, k)
    {
        kind = k;
        soldier = s;
        initView();
        addChild(new DrugList(this));
    }

    
    function closeDialog()
    {
        global.director.popView();
    }

    //没有装备购买装备 回来之后继续使用装备
    function buyIt()
    {
        var store = new Store(global.director.curScene);
        global.director.pushView(store,  1, 0);
        if(kind == DRUG)
            store.changeTab(DRUG_PAGE);
        else if(kind == EQUIP)
            store.changeTab(EQUIP_PAGE);
    }

    //只保留当前引用的士兵的SID 而数据从最新的士兵实体获取
    function updateSoldier(sol)
    {
        if(sol.sid == soldier.sid)
        {
            im.texture("soldier"+str(soldier.id)+".png");
            nameText.text(soldier.myName);
            healthText.text(str(soldier.health)+"/"+str(soldier.healthBoundary));

            attText.text(str(soldier.attack));
            defText.text(str(soldier.defense));
        }
    }
    function receiveMsg(para)
    {
        var msgId = para[0];
        if(msgId == UPDATE_SOL)
            updateSoldier(para[1]);
    }
    override function enterScene()
    {
        super.enterScene();
        global.msgCenter.registerCallback(UPDATE_SOL, this);
        updateSoldier(soldier);
    }
    override function exitScene()
    {
        global.msgCenter.removeCallback(UPDATE_SOL, this);
        super.exitScene();
    }
}
