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


public class SDrugBagInfo extends IMessageBase 
{
    public var type : int;

    public var remain : int;

    public var useDt : Date;

    public function SDrugBagInfo(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SDrugBagInfo = new SDrugBagInfo( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 15074;

    override public function clone() : IMessageBase
    {
        return new SDrugBagInfo;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(type);
        __os.writeInt(remain);
        __os.writeDate(useDt);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        type = __is.readInt();
        remain = __is.readInt();
        useDt = __is.readDate();
    }
}
}
