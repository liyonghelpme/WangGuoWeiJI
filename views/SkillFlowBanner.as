//skill FlowBanner
//选择技能
//控制技能释放的位置
//如果英雄死亡 则 停止释放
//清空技能列表
class SkillFlowBanner extends MyNode
{
    const WIDTH = 103;
    const HEIGHT = 90;
    const COL_NUM = 5;
    const ITEM_NUM = 1;
    const PANEL_WIDTH = 90;
    const PANEL_HEIGHT = 90;
    const TOTAL_WIDTH = WIDTH*COL_NUM;

    var pausePage;
    var soldier = null;
    var skillList = [];
    var cl;
    var flowNode;

    var shadowWord;
    var words;
    function SkillFlowBanner(s)
    {
        pausePage = s;
        bg = node();
        init();
        cl = bg.addnode().size(TOTAL_WIDTH, 82).pos(9, 384).clipping(1);
        flowNode = cl.addnode();

        setSoldier(null);

        shadowWord = bg.addsprite("storeBlack.png").pos(10, 323).visible(0);
        words = null;
        
        cl.setevent(EVENT_TOUCH, touchBegan);
        cl.setevent(EVENT_MOVE, touchMoved);
        cl.setevent(EVENT_UNTOUCH, touchEnded);
    }
    var accMove;
    var lastPoints;
    //kind level coldTime ready
   
    //准备好则不显示shadow
    //没有准备好则显示shadow
    function update(diff)
    {
        if(soldier != null && soldier.state == MAP_SOL_DEAD)
        {
            setSoldier(null);
        }
        else
        {
            //var now = time();
            for(var i = 0; i < len(skillList); i++)
            {
                var ready = skillList[i][3];
                var shadow = allPanels[i].get(1);
                if(ready)
                {
                    if(shadow != null)
                    {
                        shadow.removefromparent();
                    }
                    continue;
                }
                else
                {
                    if(shadow == null)
                    {
                        var panel = allPanels[i];
                        var pSize = panel.prepare().size();
                        shadow = sprite("skillShadow.png").anchor(0, 100).pos(0, pSize[1]);
                        panel.add(shadow, 1, 1);//tag = 1
                    }
                        
                    var skillId = skillList[i][0];

                    var skTime = skillList[i][2];
                    //拯救技能 升级减少冷却时间
                    //单体攻击 群体攻击 直线攻击
                    //冷却时间是由 士兵timer决定的
                    var coldTime = getSkillColdTime(soldier.sid, skillId);
                    var sSize = shadow.prepare().size();
                    var rate = max((coldTime-skTime), 0)*100/coldTime;//leftTime
                    shadow.size(sSize[0], sSize[1]*rate/100);
                }
            }
        }
    }
    override function enterScene()
    {
        super.enterScene();
        pausePage.scene.sceneSlowTimer.addTimer(this);
        //global.msgCenter.registerCallback(UPDATE_SKILL_STATE, this);
    }
    //使用技能tar！=null 施法成功
    //取消技能
    //士兵管理数据 这里 管理view 如果数据没有ready 则显示 shadow
    function finishSkill(tar)
    {
        if(tar != null)
        {
            var now = time();
            var selNum = selSkill.get();
            skillList[selNum][3] = 0;//ready = 0 施法士兵 修改自身状态
            skillList[selNum][2] = 0;//coldTime now
            updateSkillPanel(soldier);
        }
        trace("finishSkill", words);
        clearSelSkill();
    }
    function clearSelSkill()
    {
        shadowWord.visible(0);
        words.removefromparent();
        words = null;
        selSkill.texture("mapUnSel.png");
        selSkill = null;
    }
    /*
    function receiveMsg(param)
    {
        trace("receiveMsg", param);
        var msgId = param[0];
        if(msgId == UPDATE_SKILL_STATE)
        {
            if(param[1] == MAP_FINISH_SKILL)
            {
                finishSkill();
            }
        }

    }
    */

    override function exitScene()
    {
        pausePage.scene.sceneSlowTimer.removeTimer(this);
        super.exitScene();
    }
    var curSel;
    function touchBegan(n, e, p, x, y, points)
    {
        //if(selSkill == null)//没有进入技能释放状态
        //如果进入技能释放状态 如果当前点击到其它技能则切换技能
        {
            curSel = null;
            accMove = 0;
            lastPoints = n.node2world(x, y);

            var child = checkInChild(flowNode, lastPoints);
            if(child != null)
            {
                var selNum = child.get();
                if(skillList[selNum][3] == 1)//技能已经准备完善
                {
                    if(selSkill == child)//新选择如果和当前选择技能一致则取消技能
                    {
                        pausePage.scene.cancelSkill();
                        clearSelSkill();
                    }
                    else//新选择不同于当前技能
                    {
                        if(selSkill != null)//选择其它技能放弃当前技能                         {
                            clearSelSkill();
                        child.texture("mapSel.png");
                        curSel = child;
                    }
                }
            }
        }
    }

