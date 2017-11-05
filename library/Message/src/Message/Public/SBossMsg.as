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


public class SBossMsg extends IMessageBase 
{
    public var entityId : SEntityId;

    public var bossCode : int;

    public function SBossMsg(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SBossMsg = new SBossMsg( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 87;

    override public function clone() : IMessageBase
    {
        return new SBossMsg;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        entityId.__write(__os);
        __os.writeInt(bossCode);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        entityId = new SEntityId();
        entityId.__read(__is);
        bossCode = __is.readInt();
    }
}
}
