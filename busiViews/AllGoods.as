class AllGoods extends MyNode
{
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


    var kind;

    //kind EQUIP  eid ---> global.user.equips level, owner, kind 
    //kind DRUG   kindId
    var data;

    /*
    用户当前拥有的药品
    用户当前拥有的装备
    士兵当前拥有的装备
    */
    function cmp(a, b)
    {
        return a[1]-b[1];
    }
    //物品种类 
    //忽略详细物品
    function initData()
    {
        var key;
        var i;
        data = [];

        //药品只需要卖出一定数量即可 药品购买 卖出
        if(kind == DRUG)
        {
            key = global.user.getAllDrug();
            for(i = 0; i < len(key); i++)
                data.append([EQUIP_KIND, key[i]]);
        }
        //装备需要区分ID 装备只有购买 卖出 装备得区分
        else if(kind == EQUIP)
        {
            key = global.user.getAllEquips();
            for(i = 0; i < len(key); i++)
                data.append([DETAIL_EQUIP, key[i], 0]);
        }
        trace("initData", data);
        bubbleSort(data, cmp);
        while(len(data) < 4)
        {
            data.append([ALL_EMPTY, -1]);
        }

        //id number 
        //列表的count不会改变 只会改变数量 和排序
    }
    //s 操作士兵对象 k 药品或者 武器 复活药水
    //0 1 2 3 stoneNum
    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
        var s;
        temp = bg.addsprite("back.png").anchor(0, 0).pos(0, 0).size(800, 480).color(100, 100, 100, 100);
        temp = bg.addsprite("diaBack.png").anchor(0, 0).pos(38, 10).size(705, 64).color(100, 100, 100, 100);
        but0 = new NewButton("closeBut.png", [41, 41], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], closeDialog, null);
        but0.bg.pos(772, 27);
        addChild(but0);
        temp = bg.addsprite("loginBack.png").anchor(0, 0).pos(30, 79).size(739, 386).color(100, 100, 100, 100);

        temp = bg.addsprite("allEquipTitle.png").anchor(50, 50).pos(169, 43).size(185, 60).color(100, 100, 100, 100);
        if(kind == DRUG)
            temp.texture("allDrugTitle.png", UPDATE_SIZE);


        temp = bg.addsprite("dialogMakeDrugBanner.png").anchor(0, 0).pos(46, 90).size(703, 71).color(70, 70, 70, 100);
        if(kind == EQUIP)
            temp = bg.addlabel(getStr("equipDialog", null), "fonts/heiti.ttf", 18, FONT_NORMAL, 496, 0, ALIGN_LEFT).anchor(0, 0).pos(72, 107).color(100, 100, 100);
        else if(kind == DRUG)
            temp = bg.addlabel(getStr("drugDialog", null), "fonts/heiti.ttf", 18, FONT_NORMAL, 496, 0, ALIGN_LEFT).anchor(0, 0).pos(72, 107).color(100, 100, 100);

        but0 = new NewButton("violetBut.png", [113, 42], getStr("buyDrug", null), null, 20, FONT_NORMAL, [100, 100, 100], buyIt, null);
        but0.bg.pos(667, 125);
        addChild(but0);
        if(kind == EQUIP)
            but0.word.setWords(getStr("buyEquipBut", null));
    }

    function buyIt()
    {
        var store = new Store(global.director.curScene);
        global.director.pushView(store,  1, 0);
        if(kind == DRUG)
            store.changeTab(DRUG_PAGE);
        else if(kind == EQUIP)
            store.changeTab(EQUIP_PAGE);
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
    function AllGoods(k)
    {
        kind = k;
        initView();

        cl = bg.addnode().pos(INIT_X, INIT_Y).size(WIDTH, HEIGHT).clipping(1);
        flowNode = cl.addnode();

        cl.setevent(EVENT_TOUCH, touchBegan);
        cl.setevent(EVENT_MOVE, touchMoved);
        cl.setevent(EVENT_UNTOUCH, touchEnded);

        initData();
        updateTab();
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
    function updateTab()
    {
//        trace("init Drug Dialog View");
        var oldPos = flowNode.pos();
        flowNode.removefromparent();
        flowNode = cl.addnode().pos(oldPos);

        var rg = getRange();
        var temp;
        var sca;
        var but0;
        for(var i = rg[0]; i < rg[1]; i++)
        {
            var panel = flowNode.addsprite("dialogMakeDrugBanner.png").pos(0, OFFY*i);
            panel.put(i);
            var id;

            if(data[i][0] == ALL_EMPTY)
                continue;

            //药品装备的类型ID 没有装备的eid
            var ed;
            if(data[i][0] == EQUIP_KIND)
                id = data[i][1];
            else
            {
                ed = global.user.getEquipData(data[i][1]);
                id = ed.get("kind");
            }

            temp = panel.addsprite(replaceStr(KindsPre[kind], ["[ID]", str(id)])).anchor(50, 50).pos(45, 35).color(100, 100, 100, 100);
            sca = getSca(temp, [68, 56]);
            temp.scale(sca);
            
            var objData;
            objData = getData(kind, id);

            var num = 0;
            if(data[i][0] == EQUIP_KIND)
            {
                num = global.user.getGoodsNum(kind, id);
                var co = [14, 64, 26];
                if(num == 0)
                    co = [99, 42, 47];
            }
            if(kind == DRUG || data[i][0] != EQUIP_KIND)
                temp = panel.addlabel(replaceStr(objData.get("des"), ["[NAME]", objData.get("name")]), "fonts/heiti.ttf", 18, FONT_NORMAL, 467, 0, ALIGN_LEFT).anchor(0, 0).pos(91, 19).color(56, 52, 52);
            
            if(kind == EQUIP)
            {
                if(data[i][0] == EQUIP_KIND)
                {
                    //点击开启某个类型
                    if(num == 0)
                        data[i][2] = 0;
                    if(data[i][2] == 0)//未开启
                    {
                        if(num > 0)
                        {
                            temp = panel.addsprite("retractArrow.png").anchor(50, 50).pos(674, 33).size(22, 23).color(100, 100, 100, 100).setevent(EVENT_TOUCH, onView, i);
                            panel.addlabel(getStr("seeDetail", ["[NUM]", str(num), "[NAME]", objData["name"]]), "fonts/heiti.ttf", 20).anchor(0, 50).pos(96, 36).color(0, 0, 0);
                        }
                        else
                        {
                            panel.addlabel(getStr("noSuchThing", ["[NAME]", objData["name"]]), "fonts/heiti.ttf", 20).anchor(0, 50).pos(96, 36).color(0, 0, 0);
                        }
                    }
                    else
                    {
                        temp = panel.addsprite("retractArrow.png").anchor(50, 50).pos(674, 33).size(22, 23).color(100, 100, 100, 100).setevent(EVENT_TOUCH, onClose, i);
                        temp.scale(100, -100);
                        panel.addlabel(getStr("closeDetail", ["[NUM]", str(num), "[NAME]", objData["name"]]), "fonts/heiti.ttf", 20).anchor(0, 50).pos(96, 36).color(0, 0, 0);
                    }
                }
                else if(data[i][0] == DETAIL_EQUIP)
                {
                    //右侧按钮
                    but0 = new NewButton("roleNameBut1.png", [74, 37], getStr("sell", null), null, 18, FONT_NORMAL, [100, 100, 100], onSell, i);
                    but0.bg.pos(654, 35);
                    panel.add(but0.bg);
                     
                    var equipOwner = ed.get("owner");
                    if(equipOwner != -1)
                    {
                        //左侧按钮
                        but0 = new NewButton("roleNameBut0.png", [72, 36], getStr("unloadIt", null), null, 18, FONT_NORMAL, [100, 100, 100], onUnload, i);
                        but0.bg.pos(573, 36);
                        panel.add(but0.bg);
                    }
                }
            }
            else if(kind == DRUG)
            {
                panel.addlabel(str(num), "fonts/heiti.ttf", 20).anchor(0, 50).pos(63, 52).color(8, 61, 20);
                if(num > 0)
                {
                }
            }
        }
    }
    //卸下装备
    function onUnload(n, e, curNum, x, y, points)
    {
        global.user.unloadThing(data[curNum][1]);
        updateTab();
    }
    //查看所有装备
    function onView(n, e, p, x, y, points)
    {
        if(kind == EQUIP)
        {
            if(data[p][0] == EQUIP_KIND && data[p][2] == 0)
            {
                var id = data[p][1];
                var num = global.user.getGoodsNum(kind, id);
                if(num > 0)//未开启
                {
                    data[p][2] = 1;
                    var allEquips = global.user.getKindEquip(data[p][1]); 
                    trace("allEquips", allEquips);
                    for(var i = 0; i < len(allEquips); i++)//在
                    {
                        data.insert(p+1, [DETAIL_EQUIP, allEquips[i], 0]);
                    }
                }
                updateTab();
            }
        }
    }
    function onClose(n, e, p, x, y, points)
    {
        if(data[p][0] == EQUIP_KIND)
        {
            data[p][2] = 0;
            for(var i = p+1; i < len(data);)
            {
                if(data[i][0] == DETAIL_EQUIP)
                {
                    data.pop(i);
                }
                else
                    break;
            }
        }
        updateTab();
    }
        
    var selled = 0;
    //只是弹出数据
    //卖出成功需要提示
    function onSell(p)
    {
        var addSilver;
        if(kind == DRUG)
        {
            var dd = getData(DRUG, data[p][1]);
            var num = global.user.getGoodsNum(DRUG, data[p][1]);
            addSilver = changeToSilver(dd);
            addSilver["silver"] *= num;
        }
        else if(kind == EQUIP)
        {
            var edata = global.user.getEquipData(data[p][1]);
            var ed = getData(EQUIP, edata.get("kind"));
            addSilver = changeToSilver(ed);
        }
        if(selled == 0)
        {
            selled = 1;
            global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("sureToSell", ["[NUM]", str(addSilver["silver"])]), [100, 100, 100], null));
            return;
        }
        else
        {
            selled = 0;
        }

        if(kind == DRUG)
        {
            global.user.doAdd(addSilver);
            global.user.sellDrug(data[p][1]);
            global.httpController.addRequest("goodsC/sellDrug", dict([["uid", global.user.uid], ["kind", data[p][1]], ["silver", addSilver.get("silver")]]), null, null);

            //data.pop(p); 不能删除物品类型 只是更新数量
            updateTab();
        }
        else if(kind == EQUIP)
        {
            if(data[p][0] == DETAIL_EQUIP)
            {
                global.user.doAdd(addSilver);
                global.user.sellEquip(data[p][1]);
                global.httpController.addRequest("goodsC/sellEquip", dict([["uid", global.user.uid], ["eid", data[p][1]], ["silver", addSilver.get("silver")]]), null, null);

                data.pop(p);//拥有的装备是展开的view 应该被删除
                updateTab();
            }
        }
        showMultiPopBanner(addSilver);

    }


    var lastPoints;
    var accMove;
    function touchBegan(n, e, p, x, y, points)
    {
        selled = 0;
        lastPoints = n.node2world(x, y);
        accMove = 0;
        selectNum = -1;
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
    var selectNum = -1;
    function touchEnded(n, e, p, x, y, points)
    {
        var newPos = n.node2world(x, y);
        if(accMove < 10)
        {
            var child = checkInChild(flowNode, newPos);
            if(child != null)
            {
                selectNum = child.get();
                if(kind == EQUIP && data[selectNum][0] == EQUIP_KIND)
                {
                    if(data[selectNum][2] == 0)
                        onView(null, null, selectNum, null, null, null);
                    else
                        onClose(null, null, selectNum, null, null, null);
                }
            }
        }
        var curPos = flowNode.pos();
        var rows = (len(data)+ITEM_NUM-1)/ITEM_NUM;
        curPos[1] = min(0, max(-rows*OFFY+HEIGHT, curPos[1]));
        flowNode.pos(curPos);
        updateTab();
    }
    function closeDialog()
    {
        global.director.popView();
    }


    //升级装备 降级装备
    function receiveMsg(para)
    {
        var msgId = para[0];
        if(msgId == UPDATE_EQUIP)
        {
            initData();
            updateTab(); 
        }
        else if(msgId == UPDATE_TREASURE)//变更宝石数量
        {
        }
        else if(msgId == BUY_DRUG)
        {
            initData();
            updateTab();
        }
    }
    override function enterScene()
    {
        super.enterScene();
        if(kind == EQUIP)
        {
            global.msgCenter.registerCallback(UPDATE_EQUIP, this);
            global.msgCenter.registerCallback(UPDATE_TREASURE, this);
        }
        else if(kind == DRUG)
        {
            global.msgCenter.registerCallback(BUY_DRUG, this);
        }
    }
    override function exitScene()
    {
        global.msgCenter.removeCallback(BUY_DRUG, this);
        global.msgCenter.removeCallback(UPDATE_EQUIP, this);
        global.msgCenter.removeCallback(UPDATE_TREASURE, this);
        super.exitScene();
    }
}
