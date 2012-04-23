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
        addChildZ(tabs, -1);
        choose = sprite("goodsChoice.png").pos(134, 266).anchor(50, 50);
        bg.add(choose, 1, 1);

    }

}
