class FriendScene extends MyNode
{
    function FriendScene()
    {
        bg = node();
        init();
        addChild(new FriendMenu());
    }
}
