/*-----------------------------------------------------------------------------\
| Extend the array prototype with Array.swap() to exchange two elements.       |
\-----------------------------------------------------------------------------*/
Array.prototype.swap = function(x, y){
    /* Preserve the array receiver when this method is called. */
    var value = this[x];
    this[x] = this[y];
    this[y] = value;
    return this;
};
