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


public class SBuyBackItemMsg extends IMessageBase 
{
    public var type : int;

    public var item : SBuyBackItem;

    public function SBuyBackItemMsg(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SBuyBackItemMsg = new SBuyBackItemMsg( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 15151;

    override public function clone() : IMessageBase
    {
        return new SBuyBackItemMsg;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(type);
        item.__write(__os);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        type = __is.readInt();
        item = new SBuyBackItem();
        item.__read(__is);
    }
}
}
