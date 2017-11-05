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

import Message.Public.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SNoticeFriendUpdate extends IMessageBase 
{
    [ArrayElementType("int")]
    public var friendIds : Array;

    [ArrayElementType("SAttributeUpdate")]
    public var attrUpdates : Array;

    public function SNoticeFriendUpdate(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SNoticeFriendUpdate = new SNoticeFriendUpdate( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 15118;

    override public function clone() : IMessageBase
    {
        return new SNoticeFriendUpdate;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        SeqIntHelper.write(__os, friendIds);
        SeqAttributeUpdateHelper.write(__os, attrUpdates);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        friendIds = SeqIntHelper.read(__is);
        attrUpdates = SeqAttributeUpdateHelper.read(__is);
    }
}
}

