class SucBanner extends MyNode
{
    function SucBanner()
    {
        bg = sprite("storeBlack.png").pos(506, 231).anchor(50, 50);
        bg.addlabel(getStr("buySuc", null), null, 25).pos(154, 25).anchor(50, 50).color(100, 100, 100);
        bg.addaction(sequence(delaytime(1000), callfunc(removeSelf)));
    }
}
