class ShadowWords extends MyNode
{
    var shadow;
    function ShadowWords(w, sz, col, ty, bo)
    {
        bg = label(w, ty, sz, bo).color(col);
        init();
        shadow = label(w, ty, sz, bo).color(25, 24, 24).pos(1, 2);
        bg.add(shadow, -1);
    }
    function setWords(w)
    {
        bg.text(w);
        shadow.text(w);
    }
}
