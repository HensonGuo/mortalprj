// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Message.Public{

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;



public class SeqByteHelper
{
    public static function write( __os : SerializeStream , __v : Array ) : void 
    {
        __os.writeByteSeq(__v);
    }

    public static function read( __is : SerializeStream ) : Array
    {
        var __v : Array ;
        __v = __is.readByteSeq();
        return __v;
    }
}
}
