
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
    override function whenFree()
    {
        return 1; 
    }
}
class Castle extends FuncBuild
{
    function Castle(b)
    {
        baseBuild = b;
    }
}
