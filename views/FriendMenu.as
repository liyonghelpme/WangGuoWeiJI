class FriendMenu extends MyNode
{
    var scene;
    var challengeBut = null;
    var heartYet = null;
    //好友场景的 邻居数据 是 拷贝得到的 不能通过本地修改来 修改全局的状态
    //需要访问全局接口来修改状态
    function FriendMenu(s)
    {
        scene = s;
        bg = node();
        init();
        var banner = bg.addsprite("pageFriendBanner.png").pos(0, 480).anchor(0, 100);
        bg.addsprite("pageFriendReturn.png").pos(0, 480).anchor(0, 100).setevent(EVENT_TOUCH, returnHome);
        
        //var friends = global.friendController.showFriend;
        var friends = global.friendController.getFriends(scene.kind);

        //通过排行榜访问 其它用户 不能点击下一个
        if(scene.curNum == -1 || scene.curNum >= (len(friends)-1) )
        {
            bg.addsprite("pageFriendNext.png", GRAY).pos(617, -1);
        }
        else
            bg.addsprite("pageFriendNext.png").pos(617, -1).setevent(EVENT_TOUCH, visitNext);

        var title = bg.addsprite("pageFriendTitle.png").pos(17, 13);
        bg.addsprite("pageFriendBut0.png").pos(800, 480).anchor(100, 100);
        banner.addsprite("recharge.png").pos(438, 12).size(100, 41);
title.addlabel("name", "fonts/heiti.ttf", 20).pos(100, 22).anchor(0, 50);
        title.addsprite("soldier0.png").pos(39, 41).anchor(50, 50).size(57, 55);
        
        if(scene.kind == VISIT_NEIBOR)
        {
            if(scene.user.get("challengeYet") == 1)
                challengeBut = bg.addsprite("challengeNeibor.png", GRAY).pos(741, 280).anchor(50, 50);
            else
                challengeBut = bg.addsprite("challengeNeibor.png").pos(741, 280).anchor(50, 50).setevent(EVENT_TOUCH, onChallenge);
            if(scene.user.get("heartYet") == 1)
                heartYet = bg.addsprite("heartPlus.png", GRAY).pos(741, 208).anchor(50, 50);
            else
                heartYet = bg.addsprite("heartPlus.png").pos(741, 208).anchor(50, 50).setevent(EVENT_TOUCH, onSendHeart);

            var sca = getSca(challengeBut, [70, 60]);
            challengeBut.scale(sca);
        }
    }
    function onSendHeart()
    {
        heartYet.texture("heartPlus.png", GRAY);
        heartYet.setevent(EVENT_TOUCH, null);

        var user = scene.user;
        global.friendController.sendHeart(user["uid"]);
        global.httpController.addRequest("friendC/sendHeart", dict([["uid", global.user.uid], ["fid", user.get("uid")], ["mid", global.user.getNewMsgId()]]), null, null);
    }
    //挑战结束返回好友页面
    //已经有一个 挑战排行榜
    //挑战邻居有什么意义
    function onChallenge()
    {
        //challengeBut.removefromparent();
        //challengeBut = bg.addsprite("challengeNeibor.png", GRAY).pos(708, 211);
        challengeBut.texture("challengeNeibor.png", GRAY);
        challengeBut.setevent(EVENT_TOUCH, null);

        var user = scene.user;
        var cs = new ChallengeScene(user.get("uid"), user.get("id"), 0, 0, CHALLENGE_NEIBOR, user);

        global.director.pushScene(cs);
        global.director.pushView(new VisitDialog(cs), 1, 0);
        cs.initData();
    }
    function returnHome()
    {
        global.director.popScene();
    }
    function visitNext()
    {
        scene.visitNext(); 
    }
}
