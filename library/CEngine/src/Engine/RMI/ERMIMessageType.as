// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Engine.RMI{

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;



public class ERMIMessageType
{
    static private const __T : Array =[
    "MessageTypeCall",
    "MessageTypeCallRet",
    "MessageTypeCallRedirect",
    "MessageTypeCallRetRedirect",
    "MessageTypeMQ"];
    
    
    private static var __values : Array = new Array();
    public var __value : int;

    public static const _MessageTypeCall : int = 0;
    public static const MessageTypeCall : ERMIMessageType  = new ERMIMessageType(_MessageTypeCall);
    public static const _MessageTypeCallRet : int = 1;
    public static const MessageTypeCallRet : ERMIMessageType  = new ERMIMessageType(_MessageTypeCallRet);
    public static const _MessageTypeCallRedirect : int = 2;
    public static const MessageTypeCallRedirect : ERMIMessageType  = new ERMIMessageType(_MessageTypeCallRedirect);
    public static const _MessageTypeCallRetRedirect : int = 3;
    public static const MessageTypeCallRetRedirect : ERMIMessageType  = new ERMIMessageType(_MessageTypeCallRetRedirect);
    public static const _MessageTypeMQ : int = 4;
    public static const MessageTypeMQ : ERMIMessageType  = new ERMIMessageType(_MessageTypeMQ);

    public static function convert( val : int ) : ERMIMessageType
    {
        return __values[val];
    }

    public function value() : int
    {
        return __value;
    }

    public function toString() : String
    {
        return __T[__value];
    }

    public function ERMIMessageType( val : int )
    {
        __value = val;
        __values[val] = this;
    }

    public function equals( rhs : Object ) : Boolean 
    {
        if(this == rhs)
        {
            return true;
        }
        var _rs : ERMICallModel = rhs as ERMICallModel;
        if( _rs == null ) 
            return false;
        return this.__value == _rs.value();
    }

    public function hashCode():int
    {
        return 5 * __value;
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeByte( __value );
    }

    public static function __read( __is : SerializeStream ) : ERMIMessageType
    {
        var __v : int = __is.readByte();
        if(__v < 0 || __v >= 5)
        {
            throw new MarshalException();
        }
        return ERMIMessageType.convert(__v);
    }
}
}