    function touchMoved(n, e, p, x, y, points)
    {
        //if(selSkill == null)//没有进入技能释放状态
        {
            var oldPos = lastPoints;
            lastPoints = n.node2world(x, y);
            var difx = lastPoints[0]-oldPos[0];
            
            var curPos = flowNode.pos();
            curPos[0] += difx;
            flowNode.pos(curPos);

            accMove += abs(difx);
        }
    }

    var selSkill = null;
    //点击背景地图 选择技能
    function touchEnded(n, e, p, x, y, points)
    {
        //if(selSkill == null)//没有进入技能释放状态
        {
            var newPos = n.node2world(x, y);

            if(curSel != null && accMove >= 10)
            //移动步子太大 取消选择
            {
                curSel.texture("mapUnSel.png");
            }
            if(accMove < 10 && curSel != null)
            //移动步子小确认选择
            {
                selSkill = curSel;
                var selectNum = curSel.get();
                //当前没有选择技能 则选择技能

                
                var sdata = getData(SKILL, skillList[selectNum][0]); 
                var skillKind = sdata.get("kind");
                var w = "";
                if(skillKind == SINGLE_ATTACK_SKILL || skillKind == SPIN_SKILL)
                {
                    w = getStr("selTarget", null);
                }
                else if(skillKind == MULTI_ATTACK_SKILL)
                {
                    w = getStr("selMulti", null);
                }
                else if(skillKind == LINE_SKILL)
                {
                    w = getStr("selRow", null);
                }
                else if(skillKind == HEAL_SKILL || skillKind == MULTI_HEAL_SKILL || skillKind == SAVE_SKILL)
                    w = getStr("selOurSol", null);
                words = shadowWord.addlabel(w, null, 25);
                var wSize = words.prepare().size();
                var sSize = shadowWord.prepare().size();
                sSize[0] = max(wSize[0], sSize[0]);
                shadowWord.size(sSize);
                words.anchor(50, 50).pos(sSize[0]/2, sSize[1]/2);
                shadowWord.visible(1);


                pausePage.scene.selectSkill(soldier, skillList[selectNum][0]);
            }
            
            var curPos = flowNode.pos();
            var cols = (len(skillList)+ITEM_NUM-1)/ITEM_NUM;
            curPos[0] = min(0, max(-cols*WIDTH+TOTAL_WIDTH, curPos[0]));
            flowNode.pos(curPos);
        }
    }

    //内部更新所有面板状态函数
    function updateSkillPanel(sol)
    {
        allPanels = [];
        soldier = sol;
        if(soldier == null)
            skillList = [];
        else
            skillList = sol.skillList;//global.user.getSolSkills(soldier.sid).items();//skillId level lastColdTime
        flowNode.removefromparent();
        flowNode = cl.addnode(); 
        for(var i = 0; i < len(skillList); i++)
        {
            var panel = flowNode.addsprite("mapUnSel.png").pos(i*WIDTH, 0);
            allPanels.append(panel);//对应相应技能位置 面板
            
            var skillPic = panel.addsprite(replaceStr(KindsPre[SKILL], ["[ID]", str(skillList[i][0])])).anchor(50, 50).pos(PANEL_WIDTH/2, PANEL_HEIGHT/2);
            var sca = getSca(skillPic, [PANEL_WIDTH, PANEL_HEIGHT]);
            skillPic.scale(sca);

            panel.addsprite("skillLevel.png").pos(53, 66).anchor(50, 50);
            panel.addlabel(getStr("skillLevel", ["[LEV]", str(skillList[i][1])]), null, 15).pos(53, 66).anchor(50, 50).color(100, 100, 100);

            var ready = skillList[i][3];

            if(!ready)
            {
                var pSize = panel.prepare().size();
                var shadow = sprite("skillShadow.png").anchor(0, 100).pos(0, pSize[1]);
                panel.add(shadow, 1, 1);//tag = 1
            }

            panel.put(i);
        }
    }
    //所有的技能菜单
    //外部调用 设定 当前士兵函数
    var allPanels = [];
    function setSoldier(sol)
    {
        trace("setSoldier");
        if(soldier == sol)
            return;
        if(soldier != null)
        {
            soldier.clearSkillState();
        }
        if(sol != null)
        {
            sol.setSkillState();
        }
        updateSkillPanel(sol); 
        
    }

}
