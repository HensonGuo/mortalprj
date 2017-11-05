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


public class SRect
{
    public var topLeft : SPoint;

    public var bottomRight : SPoint;

    public function SRect()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        topLeft.__write(__os);
        bottomRight.__write(__os);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        topLeft = new SPoint();
        topLeft.__read(__is);
        bottomRight = new SPoint();
        bottomRight.__read(__is);
    }
}
}
