class TreasureBox extends MyNode
{
    var headNode = null;
    const INITX = 198;
    const INITY = 179;

    function onHelpOpen()
    {
        global.httpController.addRequest("friendC/helpOpen", dict([["uid", global.user.uid], ["fid", scene.user["uid"]]]), null, null)
        scene.helpOpen();
        updateState();
        global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("helpSuc", null), [100, 100, 100], null));

        global.tashModel.doAllTaskByKey("helpOpenBox", 1);
    }
    //帮助别人开启宝箱初始化头像
    function initHead()
    {
        if(headNode != null)
            headNode.removefromparent();
        headNode = bg.addnode().pos(INITX, INITY);
        var OFFX = 76;
        var OFFY = 87;
        var curX = 0;
        var curY = -OFFY;
        var ITEM_NUM = 4;
        var temp;
        for(var i = 0; i < PARAMS["maxBoxFriNum"]; i++)
        {
            if(i%ITEM_NUM == 0)
            {
                curY += OFFY;
                curX = 0;
            }

            temp = headNode.addsprite("friendBlock.png").anchor(50, 50).pos(curX+55/2, curY+55/2).size(getParam("blockSize"), getParam("blockSize")).color(100, 100, 100, 100);
            if(i < len(scene.helperList))//显示当前已经有的好友
            { 
                temp.addlabel(scene.papayaIdName[i][1], "fonts/heiti.ttf", 15).anchor(50, 50).pos(28, 73).color(0, 0, 0);
                temp.addsprite(avatar_url(scene.papayaIdName[i][0])).anchor(50, 50).pos(28, 28).size(55, 55).color(100, 100, 100, 100);
            }
            else//没有人空位
            {
                temp.addsprite("unkownFriendHead.png").anchor(50, 50).pos(28, 28).size(55, 55).color(100, 100, 100, 100);
                temp.addlabel(getStr("unknown", null), "fonts/heiti.ttf", 15).anchor(50, 50).pos(28, 73).color(0, 0, 0);
            }

            curX += OFFX; 
        }
    }
    //两次点击 自己开启宝箱
    var opened = 0;
    //开启自己宝箱初始化头像
    function initHelperHead()
    {
        if(headNode != null)
            headNode.removefromparent();
        headNode = bg.addnode().pos(INITX, INITY);

        var OFFX = 78;
        var OFFY = 87;
        var curX = 0;
        var curY = -OFFY;
        var ITEM_NUM = 4;
        var temp;
        var but0;

        for(var i = 0; i < PARAMS["maxBoxFriNum"]; i++)
        {
            if(i%ITEM_NUM == 0)
            {
                curY += OFFY;
                curX = 0;
            }

            temp = headNode.addsprite("friendBlock.png").anchor(50, 50).pos(curX+55/2, curY+55/2).size(getParam("blockSize"), getParam("blockSize")).color(100, 100, 100, 100);
            if(i < len(global.user.helperList))//显示当前已经有的好友
            { 
                temp.addlabel(global.user.papayaIdName[i][1], "fonts/heiti.ttf", 15).anchor(50, 50).pos(28, 73).color(100, 100, 100);
                if(global.user.helperList[i] == -1)
                    temp.addsprite("goldFriend.png").anchor(50, 50).pos(28, 28).size(55, 55).color(100, 100, 100, 100);
                else
                    temp.addsprite(avatar_url(global.user.papayaIdName[i][0])).anchor(50, 50).pos(28, 28).size(55, 55).color(100, 100, 100, 100);
                temp.addlabel(global.user.papayaIdName[i][1], "fonts/heiti.ttf", 15).anchor(50, 50).pos(28, 73).color(0, 0, 0);
            }
            else//没有人空位
            {
                temp.addsprite("unkownFriendHead.png").anchor(50, 50).pos(28, 28).size(55, 55).color(100, 100, 100, 100).setevent(EVENT_TOUCH, onSelfOpen);
                but0 = new NewButton("greenButton0.png", [60, 23], getStr("oneGold", ["[NUM]", str(getParam("selfOpenGold")), "[KIND]", "gold.png"]), null, 15, FONT_NORMAL, [0, 0, 0], onSelfOpen, null);
                but0.bg.pos(29, 71);
                temp.add(but0.bg);
            }

            curX += OFFX; 
        }
    }
    function onSelfOpen()
    {
        if(opened == 0)
        {
            opened += 1;
            global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("openOnePos", null), [100, 100, 100], null));
            return;
        }
        else
        {
            opened = 0;
            var cost = dict([["gold", getParam("selfOpenGold")]]);
            global.user.doCost(cost);
            showMultiPopBanner(cost2Minus(cost));
            global.httpController.addRequest("friendC/selfOpen", dict([["uid", global.user.uid]]), null, null);
            global.user.selfOpen();
            updateState();
        }
    }
    function cmp(a, b)
    {
        var ea = getData(EQUIP, a);
        var eb = getData(EQUIP, b);
        return ea["level"] - eb["level"];
    }
    var boxReward = null;
    function genBoxReward()
    {
        var reward = [];
        var temp;
        var i;

        //药水数量少于最大限制可以获得新药水
        //不奖励 金币 > 0 的装备 药水
        if(global.user.getDrugTotalNum() < getParam("maxDrugNum"))
        {
            var allDrugs = drugData.keys(); 
            temp = [];
            for(i = 0; i < len(allDrugs); i++)
            {
                var dData = getData(DRUG, allDrugs[i]);
                if(dData["gold"] == 0)
                    temp.append(allDrugs[i]);
            }
            allDrugs = temp;
            var rd = rand(len(allDrugs));
            reward.append([DRUG, allDrugs[rd], 1]);
        }
        
        var allEquip = equipData.keys();
        var level = global.user.getValue("level");
        bubbleSort(allEquip, cmp);

        var levelEquip = [];
        for(i = 0; i < len(allEquip); i++)
        {
            var ed = getData(EQUIP, allEquip[i]);
            if(ed["level"] <= level && ed["gold"] == 0)
            {
                levelEquip.append(allEquip[i]);
                if(len(levelEquip) > getParam("maxRandEquip"))
                    levelEquip.pop(0);
            }
        }
        rd = rand(len(levelEquip));
        reward.append([EQUIP, levelEquip[rd], 1, global.user.getNewEid()]);
        return reward;
    }
    //正在开启宝箱 则阻塞 等待 服务器返回数据
    //阻止关闭
    var inOpen = 0;
    function openBox()
    {
        if(inOpen)
            return;
        inOpen = 1;
        boxReward = genBoxReward();
        global.httpController.addRequest("friendC/openBox", dict([["uid", global.user.uid], ["reward", json_dumps(boxReward)]]), openBoxOver, null);
    }
    //物品
    //资源
    
    //[kind id number]
    function openBoxOver(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            global.director.popView();
            con = json_loads(con);
            for(var i = 0; i < len(boxReward); i++)
            {
                var kind = boxReward[i][0];
                var tid = boxReward[i][1];
                var num = boxReward[i][2];
                if(kind == EQUIP)
                {
                    var eid = boxReward[i][3];
                    global.user.getNewEquip(eid, tid, 0); 
                }
                else
                {
                    global.user.changeGoodsNum(kind, tid, num);
                }
            }
            global.user.openBox();
            global.director.pushView(new BoxReward(boxReward), 1, 0);
            global.taskModel.doAllTaskByKey("openBox", 1);
        }
        inOpen = 0;
    }
    function updateState()
    {
        if(kind == BOX_FRIEND)
        {
            var index = scene.helperList.index(global.user.uid);
            if(index != -1 || len(scene.helperList) >= PARAMS["maxBoxFriNum"])
            {
                openBut.setGray();
                openBut.setCallback(null);//已经帮助过了
            }
            initHead();
        }
        else if(kind == BOX_SELF)
        {
            if(len(global.user.helperList) >= PARAMS["maxBoxFriNum"])
            {
                openBut.word.setWords(getStr("openNow", null));
                openBut.setCallback(openBox);
            }
            initHelperHead();
        }
    }

    function onOk()
    {
        if(inOpen)
            return;
        global.director.popView();
    }
    function onFindFriend()
    {
        doShare(getStr("shareBox", ["[NAME]", global.user.name]), null, null, null, null);
        global.taskModel.doAllTaskByKey("askOpen", 1);
    }
    var openBut;
    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
        temp = bg.addsprite("back.png").anchor(0, 0).pos(150, 91).size(520, 312).color(100, 100, 100, 100);
        temp = bg.addsprite("loginBack.png").anchor(0, 0).pos(169, 135).size(481, 252).color(100, 100, 100, 100);
        temp = bg.addsprite("nonFullWhiteBack.png").anchor(0, 0).pos(184, 175).size(314, 182).color(100, 100, 100, 100);
        temp = bg.addsprite("smallBack.png").anchor(0, 0).pos(201, 63).size(418, 57).color(100, 100, 100, 100);
        temp = bg.addsprite("scroll.png").anchor(0, 0).pos(223, 114).size(374, 57).color(100, 100, 100, 100);
        bg.addlabel(getStr("openBox", null), "fonts/heiti.ttf", 30).anchor(50, 50).pos(401, 91).color(32, 33, 40);
        if(kind == BOX_FRIEND)
            bg.addlabel(getStr("helpFriOpen", ["[NAME]", scene.user["name"]]), "fonts/heiti.ttf", 20).anchor(50, 50).pos(414, 146).color(43, 25, 9);
        else if(kind == BOX_SELF)
            bg.addlabel(getStr("mistGiftInBox", null), "fonts/heiti.ttf", 20).anchor(50, 50).pos(414, 146).color(43, 25, 9);
            
        but0 = new NewButton("roleNameBut1.png", [174, 54], getStr("ok", null), null, 27, FONT_NORMAL, [100, 100, 100], onOk, null);
        but0.bg.pos(519, 402);
        addChild(but0);
        if(kind == BOX_FRIEND)
            but0 = new NewButton("roleNameBut0.png", [174, 54], getStr("helpOpenBox", null), null, 27, FONT_NORMAL, [100, 100, 100], onHelpOpen, null);
        else if(kind == BOX_SELF)
            but0 = new NewButton("roleNameBut0.png", [174, 54], getStr("findFriend", null), null, 27, FONT_NORMAL, [100, 100, 100], onFindFriend, null);
            
        but0.bg.pos(299, 402);
        addChild(but0);
        openBut = but0;
        temp = bg.addsprite("treasureBox.png").anchor(0, 0).pos(522, 226).size(108, 92).color(100, 100, 100, 100);

        updateState();
    }
    var kind;
    var scene;
    function TreasureBox(k, s)
    {
        kind = k;
        scene = s;
        initView();
    }
        
}
