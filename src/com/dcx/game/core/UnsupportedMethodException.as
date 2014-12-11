////////////////////////////////////////////////////////////////////////////////
//
//  MICROSOFT CORPORATION
//  Copyright (c) Microsoft Corporation.
//  All Rights Reserved.
//
//  NOTICE: Microsoft Confidential. Intended for Internal Use Only.
//
////////////////////////////////////////////////////////////////////////////////

package com.dcx.game.core
{

public class UnsupportedMethodException extends Error
{

	public static const OVERRIDE:String = "must be overrided";
    public function UnsupportedMethodException(message:String="",
                                               id:int = 0)
    {
        super(message, id);
    }
}

}
