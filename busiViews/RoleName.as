class RoleName extends MyNode
{
    var soldier;
    var inputView;
    var warnText;
    var male;
    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
        temp = bg.addsprite("back.png").anchor(0, 0).pos(186, 134).size(448, 237).color(100, 100, 100, 100);
        temp = bg.addsprite("parchment.png").anchor(0, 0).pos(204, 163).size(413, 188).color(100, 100, 100, 100);
        temp = bg.addsprite("smallBack.png").anchor(0, 0).pos(264, 111).size(302, 51).color(100, 100, 100, 100);
        inputView = v_create(V_INPUT_VIEW, 348, 211, 230, 50);
                            
        warnText = bg.addlabel(getStr("warnText", null), "fonts/heiti.ttf", 15).anchor(0, 50).pos(346, 276).color(43, 25, 9);
        temp = bg.addsprite(replaceStr(KindsPre[SOLDIER], ["[ID]", str(soldier.id)])).anchor(50, 50).pos(281, 256).color(100, 100, 100, 100);
        sca = getSca(temp, [118, 139]);
        temp.scale(sca);
        bg.addlabel(getStr("solName", null), "fonts/heiti.ttf", 30).anchor(50, 50).pos(419, 137).color(32, 33, 40);
        but0 = new NewButton("roleNameBut0.png", [138, 49], getStr("rand", null), null, 25, FONT_NORMAL, [100, 100, 100], randomName, null);
        but0.bg.pos(302, 367);
        addChild(but0);
        but0 = new NewButton("roleNameBut1.png", [138, 49], getStr("ok", null), null, 25, FONT_NORMAL, [100, 100, 100], nameIt, null);
        but0.bg.pos(513, 368);
        addChild(but0);
    }
    function RoleName(s, sol)
    {
        //scene = s;
        soldier = sol;
        initView();
        male = soldier.data.get("maleOrFemale");
        
        var solVal = global.user.soldiers.values();
        for(var j = 0; j < len(solVal); j++)
        {
            var solN = solVal[j]["name"];
            for(var i = 0; i < len(soldierName);)
            {
                var tempName = getStr(soldierName[i][0], null);
                if(tempName == solN)
                {
                    soldierName.pop(i);
                }
                else
                    i++;
            }
        }
        randomName();
    }
    function randomName()
    {
        if(len(soldierName) <= 0)
            return;
        var i = rand(len(soldierName));
        var times = 0;
        while(soldierName[i][1] != male && times < 10)
        {
            i = rand(len(soldierName));
            times += 1;
        }
        inputView.text(getStr(soldierName[i][0], null));
    }
    function nameIt()
    {
        var n = inputView.text();
        if(n == "")
        {
            warnText.text(getStr("nameNotNull", null));
            warnText.visible(1);
            return;
        }
        if(LANGUAGE == 0)
        {
            if(len(n) > 12)//3*4
            {
                warnText.text(getStr("nameTooLong", null));
                warnText.visible(1);
                return;
            }
        }
        var allSoldier = global.user.soldiers;
        var val = allSoldier.values();
        for(var i = 0; i < len(val); i++)
        {
            if(val[i]["name"] == n)
            {
                warnText.text(getStr("nameSame", null));
                warnText.visible(1);
                return;
            }
        }

        soldier.setName(inputView.text());
        soldier.finishName();//结束士兵的命名状态
        global.msgCenter.sendMsg(FINISH_NAME, soldier);
        global.director.popView();

        global.taskModel.doAllTaskByKey("call", 1);
    }

    function closeDialog()
    {
        global.director.popView();
    }
    override function enterScene()
    {
        super.enterScene();
        v_root().addview(inputView);
    }

    override function exitScene()
    {
        inputView.removefromparent();
        super.exitScene();
    }
}
