package com.dcx.game.utils.text
{
	import com.adobe.utils.ArrayUtil;
	

public function stringf(format:String, ...rest):String
{ 
    // TODO: This method needs to be extracted into a Formatter class with
    // support for more than basic string replacement (i.e. date formatting,
    // padding, numeric formatting, etc.)
    var values:Array = ArrayUtil.copyArray(rest);
    if (values.length > 0)
    {
        var value:String = values.pop();
        if (null == value)
        {
            value = StringConst.EMPTY;
        }
        format = format.replace(new RegExp("\\{" + values.length + "\\}"), value);
        values.unshift(format);
        return stringf.apply(null, values);
    }
    else return format;
}
}