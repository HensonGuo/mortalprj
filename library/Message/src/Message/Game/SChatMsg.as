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

import Message.Game.*;
import Message.Public.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SChatMsg extends IMessageBase 
{
    public var fromPlayer : SMiniPlayer;

    public var isGm : Boolean;

    public var isGuide : Boolean;

    public var force : int;

    public var toPlayer : String;

    public var toEntityId : SEntityId;

    public var chatType : int;

    public var content : String;

    public var font : int;

    [ArrayElementType("SPlayerItem")]
    public var items : Array;

    [ArrayElementType("SPet")]
    public var pets : Array;

    [ArrayElementType("SPublicMount")]
    public var mounts : Array;

    public var chatDt : Date;

    public function SChatMsg(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SChatMsg = new SChatMsg( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 15051;

    override public function clone() : IMessageBase
    {
        return new SChatMsg;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        fromPlayer.__write(__os);
        __os.writeBool(isGm);
        __os.writeBool(isGuide);
        __os.writeByte(force);
        __os.writeString(toPlayer);
        toEntityId.__write(__os);
        __os.writeInt(chatType);
        __os.writeString(content);
        __os.writeInt(font);
        SeqPlayerItemHelper.write(__os, items);
        SeqPetHelper.write(__os, pets);
        SeqPublicMountHelper.write(__os, mounts);
        __os.writeDate(chatDt);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        fromPlayer = new SMiniPlayer();
        fromPlayer.__read(__is);
        isGm = __is.readBool();
        isGuide = __is.readBool();
        force = __is.readByte();
        toPlayer = __is.readString();
        toEntityId = new SEntityId();
        toEntityId.__read(__is);
        chatType = __is.readInt();
        content = __is.readString();
        font = __is.readInt();
        items = SeqPlayerItemHelper.read(__is);
        pets = SeqPetHelper.read(__is);
        mounts = SeqPublicMountHelper.read(__is);
        chatDt = __is.readDate();
    }
}
}

