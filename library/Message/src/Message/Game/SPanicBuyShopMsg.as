// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Message.Game{

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SPanicBuyShopMsg
{
    public var code : int;

    public var leftSeconds : int;

    public function SPanicBuyShopMsg()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(code);
        __os.writeInt(leftSeconds);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        code = __is.readInt();
        leftSeconds = __is.readInt();
    }
}
}
