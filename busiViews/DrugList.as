class DrugList extends MyNode
{
    var data;
    var cl;
    var flowNode;
    const OFFY = 75;
    const ROW_NUM = 4;
    const ITEM_NUM = 1;
    const WIDTH = 710;
    const HEIGHT = 297;
    const PANEL_WIDTH = 703;
    const PANEL_HEIGHT = 72;
    const INIT_X = 46;
    const INIT_Y = 164;

    var scene;
    var kind;
    var soldier;
    function DrugList(s)
    {
        scene = s;
        kind = scene.kind;
        soldier = scene.soldier;

        initView();


        initData();
        updateTab();
    }
    function initView()
    {
        bg = node();
        init();
        
        cl = bg.addnode().pos(INIT_X, INIT_Y).size(WIDTH, HEIGHT).clipping(1);
        flowNode = cl.addnode();

        cl.setevent(EVENT_TOUCH, touchBegan);
        cl.setevent(EVENT_MOVE, touchMoved);
        cl.setevent(EVENT_UNTOUCH, touchEnded);
    }

    function initData()
    {
        var key;
        var i;
        data = [];
        if(kind == DRUG)
        {
            key = global.user.drugs.keys();
            for(i = 0; i < len(key); i++)
            {
                var num = global.user.getGoodsNum(DRUG, key[i]);
                if(num > 0)
                    data.append([FREE_EQUIP, key[i]]);
            }
        }
        //kind level owner
        else if(kind == EQUIP)
        {
            var usedEquips = [];
            var freeEquips = [];
            var equips = global.user.equips;
            key = equips.keys();
            for(i = 0; i < len(key); i++)
            {
                var val = equips[key[i]];
                var owner = val.get("owner");
                if(owner != -1)
                {
                    if(owner == soldier.sid)//仅显示 当前士兵的装备
                        usedEquips.append([USE_EQUIP, key[i]]);
                }
                else
                    freeEquips.append([FREE_EQUIP, key[i]]);
            }
            data = usedEquips+freeEquips;

        }
        //2 12 22 32 relive drug
        while(len(data) < 4)
        {
            data.append([EMPTY_PANEL, -1]);
        }
    }


    function getRange()
    {
        var curPos = flowNode.pos();
        var lowRow = -curPos[1]/OFFY;
        var upRow = (-curPos[1]+HEIGHT+OFFY-1)/OFFY;
        var rowNum = len(data);
        return [max(0, lowRow-ROW_NUM), min(rowNum, upRow+ROW_NUM)];
    }
    /*
    药品存储药品的类型ID
    装备存储装备的 eid
    */
    function onUnloadIt(curNum)
    {
        //global.httpController.addRequest("soldierC/unloadThing", dict([["uid", global.user.uid], ["eid", data[curNum][1]]]), null, null);
        global.user.unloadThing(data[curNum][1]);
        updateData();
        updateTab();
    }
    function updateTab()
    {
//        trace("init Drug Dialog View");
        var oldPos = flowNode.pos();
        flowNode.removefromparent();
        flowNode = cl.addnode().pos(oldPos);

        var temp;
        var sca;
        var but0;

        var rg = getRange();
        for(var i = rg[0]; i < rg[1]; i++)
        {
            var curNum = i; 
            var panel = flowNode.addsprite("dialogMakeDrugBanner.png").pos(0, OFFY*i);

            if(data[i][0] == EMPTY_PANEL)
                continue;
            
            var id;
            var ifUse = 0;
            //显示使用的士兵名字
            //装备显示强化等级
            var useData = null;
            if(data[i][0] == USE_EQUIP)
                ifUse = 1;
            if(kind == DRUG)
            {
                id = data[i][1];
            }
            else if(kind == EQUIP)
            {
                useData = global.user.getEquipData(data[i][1]);
                id = useData.get("kind");
            }

            temp = panel.addsprite(replaceStr(KindsPre[kind], ["[ID]", str(id)])).anchor(50, 50).pos(45, 35).color(100, 100, 100, 100);
            sca = getSca(temp, [68, 56]);
            temp.scale(sca);

            var objData;
            objData = getData(kind, id);
            temp = panel.addlabel(objData.get("name") + " " + objData.get("des"), "fonts/heiti.ttf", 18, FONT_NORMAL, 467, 0, ALIGN_LEFT).anchor(0, 0).pos(91, 19).color(56, 52, 52);

            if(kind == DRUG)
            {
                var num;
                num = global.user.getGoodsNum(DRUG, id);
                var co = [14, 64, 26];
                if(num == 0)
                    co = [99, 42, 47];

                panel.addlabel(str(num), "fonts/heiti.ttf", 20).anchor(0, 50).pos(63, 52).color(8, 61, 20);

                but0 = new NewButton("roleNameBut0.png", [72, 36], getStr("useIt", null), null, 18, FONT_NORMAL, [100, 100, 100], onUseIt, curNum);
                but0.bg.pos(631, 35);
                panel.add(but0.bg);

                if(num == 0)
                {
                    but0.setGray();
                    but0.setCallback(null);
                }
            }
            else if(kind == EQUIP)
            {
                but0 = new NewButton("roleNameBut0.png", [72, 36], getStr("unloadIt", null), null, 18, FONT_NORMAL, [100, 100, 100], onUnloadIt, curNum);
                if(ifUse == 0)
                {
                    but0.word.setWords(getStr("useIt", null));
                    but0.setCallback(onUseIt);
                }
                but0.bg.pos(654, 36);
                panel.add(but0.bg);
            }
        }
    }

    var lastPoints;
    var accMove;
    function touchBegan(n, e, p, x, y, points)
    {
        lastPoints = n.node2world(x, y);
        accMove = 0;
    }
    function touchMoved(n, e, p, x, y, points)
    {
        var oldPos = lastPoints;
        lastPoints = n.node2world(x, y);
        var dify = lastPoints[1]-oldPos[1];
        var curPos = flowNode.pos();
        curPos[1] += dify;
        flowNode.pos(curPos);

        accMove += abs(dify);
    }
    function touchEnded(n, e, p, x, y, points)
    {
        var curPos = flowNode.pos();
        var rows = (len(data)+ITEM_NUM-1)/ITEM_NUM;
        curPos[1] = min(0, max(-rows*OFFY+HEIGHT, curPos[1]));
        flowNode.pos(curPos);
        updateTab();
    }


    function onUseIt(curNum)
    {
        var p = data[curNum][1];

        if(kind == EQUIP)
        {
            //相同属性装备 不能装备多件
            var ret = global.user.checkSoldierEquip(soldier.sid, p);
            if(ret == 0)
            {
                global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("oneEquipCon", null), [100, 100, 100], null));
                return;
            }
        }

        //使用药水 需要展示效果 先计算效果 再产生实际效果 主要是 % 比的效果不易计算
        if(kind == DRUG)
        {
            var effect = soldier.getDrugEffect(p);
            var its = effect.items()[0];
            global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("opSucDrug", ["[NAME]", soldier.myName, "[NUM]", str(its[1]), "[KIND]", getStr(its[0], null)]), [100, 100, 100], null));
        }
        //增加物理魔法 生命值上限
        else if(kind == EQUIP)
        {
            var equipKind = global.user.getEquipData(p)["kind"];
            effect = getGain(kind, equipKind);
            its = effect.items()[0];
            trace("equip Gain", effect, kind, p, equipKind);
            global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("opSucDrug", ["[NAME]", soldier.myName, "[NUM]", str(its[1]), "[KIND]", getStr(its[0], null)]), [100, 100, 100], null));
            

            //脱下装备也提示套装失效
        }
        global.user.useThing(kind, p, soldier);

        if(kind == EQUIP)
        {
            //如果士兵NAME 收集全套张则提示
            var edata = global.user.getEquipData(p);
            var ekind = edata.get("kind");
            var eStaticData = getData(EQUIP, ekind);
            var suit = eStaticData["suit"];
            trace("equipSuit", edata, ekind, suit);
            if(suit != 0)
            {
                var allEquips = global.user.getSoldierEquipData(soldier.sid);
                var allEquipKinds = [];
                for(var i = 0; i < len(allEquips); i++)
                {
                    allEquipKinds.append(allEquips[i]["kind"]);
                }
                ret = checkFullEquip(allEquipKinds, suit);
                if(ret)
                {
                    global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("collectEquip", ["[SNAME]", soldier.myName, "[ENAME]", edata["name"]]), [100, 100, 100], null));
                    //装备和技能
                    var skillData = getData(EQUIP_SKILL, suit);
                    skillData = getData(SKILL, skillData["skillId"]);
                    trace("suit skllId", suit, skillData);
                    global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("getSkill", ["[SNAME]", soldier.myName, "[SKNAME]", skillData["name"]]), [100, 100, 100], null));
                }
            }
        }
    }

    /*
    更新装备数据 不改变装备位置
    新购买的装备 显示在最后？ 还是显示在前面
    BUY_EQUIP
    SELL_EQUIP
    USE_EQUIP
    //使用装备 卸载装备 不调整装备位置
    */
    function updateData()
    {
        var key;
        var i;
        //kind level owner
        if(kind == EQUIP)
        {
            for(i = 0; i < len(data); i++)
            {
                var eid = data[i][1];
                if(eid != -1)
                {
                    var eData = global.user.getEquipData(eid);
                    if(eData["owner"] != -1)
                        data[i][0] = USE_EQUIP;
                    else
                        data[i][0] = FREE_EQUIP;
                }
            }
        }
    }
    //士兵装备后 应该改变装备的状态 但是不应该调整装备的位置
    function receiveMsg(para)
    {
        var msgId = para[0];
        if(msgId == UPDATE_EQUIP)
        {
            var subMsgId = para[1][1];
            //使用装备 卸载装备
            if(subMsgId == UPDATE_USE_EQUIP)
                updateData();
            //购买装备
            else
                initData();
            updateTab(); 
        }
        else if(msgId == BUY_DRUG)
        {
            initData();
            updateTab();
        }
        else if(msgId == USE_DRUG)
        {
            initData();
            updateTab();
        }
    }
    override function enterScene()
    {
        super.enterScene();

        if(kind == EQUIP)
            global.msgCenter.registerCallback(UPDATE_EQUIP, this);
        else if(kind == DRUG)
        {
            global.msgCenter.registerCallback(BUY_DRUG, this);
            global.msgCenter.registerCallback(USE_DRUG, this);
        }
    }
    override function exitScene()
    {
        global.msgCenter.removeCallback(USE_DRUG, this);
        global.msgCenter.removeCallback(BUY_DRUG, this);
        global.msgCenter.removeCallback(UPDATE_EQUIP, this);
        super.exitScene();
    }
}
