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


public class SLotteryHistory extends IMessageBase 
{
    public var type : int;

    public var player : SPublicPlayer;

    public var content : String;

    public function SLotteryHistory(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SLotteryHistory = new SLotteryHistory( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 109;

    override public function clone() : IMessageBase
    {
        return new SLotteryHistory;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(type);
        player.__write(__os);
        __os.writeString(content);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        type = __is.readInt();
        player = new SPublicPlayer();
        player.__read(__is);
        content = __is.readString();
    }
}
}
