//全局场景 curScene ---> 成员显示弹出对话框
//popBanner 3000 ms 弹出一个
//最多显示一屏幕的banner

//向上弹出 接着消失
class Banner extends MyNode
{
    var controller;
    function Banner(c, w)
    {
        controller = c;
        bg = sprite("storeBlack.png").pos(global.director.disSize[0]/2, global.director.disSize[1]/2).anchor(50, 50);
        init();
        var word = colorWordsNode(w, 20, [100, 100, 100], [89, 72, 18]);
        word.anchor(50, 50);
        bg.add(word);

        var wSize = word.size();
        var bSize = bg.prepare().size();
        bg.size(max(wSize[0]+10, bSize[0]), bSize[1]);
        var nBsize = bg.size();
        word.pos(nBsize[0]/2, nBsize[1]/2);
        bg.addaction(sequence(delaytime(2000), fadeout(1000), callfunc(removeBan)));
    }
    function removeBan()
    {
        controller.removeBan();
    }
}
class BannerController extends MyNode
{
    const OFFY = 60;
    //等待显示的banner
    var bannerStack = [];
    //已经显示的banner
    var showed = [];
    function BannerController()
    {
        //banner 直接加到场景上
        bg = node();
        init();
    }
    function addBanner(w)
    {
        bannerStack.append(w);
    }
    function showNew()
    {
        if(len(bannerStack) > 0)
        {
            //当前显示的banner整体上移动一下
            for(var i = 0; i < len(showed); i++)
            {
                var sh = showed[i];
                var oldP = sh.pos();
                oldP[1] -= OFFY;
                sh.pos(oldP);
            }
            var w = bannerStack.pop();
            var newBan = new Banner(this, w);
            showed.append(newBan);
            global.director.curScene.addChild(newBan);
        }
    }
    function removeBan()
    {
        if(len(showed) > 0)
        {
            var ban = showed.pop();
            ban.removeSelf();
        }
    }
    function update(diff)
    {
        showNew();
    }
    override function enterScene()
    {
        super.enterScene();
        global.myAction.addAct(this);
    }
    override function exitScene()
    {
        global.myAction.removeAct(this);
        super.exitScene();
    }
}
