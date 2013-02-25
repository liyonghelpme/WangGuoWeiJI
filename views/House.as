
/*
采用组合的方式 而不是继承的方式 
访问特殊功能 的接口的时候就需要考虑差异性

包含数据  和 功能
baseBuild 基础功能对象的引用
民居朝向:

whenFree:
*/
class House extends FuncBuild
{
    function House(b)
    {
        baseBuild = b;
    }
}

class Decor extends FuncBuild
{
    function Decor(b)
    {
        baseBuild = b;
    }
    /*
    override function whenFree()
    {
        return 1; 
    }
    */
}
class Castle extends FuncBuild
{
    function Castle(b)
    {
        baseBuild = b;
    }
}

class RingFighting extends FuncBuild
{
    function RingFighting(b)
    {
        baseBuild = b;
    }
    override function whenFree()
    {
        //global.director.pushScene(new FightingScene());
        return 1;
    }
}
/*
class StaticBuild extends FuncBuild
{
    var solNum;
    function StaticBuild(b)
    {
        baseBuild = b;
solNum = baseBuild.bg.addlabel("50", getFont(), 25, FONT_BOLD).pos(25, 23).anchor(50, 50).color(0, 0, 0);
    }
    override function whenFree()
    {
        global.director.pushView(new SoldierMax(), 1, 0); 
        return 1;
    }
    function receiveMsg(msg)
    {
//        trace("receiveMsg", msg);
        if(msg[0] == BUYSOL)
        {
            solNum.text(str(global.user.getSolNum()));
        }
    }
    override function enterScene()
    {
        global.msgCenter.registerCallback(BUYSOL, this);
        solNum.text(str(global.user.getSolNum()));
    }
    override function exitScene()
    {
        global.msgCenter.removeCallback(BUYSOL, this);
    }
}
*/
