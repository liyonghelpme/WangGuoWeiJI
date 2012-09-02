/*
非全屏对话框 使用 roleNameClose png
全屏对话框使用close2 png
*/
class Template extends MyNode
{
    function Template()
    {
        bg = node().pos(261, 129).size(500, 325);
        init();
    }
    function closeDialog()
    {
        global.director.popView();
    }
}
