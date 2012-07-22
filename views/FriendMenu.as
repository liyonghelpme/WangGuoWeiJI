class FriendMenu extends MyNode
{
    var scene;
    function FriendMenu(s)
    {
        scene = s;
        bg = node();
        init();
        var banner = bg.addsprite("pageFriendBanner.png").pos(0, 480).anchor(0, 100);
        bg.addsprite("pageFriendReturn.png").pos(0, 480).anchor(0, 100).setevent(EVENT_TOUCH, returnHome);
        
        var friends = global.friendController.showFriend;
        if(scene.curNum >= (len(friends)-1))
        {
            bg.addsprite("pageFriendNext.png", GRAY).pos(617, -1);
        }
        else
            bg.addsprite("pageFriendNext.png").pos(617, -1).setevent(EVENT_TOUCH, visitNext);

        var title = bg.addsprite("pageFriendTitle.png").pos(17, 13);
        bg.addsprite("pageFriendBut0.png").pos(800, 480).anchor(100, 100);
        banner.addsprite("recharge.png").pos(438, 12).size(100, 41);
        title.addlabel("name", null, 20).pos(100, 22).anchor(0, 50);
        title.addsprite("soldier0.png").pos(39, 41).anchor(50, 50).size(57, 55);
        
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
