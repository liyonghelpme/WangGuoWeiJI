class ShadowWords extends MyNode
{
    var shadow;
    function ShadowWords(w, ty, sz, bo, col)
    {
        bg = label(w, "fonts/heiti.ttf", sz, bo).color(col);
        init();
        shadow = label(w, "fonts/heiti.ttf", sz, bo).color(0, 0, 0).pos(1, 2);
        bg.add(shadow, -1);
    }
    function setWords(w)
    {
        bg.text(w);
        shadow.text(w);
    }
}
