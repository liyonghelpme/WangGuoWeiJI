class AllGoods extends MyNode
{
    //var soldier;
    //var healthText;
    //var attText;
    //var defText;

    //var im;
    //var nameText;

    var cl;
    var flowNode;
    const OFFY = 72;
    const ROW_NUM = 5;
    const HEIGHT = OFFY*ROW_NUM;
    const ITEM_NUM = 1;
    var kind;

    //kind EQUIP  eid ---> global.user.equips level, owner, kind 
    //kind DRUG   kindId
    var data;
    //var filterIs = null;

    const EQUIP_KIND = 0;
    const DETAIL_EQUIP = 1;

    /*
    用户当前拥有的药品
    用户当前拥有的装备
    士兵当前拥有的装备
    */
    function cmp(a, b)
    {
        return a[1]-b[1];
    }
    function initData()
    {
        var key;
        var i;
        data = [];

        //药品只需要卖出一定数量即可 药品购买 卖出
        if(kind == DRUG)
        {
            key = drugData.keys();
            for(i = 0; i < len(key); i++)
                data.append([EQUIP_KIND, key[i]]);
        }
        //装备需要区分ID 装备只有购买 卖出 装备得区分
        else if(kind == EQUIP)
        {
            key = equipData.keys();
            for(i = 0; i < len(key); i++)
                data.append([EQUIP_KIND, key[i], 0]);//opened closed
        }
        bubbleSort(data, cmp);

        //id number 
        //列表的count不会改变 只会改变数量 和排序
    }
    //s 操作士兵对象 k 药品或者 武器 复活药水
    //0 1 2 3 stoneNum
    var nums = [];
    function setStoneNum()
    {
        for(var i = 0; i < 4; i++)
            nums[i].text(str(global.user.getGoodsNum(TREASURE_STONE, i)));
    }
    function AllGoods(k)
    {
        kind = k;
        bg = sprite("dialogFriend.png");
        init();
        initData();
        if(kind == DRUG)
            bg.addsprite("allDrug.png").anchor(50, 50).pos(169, 41);
        else if(kind == EQUIP)
        {
            bg.addsprite("allEquip.png").anchor(50, 50).pos(169, 41);
            var stoneNum = bg.addsprite("stoneNum.png").pos(280, 28);

var s = stoneNum.addlabel("", "fonts/heiti.ttf", 20).color(100, 100, 100).pos(45, 18).anchor(0, 50);
            nums.append(s);

s = stoneNum.addlabel("", "fonts/heiti.ttf", 20).color(100, 100, 100).pos(154, 18).anchor(0, 50);
            nums.append(s);

s = stoneNum.addlabel("", "fonts/heiti.ttf", 20).color(100, 100, 100).pos(273, 18).anchor(0, 50);
            nums.append(s);

s = stoneNum.addlabel("", "fonts/heiti.ttf", 20).color(100, 100, 100).pos(380, 18).anchor(0, 50);
            nums.append(s);

            setStoneNum();
        }


        bg.addsprite("closeBut.png").pos(765, 27).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);

        cl = bg.addnode().pos(46, 90).size(703, 357).clipping(1);
        flowNode = cl.addnode();

        updateTab();
        cl.setevent(EVENT_TOUCH, touchBegan);
        cl.setevent(EVENT_MOVE, touchMoved);
        cl.setevent(EVENT_UNTOUCH, touchEnded);
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
        for(var i = rg[0]; i < rg[1]; i++)
        {
            var panel = flowNode.addsprite("dialogMakeDrugBanner.png").pos(0, OFFY*i);
            var id;

            //药品装备的类型ID 没有装备的eid
            var ed;
            if(data[i][0] == EQUIP_KIND)
                id = data[i][1];
            else
            {
                ed = global.user.getEquipData(data[i][1]);
                id = ed.get("kind");
            }

            var obj = panel.addsprite(replaceStr(KindsPre[kind], ["[ID]", str(id)])).pos(36, 35).anchor(50, 50);
            var sca = getSca(obj, [64, 60]);
            obj.scale(sca, sca);
            
            var objData;
            objData = getData(kind, id);
            var num = 0;
            //同种类型药品装备的数量
            if(data[i][0] == EQUIP_KIND)
            {
                num = global.user.getGoodsNum(kind, id);
                var co = [14, 64, 26];
                if(num == 0)
                    co = [99, 42, 47];

panel.addlabel(str(num), "fonts/heiti.ttf", 20).pos(69, 65).anchor(0, 100).color(co[0], co[1], co[2]);
            }
            else if(data[i][0] == DETAIL_EQUIP)
            {
                if(ed.get("owner") != -1)
                {
                    var solData = global.user.getSoldierData(ed.get("owner"));
                    var solName = solData.get("name");
panel.addlabel(solName, "fonts/heiti.ttf", 15).pos(69, 35).anchor(0, 100).color(0, 100, 0);
                }
                var eqLevel = ed.get("level");
panel.addlabel(getStr("eqLevel", ["[LEV]", str(eqLevel)]), "fonts/heiti.ttf", 15).pos(69, 65).anchor(0, 100).color(0, 100, 0);
            }
                
panel.addlabel((objData.get("name") + " ") + objData.get("des"), "fonts/heiti.ttf", 18, FONT_NORMAL, 390, 55, ALIGN_LEFT).pos(135, 10).color(59, 56, 56);
            var butWidth = 69;
            var butHeight = 36;

            var but0;
            var but1;

            //药品 购买 卖出
            //装备 购买 查看
            //子菜单  升级 卖出
            if(kind == DRUG)
            {
                but0 = panel.addsprite("roleNameBut0.png").pos(570, 34).size(butWidth, butHeight).anchor(50, 50).setevent(EVENT_TOUCH, buyIt, i);
but0.addlabel(getStr("buyIt", null), "fonts/heiti.ttf", 18).pos(34, 18).anchor(50, 50);
                if(num > 0)
                {
                    but1 = panel.addsprite("roleNameBut0.png").pos(650, 34).size(butWidth, butHeight).anchor(50, 50).setevent(EVENT_TOUCH, onSell, i);
but1.addlabel(getStr("sell", null), "fonts/heiti.ttf", 18).pos(34, 18).anchor(50, 50);
                }
            }
            else if(kind == EQUIP)
            {
                if(data[i][0] == EQUIP_KIND)
                {
                    but0 = panel.addsprite("roleNameBut0.png").pos(570, 34).size(butWidth, butHeight).anchor(50, 50).setevent(EVENT_TOUCH, buyIt, i);
but0.addlabel(getStr("buyIt", null), "fonts/heiti.ttf", 18).pos(34, 18).anchor(50, 50);
                    if(num == 0)
                        data[i][2] = 0;//没有物品则状态为关闭
                    if(num > 0)
                    {
                        if(data[i][2] == 0)
                        {
                            but1 = panel.addsprite("roleNameBut0.png").pos(650, 34).size(butWidth, butHeight).anchor(50, 50).setevent(EVENT_TOUCH, onView, i);
but1.addlabel(getStr("viewAll", null), "fonts/heiti.ttf", 18).pos(34, 18).anchor(50, 50);
                        }
                        else
                        {
                            but1 = panel.addsprite("roleNameBut0.png").pos(650, 34).size(butWidth, butHeight).anchor(50, 50).setevent(EVENT_TOUCH, onClose, i);
but1.addlabel(getStr("closeAll", null), "fonts/heiti.ttf", 18).pos(34, 18).anchor(50, 50);

                        }
                    }
                }
                //升级 卖出传入 数据位置编号
                else if(data[i][0] == DETAIL_EQUIP)
                {
                    if(ed.get("level") < MAX_EQUIP_LEVEL)//未升级到最高级
                    {
                        but0 = panel.addsprite("roleNameBut0.png").pos(570, 34).size(butWidth, butHeight).anchor(50, 50).setevent(EVENT_TOUCH, onUpgrade, i);
but0.addlabel(getStr("upgrade", null), "fonts/heiti.ttf", 18).pos(34, 18).anchor(50, 50);
                    }

                    but1 = panel.addsprite("roleNameBut0.png").pos(650, 34).size(butWidth, butHeight).anchor(50, 50).setevent(EVENT_TOUCH, onSell, i);
but1.addlabel(getStr("sell", null), "fonts/heiti.ttf", 18).pos(34, 18).anchor(50, 50);

                }
            }
        }
    }
    //查看所有装备
    function onView(n, e, p, x, y, points)
    {
        if(data[p][0] == EQUIP_KIND)
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
        
    //只是弹出数据
    function onSell(n, e, p, x, y, points)
    {
        var addSilver;
        if(kind == DRUG)
        {
            var dd = getData(DRUG, data[p][1]);
            var num = global.user.getGoodsNum(DRUG, data[p][1]);
            addSilver = changeToSilver(dd);
            addSilver["silver"] *= num;

            trace("sell price", addSilver, num, dd);

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
                var edata = global.user.getEquipData(data[p][1]);
                var ed = getData(EQUIP, edata.get("kind"));
                addSilver = changeToSilver(ed);
                trace("sell price", addSilver, ed);

                global.user.doAdd(addSilver);
                global.user.sellEquip(data[p][1]);
                global.httpController.addRequest("goodsC/sellEquip", dict([["uid", global.user.uid], ["eid", data[p][1]], ["silver", addSilver.get("silver")]]), null, null);

                data.pop(p);//拥有的装备是展开的view 应该被删除
                updateTab();
            }
        }
    }
    //升级装备 参数位置 
    function onUpgrade(n, e, p, x, y, points)
    {
        //global.httpController.addRequest("goodsC/upgradeEquip", dict([["uid", global.user.uid], ["eid", p]), null, null);
        //global.user.upgradeEquip(p);
        //initData();
        var eid = data[p][1];
        global.director.pushView(new UpgradeDialog(this, eid), 1, 0);
        //updateTab();
    }

    //tid [id sid]
    function unloadIt(n, e, p, x, y, points)
    {
        global.httpController.addRequest("soldierC/unloadThing", dict([["uid", global.user.uid], ["eid", p]]), null, null);

        global.user.unloadThing(p);
        initData();
        updateTab();
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
    function closeDialog()
    {
        global.director.popView();
    }

    function buyIt(n, e, p, x, y, points)
    {
        global.director.popView();
        var store = new Store(global.director.curScene);
        global.director.pushView(store,  1, 0);
        if(kind == DRUG)
            store.changeTab(DRUG_PAGE);
        else if(kind == EQUIP)
            store.changeTab(EQUIP_PAGE);
    }

    //升级装备 降级装备
    function receiveMsg(para)
    {
        var msgId = para[0];
        if(msgId == UPDATE_EQUIP)
        {
            updateTab(); 
        }
        else if(msgId == UPDATE_TREASURE)//变更宝石数量
        {
            setStoneNum(); 
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
    }
    override function exitScene()
    {
        if(kind == EQUIP)
        {
            global.msgCenter.removeCallback(UPDATE_EQUIP, this);
            global.msgCenter.removeCallback(UPDATE_TREASURE, this);
        }
        super.exitScene();
    }
}
