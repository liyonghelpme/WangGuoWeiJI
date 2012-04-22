class Store extends MyNode
{
    var stores;
    var tabs;
    var choose;

    var tabArray;
    function Store()
    {
        bg = sprite("goodBack.png");
        init();
        tabs = new Choice(this);
        addChild(tabs);
        choose = sprite("goodsChoice.png").pos(6, 253).anchor(0, 50);
        bg.add(choose, 1, 1);

    }

}
